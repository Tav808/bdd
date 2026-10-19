<?php
require_once 'db.php';

if (!isset($conn)) {
    $conn = new mysqli('localhost', 'root', '', 'truebuild');
    if ($conn->connect_error) {
        http_response_code(500);
        echo json_encode(['success' => false, 'message' => 'Error de conexión a la base de datos.']);
        exit;
    }
    $conn->set_charset('utf8mb4');
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido.']);
    exit;
}

header('Content-Type: application/json');

$action = $_POST['action'] ?? '';

if ($action === 'get_clientes') {
    try {
        $result = $conn->query("SELECT id_cliente AS id, nombre, apellido, email FROM clientes ORDER BY nombre ASC");
        $clientes = [];
        while ($row = $result->fetch_assoc()) {
            $row['nombre_completo'] = $row['nombre'] . ' ' . $row['apellido'];
            $clientes[] = $row;
        }
        echo json_encode([
            'success' => true,
            'clientes' => $clientes
        ]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error al obtener clientes.']);
    }
    exit;
}

if ($action === 'procesar_pago') {
    $id_pedido = intval($_POST['id_pedido'] ?? 0);
    $monto = floatval($_POST['monto'] ?? 0);
    $metodo_pago = trim($_POST['metodo_pago'] ?? '');

    try {
        if ($id_pedido <= 0 || $monto <= 0 || empty($metodo_pago)) {
            throw new Exception('Complete todos los campos correctamente.');
        }

        $conn->begin_transaction();

        $stmt = $conn->prepare("SELECT total FROM pedido WHERE id_pedido = ?");
        $stmt->bind_param('i', $id_pedido);
        $stmt->execute();
        $result = $stmt->get_result();
        $pedido = $result->fetch_assoc();
        $stmt->close();

        if (!$pedido) {
            throw new Exception('El pedido no existe.');
        }

        if ($monto > $pedido['total']) {
            throw new Exception('El monto no puede ser mayor al total del pedido.');
        }

        $stmt = $conn->prepare("SELECT id_pago FROM pago WHERE id_pedido = ? LIMIT 1");
        $stmt->bind_param('i', $id_pedido);
        $stmt->execute();
        $pago_existente = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if ($pago_existente) {
            $stmt = $conn->prepare("UPDATE pago SET monto = ?, metodoPago = ?, estado = 'completado', fecha_pago = NOW() WHERE id_pedido = ?");
            $stmt->bind_param('dsi', $monto, $metodo_pago, $id_pedido);
            $stmt->execute();
            $stmt->close();
        } else {
            $stmt = $conn->prepare("INSERT INTO pago (id_pedido, monto, metodoPago, estado, fecha_pago) VALUES (?, ?, ?, 'completado', NOW())");
            $stmt->bind_param('ids', $id_pedido, $monto, $metodo_pago);
            $stmt->execute();
            $stmt->close();
        }

        if ($monto >= $pedido['total']) {
            $stmt = $conn->prepare("UPDATE pedido SET estado = 'completado' WHERE id_pedido = ?");
            $stmt->bind_param('i', $id_pedido);
            $stmt->execute();
            $stmt->close();
        }

        $conn->commit();
        echo json_encode([
            'success' => true,
            'message' => 'Pago procesado exitosamente. $' . number_format($monto, 2)
        ]);

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode([
            'success' => false,
            'message' => 'Transacción cancelada: ' . $e->getMessage()
        ]);
    }
    exit;
}

// aca esta lo de transferir plata q hicimos con la base

if ($action === 'transferir') {
    $dni_origen  = trim($_POST['dni_origen'] ?? '');
    $dni_destino = trim($_POST['dni_destino'] ?? '');
    $monto       = floatval($_POST['monto'] ?? 0);

    try {
        if (empty($dni_origen) || empty($dni_destino) || $monto <= 0) {
            throw new Exception('Completá ambos DNI y un monto mayor a 0.');
        }
        if ($dni_origen === $dni_destino) {
            throw new Exception('El DNI de origen y destino no pueden ser iguales.');
        }

        $conn->begin_transaction();

        $stmt = $conn->prepare("UPDATE clientes SET saldo = saldo - ? WHERE dni = ? AND saldo >= ?");
        $stmt->bind_param('dsd', $monto, $dni_origen, $monto);
        $stmt->execute();
        if ($stmt->affected_rows === 0) {
            $stmt->close();
            throw new Exception('Saldo insuficiente o DNI de origen inexistente.');
        }
        $stmt->close();

        $stmt = $conn->prepare("UPDATE clientes SET saldo = saldo + ? WHERE dni = ?");
        $stmt->bind_param('ds', $monto, $dni_destino);
        $stmt->execute();
        if ($stmt->affected_rows === 0) {
            $stmt->close();
            throw new Exception('DNI de destino inexistente.');
        }
        $stmt->close();

        $stmt = $conn->prepare("SELECT id_cliente FROM clientes WHERE dni = ?");
        $stmt->bind_param('s', $dni_origen);
        $stmt->execute();
        $idOrigen = $stmt->get_result()->fetch_assoc()['id_cliente'];
        $stmt->close();

        $stmt = $conn->prepare("SELECT id_cliente FROM clientes WHERE dni = ?");
        $stmt->bind_param('s', $dni_destino);
        $stmt->execute();
        $idDestino = $stmt->get_result()->fetch_assoc()['id_cliente'];
        $stmt->close();

        $stmt = $conn->prepare("INSERT INTO transferencia (id_cliente_origen, id_cliente_destino, monto) VALUES (?, ?, ?)");
        $stmt->bind_param('iid', $idOrigen, $idDestino, $monto);
        $stmt->execute();
        $stmt->close();

        $conn->commit();
        echo json_encode([
            'success' => true,
            'message' => 'Transferencia exitosa de $' . number_format($monto, 2) . '.'
        ]);

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode([
            'success' => false,
            'message' => 'Transacción cancelada: ' . $e->getMessage()
        ]);
    }
    exit;
}

if ($action === 'get_cuentas') {
    try {
        $result = $conn->query("SELECT id_cliente, nombre, apellido, dni, saldo FROM clientes WHERE dni IS NOT NULL ORDER BY nombre ASC");
        $cuentas = [];
        while ($row = $result->fetch_assoc()) {
            $cuentas[] = $row;
        }
        echo json_encode(['success' => true, 'cuentas' => $cuentas]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error al obtener cuentas.']);
    }
    exit;
}

if ($action === 'get_pedidos') {
    $id_cliente = intval($_POST['id_cliente'] ?? 0);

    try {
        if ($id_cliente <= 0) {
            throw new Exception('Cliente no válido.');
        }

        $stmt = $conn->prepare("
            SELECT 
                p.id_pedido,
                p.fecha_pedido,
                p.servicio,
                p.estado,
                p.total,
                COALESCE(pg.monto, 0) as monto_pagado,
                COALESCE(pg.estado, 'pendiente') as estado_pago,
                COALESCE(pg.metodoPago, '') as metodo_pago
            FROM pedido p
            LEFT JOIN pago pg ON p.id_pedido = pg.id_pedido
            WHERE p.id_cliente = ?
            ORDER BY p.fecha_pedido DESC
        ");
        $stmt->bind_param('i', $id_cliente);
        $stmt->execute();
        $result = $stmt->get_result();
        $pedidos = [];
        while ($row = $result->fetch_assoc()) {
            $pedidos[] = $row;
        }
        $stmt->close();

        echo json_encode([
            'success' => true,
            'pedidos' => $pedidos
        ]);

    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    }
    exit;
}

http_response_code(400);
echo json_encode(['success' => false, 'message' => 'Acción no válida.']);
?>
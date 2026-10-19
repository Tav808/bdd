<?php
require_once 'db.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido.']);
    exit;
}

header('Content-Type: application/json');

$action = $_POST['action'] ?? '';

if ($action === 'get_pcs') {
    $result = $conn->query("SELECT id_pc, nombre, descripcion, precio, imagen FROM pcs ORDER BY id_pc ASC");
    $pcs = [];
    while ($row = $result->fetch_assoc()) {
        $pcs[] = $row;
    }
    echo json_encode(['success' => true, 'pcs' => $pcs]);
    exit;
}

if (!isset($_SESSION['emailU'])) {
    echo json_encode(['success' => false, 'message' => 'Tenés que iniciar sesión.']);
    exit;
}
$emailU = $_SESSION['emailU'];

// toma el balance del usuario en la bdd para cada usuario
if ($action === 'get_balance') {
    $stmt = $conn->prepare("SELECT balance FROM usuarios WHERE emailU = ?");
    $stmt->bind_param('s', $emailU);
    $stmt->execute();
    $usuario = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$usuario) {
        echo json_encode(['success' => false, 'message' => 'Usuario no encontrado.']);
        exit;
    }
    echo json_encode(['success' => true, 'balance' => $usuario['balance']]);
    exit;
}

// se realiza la compra del carrito con el balance asignado
if ($action === 'comprar') {
    $ids = array_filter(array_map('intval', explode(',', $_POST['ids'] ?? '')));

    try {
        if (count($ids) === 0) {
            throw new Exception('El carrito está vacío.');
        }

        $conn->begin_transaction();

        $stmt = $conn->prepare("SELECT id_Usuario FROM usuarios WHERE emailU = ?");
        $stmt->bind_param('s', $emailU);
        $stmt->execute();
        $usuario = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        if (!$usuario) {
            throw new Exception('Usuario no encontrado.');
        }
        $idUsuario = $usuario['id_Usuario'];

        $total = 0;
        $precios = [];
        foreach ($ids as $idPc) {
            $stmt = $conn->prepare("SELECT precio FROM pcs WHERE id_pc = ?");
            $stmt->bind_param('i', $idPc);
            $stmt->execute();
            $pc = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if (!$pc) {
                throw new Exception('Una de las PCs del carrito no existe.');
            }
            $precios[$idPc] = $pc['precio'];
            $total += $pc['precio'];
        }

// se realiza la transaccion si alcanza el balance
        $stmt = $conn->prepare("UPDATE usuarios SET balance = balance - ? WHERE id_Usuario = ? AND balance >= ?");
        $stmt->bind_param('did', $total, $idUsuario, $total);
        $stmt->execute();
        if ($stmt->affected_rows === 0) {
            $stmt->close();
            throw new Exception('Balance insuficiente para comprar $' . number_format($total, 0, ',', '.') . '.');
        }
        $stmt->close();

// guarda la c comprada en el registro
        foreach ($ids as $idPc) {
            $stmt = $conn->prepare("INSERT INTO compras (id_Usuario, id_pc, precio) VALUES (?, ?, ?)");
            $stmt->bind_param('iid', $idUsuario, $idPc, $precios[$idPc]);
            $stmt->execute();
            $stmt->close();
        }

        $conn->commit();

// actualiza el balance
        $stmt = $conn->prepare("SELECT balance FROM usuarios WHERE id_Usuario = ?");
        $stmt->bind_param('i', $idUsuario);
        $stmt->execute();
        $balance = $stmt->get_result()->fetch_assoc()['balance'];
        $stmt->close();

        echo json_encode([
            'success' => true,
            'message' => '¡Compra realizada! Total: $' . number_format($total, 0, ',', '.'),
            'balance' => $balance
        ]);

    } catch (Exception $e) {
        $conn->rollback();
        echo json_encode(['success' => false, 'message' => $e->getMessage()]);
    }
    exit;
}

// muestra registro de compras en orden
if ($action === 'get_compras') {
    $stmt = $conn->prepare("
        SELECT c.id_compra, c.fecha_compra, p.nombre, c.precio
        FROM compras c
        JOIN pcs p ON p.id_pc = c.id_pc
        JOIN usuarios u ON u.id_Usuario = c.id_Usuario
        WHERE u.emailU = ?
        ORDER BY c.fecha_compra DESC, c.id_compra DESC
    ");
    $stmt->bind_param('s', $emailU);
    $stmt->execute();
    $result = $stmt->get_result();
    $compras = [];
    while ($row = $result->fetch_assoc()) {
        $compras[] = $row;
    }
    $stmt->close();

    echo json_encode(['success' => true, 'compras' => $compras]);
    exit;
}

http_response_code(400);
echo json_encode(['success' => false, 'message' => 'Acción no válida.']);
?>

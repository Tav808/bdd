<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include_once('conexion.php');
$conn = $conn ?? $pdo;

$mensaje = '';
$tipo_mensaje = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $dni_origen  = trim($_POST['dni_origen'] ?? '');
    $dni_destino = trim($_POST['dni_destino'] ?? '');
    $monto       = floatval($_POST['monto'] ?? 0);

    try {
        if (empty($dni_origen) || empty($dni_destino) || $monto <= 0) {
            throw new Exception("Complete todos los campos con un monto mayor a 0.");
        }

        if ($dni_origen === $dni_destino) {
            throw new Exception("El DNI de origen y destino no pueden ser iguales.");
        }

        $conn->beginTransaction();

        $stmt1 = $conn->prepare("UPDATE cuentas SET saldo = saldo - :monto WHERE dni = :dni AND (saldo - :monto) >= 0");
        $stmt1->execute([
            ':monto' => $monto,
            ':dni'   => $dni_origen
        ]);

        if ($stmt1->rowCount() === 0) {
            throw new Exception("No se pudo debitar de la cuenta origen. Saldo insuficiente o DNI inexistente.");
        }

        $stmt2 = $conn->prepare("UPDATE cuentas SET saldo = saldo + :monto WHERE dni = :dni");
        $stmt2->execute([
            ':monto' => $monto,
            ':dni'   => $dni_destino
        ]);

        if ($stmt2->rowCount() === 0) {
            throw new Exception("No se pudo acreditar en la cuenta destino. DNI inexistente.");
        }

        $conn->commit();
        $mensaje = "Transferencia exitosa de $" . number_format($monto, 2) . ".";
        $tipo_mensaje = 'success';

    } catch (Exception $e) {
        if ($conn->inTransaction()) {
            $conn->rollBack();
        }
        $mensaje = "Transacción cancelada (Rollback): " . $e->getMessage();
        $tipo_mensaje = 'error';
    }
}

// Consultar lista de cuentas
$cuentas = [];
try {
    $stmt = $conn->query("SELECT * FROM cuentas");
    $cuentas = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (Exception $e) {
    $cuentas = [];
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistema de Transferencias</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #DE573C;
            --card-bg: #DB8472;
            --card-border: #334155;
            --primary: #EBB0B0;
            --primary-hover: #EBB0B0;
            --text-main: #000000;
            --text-muted: #000000;
            --success-bg: rgba(16, 185, 129, 0.15);
            --success-border: #10b981;
            --success-text: #000000;
            --error-bg: #F5C9C9;
            --error-border: #ef4444;
            --error-text: #000000;
            --input-bg: #ffe0e4;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem 1rem;
        }

        .container {
            width: 100%;
            max-width: 900px;
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 2rem;
        }

        @media (max-width: 768px) {
            .container {
                grid-template-columns: 1fr;
            }
        }

        .card {
            background: var(--card-bg);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
        }

        h1 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        input {
            width: 100%;
            padding: 0.75rem 1rem;
            background: var(--input-bg);
            border: 1px solid var(--card-border);
            border-radius: 8px;
            color: var(--text-main);
            font-size: 1rem;
            outline: none;
        }

        button {
            width: 100%;
            padding: 0.875rem;
            background: var(--primary);
            color: #000;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-top: 0.5rem;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
            line-height: 1.4;
            border-left: 4px solid;
        }

        .alert-success {
            background: var(--success-bg);
            border-color: var(--success-border);
            color: var(--success-text);
        }

        .alert-error {
            background: var(--error-bg);
            border-color: var(--error-border);
            color: var(--error-text);
        }

        .table-card h2 {
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
        }

        th, td {
            text-align: left;
            padding: 0.75rem 0.5rem;
            border-bottom: 1px solid var(--card-border);
        }

        .balance {
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Formulario -->
        <div class="card">
            <h1>Transferencia Bancaria</h1>

            <?php if (!empty($mensaje)): ?>
                <div class="alert alert-<?= $tipo_mensaje ?>">
                    <?= htmlspecialchars($mensaje) ?>
                </div>
            <?php endif; ?>

            <form action="" method="POST">
                <div class="form-group">
                    <label for="dni_origen">DNI Origen (Su DNI)</label>
                    <input type="text" id="dni_origen" name="dni_origen" placeholder="Ej: 11111111" required 
                           value="<?= htmlspecialchars($_POST['dni_origen'] ?? '') ?>">
                </div>

                <div class="form-group">
                    <label for="dni_destino">DNI Destino</label>
                    <input type="text" id="dni_destino" name="dni_destino" placeholder="Ej: 22222222" required
                           value="<?= htmlspecialchars($_POST['dni_destino'] ?? '') ?>">
                </div>

                <div class="form-group">
                    <label for="monto">Monto a Debitar ($)</label>
                    <input type="number" id="monto" name="monto" step="0.01" min="0.01" placeholder="Ej: 500.00" required
                           value="<?= htmlspecialchars($_POST['monto'] ?? '') ?>">
                </div>

                <button type="submit">Realizar Transacción</button>
            </form>
        </div>

        <!-- Tabla con Saldos -->
        <div class="card table-card">
            <h2>Cuentas</h2>

            <?php if (!empty($cuentas)): ?>
                <table>
                    <thead>
                        <tr>
                            <th>DNI</th>
                            <th>Saldo</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($cuentas as $c): ?>
                            <tr>
                                <td><code><?= htmlspecialchars($c['dni'] ?? $c['id']) ?></code></td>
                                <td class="balance">$<?= number_format($c['saldo'], 2) ?></td>
                            </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            <?php else: ?>
                <p style="font-size: 0.9rem;">No se encontraron cuentas en la base de datos.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>

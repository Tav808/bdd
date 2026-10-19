<?php

include 'db.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido.']);
    exit;
}

header('Content-Type: application/json');

$emailU      = trim($_POST['emailU']      ?? '');
$contrasenaU = trim($_POST['contrasenaU'] ?? '');

if (empty($emailU) || !filter_var($emailU, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'message' => 'Ingresá un email válido.']);
    exit;
}
if (empty($contrasenaU)) {
    echo json_encode(['success' => false, 'message' => 'Ingresá tu contraseña.']);
    exit;
}

$stmt = $conn->prepare("
    SELECT contrasenaU, nombreU, apellidoU
    FROM usuarios
    WHERE emailU = ?
    LIMIT 1
");
$stmt->bind_param('s', $emailU);
$stmt->execute();
$stmt->bind_result($hashGuardado, $nombreU, $apellidoU);

if (!$stmt->fetch()) {

    $stmt->close();
    echo json_encode(['success' => false, 'message' => 'Email o contraseña incorrectos.']);
    exit;
}
$stmt->close();


if (!password_verify($contrasenaU, $hashGuardado)) {
    echo json_encode(['success' => false, 'message' => 'Email o contraseña incorrectos.']);
    exit;
}

$_SESSION['emailU']    = $emailU;
$_SESSION['nombreU']   = $nombreU;
$_SESSION['apellidoU'] = $apellidoU;

echo json_encode([
    'success'  => true,
    'message'  => '¡Bienvenido, ' . htmlspecialchars($nombreU) . '!',
    'nombre'   => htmlspecialchars($nombreU),
    'apellido' => htmlspecialchars($apellidoU),
    'redirect' => 'truebuild-pc.html'
]);
exit;
?>

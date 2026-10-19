<?php

include 'db.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Método no permitido.']);
    exit;
}

header('Content-Type: application/json');

$nombreU    = trim($_POST['nombreU']    ?? '');
$apellidoU  = trim($_POST['apellidoU'] ?? '');
$emailU     = trim($_POST['emailU']    ?? '');
$contrasena = $_POST['contrasenaU']    ?? '';
$confirmar  = $_POST['confirmarU']     ?? '';

if (empty($nombreU)) {
    echo json_encode(['success' => false, 'message' => 'Ingresá tu nombre.']);
    exit;
}
if (empty($apellidoU)) {
    echo json_encode(['success' => false, 'message' => 'Ingresá tu apellido.']);
    exit;
}
if (empty($emailU) || !filter_var($emailU, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'message' => 'Ingresá un email válido.']);
    exit;
}
if (strlen($contrasena) < 6) {
    echo json_encode(['success' => false, 'message' => 'La contraseña debe tener al menos 6 caracteres.']);
    exit;
}
if ($contrasena !== $confirmar) {
    echo json_encode(['success' => false, 'message' => 'Las contraseñas no coinciden.']);
    exit;
}

$check = $conn->prepare("SELECT 1 FROM usuarios WHERE emailU = ? LIMIT 1");
$check->bind_param('s', $emailU);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    $check->close();
    echo json_encode(['success' => false, 'message' => 'Ese email ya está registrado.']);
    exit;
}
$check->close();

$hashContrasena = password_hash($contrasena, PASSWORD_DEFAULT);

$stmt = $conn->prepare("
    INSERT INTO usuarios (nombreU, apellidoU, emailU, contrasenaU)
    VALUES (?, ?, ?, ?)
");
$stmt->bind_param('ssss', $nombreU, $apellidoU, $emailU, $hashContrasena);

if (!$stmt->execute()) {
    $stmt->close();
    echo json_encode(['success' => false, 'message' => 'Error al crear la cuenta. Intentá de nuevo.']);
    exit;
}
$stmt->close();

$_SESSION['emailU']    = $emailU;
$_SESSION['nombreU']   = $nombreU;
$_SESSION['apellidoU'] = $apellidoU;

echo json_encode([
    'success'  => true,
    'message'  => '¡Cuenta creada! Bienvenido, ' . htmlspecialchars($nombreU) . '.',
    'nombre'   => htmlspecialchars($nombreU),
    'apellido' => htmlspecialchars($apellidoU),
    'redirect' => 'truebuild-pc.html'
]);
exit;
?>

<?php

$host = 'localhost';
$user = 'root';
$pass = '';
$db   = 'truebuild';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode([
        'success' => false,
        'message' => 'Error de conexión a la base de datos.'
    ]));
}

$conn->set_charset('utf8mb4');
?>

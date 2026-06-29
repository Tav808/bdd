-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-06-2026 a las 01:36:16
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `truebuild`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `administrador_resp`
--

CREATE TABLE `administrador_resp` (
  `id_empleado` int(11) NOT NULL,
  `sector` varchar(100) DEFAULT NULL,
  `sueldo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `administrador_resp`
--

INSERT INTO `administrador_resp` (`id_empleado`, `sector`, `sueldo`) VALUES
(5, 'Administracion General', 130000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `telefono` int(15) DEFAULT NULL,
  `direccion` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre`, `apellido`, `email`, `telefono`, `direccion`) VALUES
(1, 'Lucas', 'Fernandez', 'lucas@gmail.com', 1123456789, 'Av. Corrientes 123'),
(2, 'Sofia', 'Ramirez', 'sofia@gmail.com', 1134567890, 'Av. Santa Fe 456'),
(3, 'Matias', 'Torres', 'matias@gmail.com', 1145678901, 'Av. Rivadavia 789');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `componente`
--

CREATE TABLE `componente` (
  `id_componente` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `modelo` varchar(50) DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `precio` float DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `id_proveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `componente`
--

INSERT INTO `componente` (`id_componente`, `nombre`, `modelo`, `marca`, `precio`, `stock`, `id_proveedor`) VALUES
(1, 'Procesador', 'Core i5-12400', 'Intel', 85000, 10, 1),
(2, 'Procesador', 'Ryzen 5 5600', 'AMD', 79000, 8, 2),
(3, 'RAM', 'Vengeance 16GB', 'Corsair', 35000, 15, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id_detalle_pedido` int(11) NOT NULL,
  `cantidad` int(50) DEFAULT NULL,
  `precioUnitario` float DEFAULT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `id_componente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id_detalle_pedido`, `cantidad`, `precioUnitario`, `id_pedido`, `id_componente`) VALUES
(1, 1, 85000, 1, 1),
(2, 2, 35000, 1, 3),
(3, 1, 79000, 2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id_empleado` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `rol` varchar(30) DEFAULT NULL,
  `telefono` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id_empleado`, `nombre`, `apellido`, `email`, `rol`, `telefono`) VALUES
(1, 'Carlos', 'Gomez', 'carlos@truebuild.com', 'tecnico', 1134567890),
(2, 'Maria', 'Lopez', 'maria@truebuild.com', 'vendedor', 1145678901),
(3, 'Jorge', 'Perez', 'jorge@truebuild.com', 'gerente', 1156789012),
(4, 'Ana', 'Sanchez', 'ana@truebuild.com', 'tester', 1167890123),
(5, 'Luis', 'Martinez', 'luis@truebuild.com', 'administrador', 1178901234);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ensamblado`
--

CREATE TABLE `ensamblado` (
  `id_ensamblado` int(11) NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `notas` varchar(100) DEFAULT NULL,
  `id_pedido` int(11) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `ensamblado`
--

INSERT INTO `ensamblado` (`id_ensamblado`, `fecha_inicio`, `fecha_fin`, `estado`, `notas`, `id_pedido`, `id_empleado`) VALUES
(1, '2026-04-02', '2026-04-04', 'completado', 'Armado sin inconvenientes', 1, 1),
(2, '2026-04-11', NULL, 'en proceso', 'Esperando componente RAM', 3, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gerente`
--

CREATE TABLE `gerente` (
  `id_empleado` int(11) NOT NULL,
  `area` varchar(100) DEFAULT NULL,
  `bonusAnual` int(11) DEFAULT NULL,
  `sueldo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `gerente`
--

INSERT INTO `gerente` (`id_empleado`, `area`, `bonusAnual`, `sueldo`) VALUES
(3, 'Ventas', 50000, 300000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `id_pago` int(11) NOT NULL,
  `fecha_pago` date DEFAULT NULL,
  `monto` float DEFAULT NULL,
  `metodoPago` varchar(100) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `id_pedido` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`id_pago`, `fecha_pago`, `monto`, `metodoPago`, `estado`, `id_pedido`) VALUES
(1, '2026-04-02', 250000, 'transferencia', 'completado', 1),
(2, '2026-04-06', 180000, 'efectivo', 'completado', 2),
(3, '2026-04-11', 160000, 'tarjeta', 'pendiente', 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `id_pedido` int(11) NOT NULL,
  `fecha_pedido` date DEFAULT NULL,
  `servicio` varchar(50) DEFAULT NULL,
  `estado` varchar(100) DEFAULT NULL,
  `total` float DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL,
  `id_presupuesto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `pedido`
--

INSERT INTO `pedido` (`id_pedido`, `fecha_pedido`, `servicio`, `estado`, `total`, `id_cliente`, `id_empleado`, `id_presupuesto`) VALUES
(1, '2026-04-02', 'armado_pc', 'en proceso', 250000, 1, 1, 1),
(2, '2026-04-06', 'venta_componentes', 'completado', 180000, 2, 2, 2),
(3, '2026-04-11', 'armado_pc', 'pendiente', 320000, 3, 1, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `presupuesto`
--

CREATE TABLE `presupuesto` (
  `id_presupuesto` int(11) NOT NULL,
  `fecha_creacion` date DEFAULT NULL,
  `fecha_vigencia` date DEFAULT NULL,
  `montoTotal` float DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_empleado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `presupuesto`
--

INSERT INTO `presupuesto` (`id_presupuesto`, `fecha_creacion`, `fecha_vigencia`, `montoTotal`, `estado`, `id_cliente`, `id_empleado`) VALUES
(1, '2026-04-01', '2026-04-30', 250000, 'aprobado', 1, 2),
(2, '2026-04-05', '2026-05-05', 180000, 'pendiente', 2, 2),
(3, '2026-04-10', '2026-05-10', 320000, 'aprobado', 3, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `id_proveedor` int(11) NOT NULL,
  `marca` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `telefono` int(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`id_proveedor`, `marca`, `email`, `telefono`) VALUES
(1, 'Intel', 'contacto@intel.com', 1134567890),
(2, 'AMD', 'contacto@amd.com', 1145678901),
(3, 'Corsair', 'contacto@corsair.com', 1156789012);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tecnico`
--

CREATE TABLE `tecnico` (
  `id_empleado` int(11) NOT NULL,
  `especialidad` varchar(100) DEFAULT NULL,
  `nivelCertificacion` varchar(50) DEFAULT NULL,
  `sueldo` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tecnico`
--

INSERT INTO `tecnico` (`id_empleado`, `especialidad`, `nivelCertificacion`, `sueldo`) VALUES
(1, 'Ensamblado de PC', 'Avanzado', 150000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tester`
--

CREATE TABLE `tester` (
  `id_empleado` int(11) NOT NULL,
  `tipotest` varchar(100) DEFAULT NULL,
  `sueldo` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `tester`
--

INSERT INTO `tester` (`id_empleado`, `tipotest`, `sueldo`) VALUES
(4, 'Control de calidad', 120000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_Usuario` int(20) NOT NULL,
  `nombreU` varchar(50) NOT NULL,
  `apellidoU` varchar(50) NOT NULL,
  `emailU` varchar(100) NOT NULL,
  `contrasenaU` varchar(255) NOT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_Usuario`, `nombreU`, `apellidoU`, `emailU`, `contrasenaU`, `fecha_creacion`) VALUES
(1, 'Octavio', 'Pagni', 'octaviopagniok@gmail.com', '$2y$10$hLMT/UBYTojZDUoovmUPiebN1o.m0bQvGTUB90I/G0DQTeH2rBgra', '2026-06-12 00:14:27'),
(2, 'Thiago', 'Llano', 'thiaguin@gmail.com', '$2y$10$cHvsj7vsfvgZfaROSNdXvOv8vifG2YcNqnaGGMV8GWL/L3Rv.dEt6', '2026-06-12 16:07:55'),
(3, 'Nacho', 'Gutierrez', 'nachito777@gmail.com', '$2y$10$tGe80NiBWR7OmBDODUR4xOu22lHeve15rYUJKuvwFNF5/mkveYzBS', '2026-06-12 16:10:56'),
(4, 'Lucia', 'Dos Santos', 'lukavolve33@gmail.com', '$2y$10$BXKyiOWHQEEQ5aWgRv/Ho.USVCPLzJf.l4RAeIxuA.9jn5BzwolR2', '2026-06-12 16:12:48'),
(5, 'Octavio', 'Pagni', 'octaviopagni@gmail.com', '$2y$10$DAFUGaibEqqpC.TYw8IjouUNsqlulatrjkCGHtXrv8tbwaQ8Gq9J.', '2026-06-12 17:07:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedor`
--

CREATE TABLE `vendedor` (
  `id_empleado` int(11) NOT NULL,
  `comision` float DEFAULT NULL,
  `productosvendidos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Volcado de datos para la tabla `vendedor`
--

INSERT INTO `vendedor` (`id_empleado`, `comision`, `productosvendidos`) VALUES
(2, 15.5, 20);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `administrador_resp`
--
ALTER TABLE `administrador_resp`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `componente`
--
ALTER TABLE `componente`
  ADD PRIMARY KEY (`id_componente`),
  ADD KEY `id_proveedor` (`id_proveedor`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id_detalle_pedido`),
  ADD KEY `id_pedido` (`id_pedido`),
  ADD KEY `id_componente` (`id_componente`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `ensamblado`
--
ALTER TABLE `ensamblado`
  ADD PRIMARY KEY (`id_ensamblado`),
  ADD KEY `id_pedido` (`id_pedido`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `gerente`
--
ALTER TABLE `gerente`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`id_pago`),
  ADD KEY `id_pedido` (`id_pedido`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_empleado` (`id_empleado`),
  ADD KEY `id_presupuesto` (`id_presupuesto`);

--
-- Indices de la tabla `presupuesto`
--
ALTER TABLE `presupuesto`
  ADD PRIMARY KEY (`id_presupuesto`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`id_proveedor`);

--
-- Indices de la tabla `tecnico`
--
ALTER TABLE `tecnico`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `tester`
--
ALTER TABLE `tester`
  ADD PRIMARY KEY (`id_empleado`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_Usuario`),
  ADD UNIQUE KEY `emailU` (`emailU`),
  ADD KEY `idx_emailU` (`emailU`);

--
-- Indices de la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD PRIMARY KEY (`id_empleado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `componente`
--
ALTER TABLE `componente`
  MODIFY `id_componente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `id_detalle_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `ensamblado`
--
ALTER TABLE `ensamblado`
  MODIFY `id_ensamblado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `presupuesto`
--
ALTER TABLE `presupuesto`
  MODIFY `id_presupuesto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_Usuario` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `administrador_resp`
--
ALTER TABLE `administrador_resp`
  ADD CONSTRAINT `administrador_resp_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `componente`
--
ALTER TABLE `componente`
  ADD CONSTRAINT `componente_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`);

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  ADD CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`id_componente`) REFERENCES `componente` (`id_componente`);

--
-- Filtros para la tabla `ensamblado`
--
ALTER TABLE `ensamblado`
  ADD CONSTRAINT `ensamblado_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  ADD CONSTRAINT `ensamblado_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `gerente`
--
ALTER TABLE `gerente`
  ADD CONSTRAINT `gerente_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`);

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `pedido_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`),
  ADD CONSTRAINT `pedido_ibfk_3` FOREIGN KEY (`id_presupuesto`) REFERENCES `presupuesto` (`id_presupuesto`);

--
-- Filtros para la tabla `presupuesto`
--
ALTER TABLE `presupuesto`
  ADD CONSTRAINT `presupuesto_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `presupuesto_ibfk_2` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`);

--
-- Filtros para la tabla `tecnico`
--
ALTER TABLE `tecnico`
  ADD CONSTRAINT `tecnico_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tester`
--
ALTER TABLE `tester`
  ADD CONSTRAINT `tester_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `vendedor`
--
ALTER TABLE `vendedor`
  ADD CONSTRAINT `vendedor_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id_empleado`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

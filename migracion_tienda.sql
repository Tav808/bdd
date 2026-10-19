-- Migración TrueBuild PC: balance ficticio, PCs preensambladas y registro de compras
-- Ejecutar UNA vez sobre la base `truebuild` ya existente (phpMyAdmin > SQL).
-- Si importás truebuild.sql desde cero, NO hace falta correr este archivo.

-- 1) Cada usuario tiene un balance ficticio (los usuarios existentes arrancan con $3.000.000)
ALTER TABLE `usuarios`
  ADD COLUMN `balance` decimal(12,2) NOT NULL DEFAULT 3000000.00;

-- 2) PCs preensambladas que se venden en la página de inicio
CREATE TABLE `pcs` (
  `id_pc` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  `descripcion` varchar(150) NOT NULL,
  `precio` decimal(12,2) NOT NULL,
  `imagen` varchar(100) NOT NULL,
  PRIMARY KEY (`id_pc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `pcs` (`nombre`, `descripcion`, `precio`, `imagen`) VALUES
('PC Oficina Básica',     'Core i3-12100 · 8GB RAM · SSD 240GB',                       650000, 'img/pc1.svg'),
('PC Hogar Plus',         'Ryzen 5 4500 · 16GB RAM · SSD 480GB',                       850000, 'img/pc2.svg'),
('PC Estudiante',         'Core i5-12400 · 16GB RAM · SSD 500GB',                     1050000, 'img/pc3.svg'),
('PC Gamer Inicial',      'Ryzen 5 5600 · RX 6600 · 16GB RAM · SSD 500GB',            1350000, 'img/pc4.svg'),
('PC Gamer Medio',        'Core i5-12400F · RTX 4060 · 16GB RAM · SSD 1TB',           1750000, 'img/pc5.svg'),
('PC Gamer Pro',          'Ryzen 7 5700X · RTX 4060 Ti · 32GB RAM · SSD 1TB',         2300000, 'img/pc6.svg'),
('PC Diseño y Edición',   'Ryzen 7 7700 · RTX 4070 · 32GB RAM · SSD 1TB',             2900000, 'img/pc7.svg'),
('PC Streamer',           'Core i7-13700F · RTX 4070 Super · 32GB RAM · SSD 2TB',     3300000, 'img/pc8.svg'),
('PC Workstation Extrema','Ryzen 9 7950X · RTX 4080 Super · 64GB RAM · SSD 2TB',      4800000, 'img/pc9.svg');

-- 3) Registro (log) de compras: una fila por cada PC comprada
CREATE TABLE `compras` (
  `id_compra` int(11) NOT NULL AUTO_INCREMENT,
  `id_Usuario` int(20) NOT NULL,
  `id_pc` int(11) NOT NULL,
  `precio` decimal(12,2) NOT NULL,
  `fecha_compra` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_compra`),
  KEY `id_Usuario` (`id_Usuario`),
  KEY `id_pc` (`id_pc`),
  CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`id_Usuario`) REFERENCES `usuarios` (`id_Usuario`),
  CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`id_pc`) REFERENCES `pcs` (`id_pc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

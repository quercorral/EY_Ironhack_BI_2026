-- ==========================================
-- PASO 1: Crear la base de datos
-- ==========================================
CREATE DATABASE IF NOT EXISTS TikTokDB;
USE TikTokDB;

-- ==========================================
-- PASO 2: Crear las tablas
-- ==========================================

-- Tabla 1: Usuarios
CREATE TABLE Usuarios (
    usuario_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATE NOT NULL,
    pais_origen VARCHAR(50) NOT NULL
);

-- Tabla 2: Videos
CREATE TABLE Videos (
    video_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_publicacion DATETIME NOT NULL,
    duracion_segundos INT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id) ON DELETE CASCADE
);

-- Tabla 3: Comentarios
CREATE TABLE Comentarios (
    comentario_id INT AUTO_INCREMENT PRIMARY KEY,
    video_id INT NOT NULL,
    usuario_id INT NOT NULL, -- Usuario que hace el comentario
    texto_comentario TEXT NOT NULL,
    fecha_comentario DATETIME NOT NULL,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id) ON DELETE CASCADE
);

-- Tabla 4: Likes
CREATE TABLE Likes (
    like_id INT AUTO_INCREMENT PRIMARY KEY,
    video_id INT NOT NULL,
    usuario_id INT NOT NULL, -- Usuario que da el like
    fecha_like DATETIME NOT NULL,
    FOREIGN KEY (video_id) REFERENCES Videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id) ON DELETE CASCADE,
    UNIQUE(video_id, usuario_id) -- Evita que un usuario le dé like al mismo video dos veces
);

-- Tabla 5: Seguidores
CREATE TABLE Seguidores (
    seguidor_id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_seguidor INT NOT NULL, -- El que sigue
    usuario_seguido INT NOT NULL,  -- El que es seguido
    fecha_seguimiento DATETIME NOT NULL,
    FOREIGN KEY (usuario_seguidor) REFERENCES Usuarios(usuario_id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_seguido) REFERENCES Usuarios(usuario_id) ON DELETE CASCADE,
    UNIQUE(usuario_seguidor, usuario_seguido) -- Evita duplicados en el seguimiento
);

-- ==========================================
-- PASO 3: Insertar datos de ejemplo
-- ==========================================

INSERT INTO Usuarios (nombre_usuario, correo_electronico, fecha_registro, pais_origen) VALUES
('charlidamelio', 'charli@example.com', '2019-05-15', 'USA'),
('khaby.lame', 'khaby@example.com', '2020-03-01', 'Italy'),
('rosalia', 'motomami@example.com', '2021-01-20', 'Spain'),
('ibai', 'ibai@example.com', '2020-08-10', 'Spain');

INSERT INTO Videos (usuario_id, titulo, descripcion, fecha_publicacion, duracion_segundos) VALUES
(1, 'Dance challenge', 'Doing the renegade!', '2023-10-01 14:00:00', 15),
(2, 'Life hack reaction', 'It is that simple 🤷‍♂️', '2023-10-02 10:30:00', 20),
(3, 'Bizcochito trend', 'Buscando el bizcochito', '2023-10-03 18:00:00', 30),
(4, 'Reaccionando a setup', 'Increíble este PC', '2023-10-04 20:15:00', 60);

INSERT INTO Comentarios (video_id, usuario_id, texto_comentario, fecha_comentario) VALUES
(1, 2, 'Great moves!', '2023-10-01 14:05:00'),
(2, 1, 'So true haha', '2023-10-02 11:00:00'),
(3, 4, 'Temazo', '2023-10-03 18:30:00'),
(1, 3, 'Me encanta', '2023-10-01 15:00:00');

INSERT INTO Likes (video_id, usuario_id, fecha_like) VALUES
(1, 2, '2023-10-01 14:02:00'),
(1, 3, '2023-10-01 14:10:00'),
(2, 4, '2023-10-02 10:45:00'),
(3, 1, '2023-10-03 18:15:00');

INSERT INTO Seguidores (usuario_seguidor, usuario_seguido, fecha_seguimiento) VALUES
(2, 1, '2021-01-01 12:00:00'),
(3, 1, '2021-02-15 09:00:00'),
(4, 3, '2022-01-10 15:30:00'),
(1, 4, '2022-02-20 20:00:00');

-- ==========================================
-- PASO 4: Consultar los datos
-- ==========================================

-- Ver todos los usuarios de TikTok
SELECT * FROM Usuarios;

-- Ver todos los videos publicados
SELECT * FROM Videos;

-- Ver los comentarios realizados en los videos
SELECT * FROM Comentarios;

-- Ver todos los likes dados a los videos
SELECT * FROM Likes;

-- Ver las relaciones de seguimiento entre los usuarios
SELECT * FROM Seguidores;


-- ==========================================
-- 💡 EXTRA: 3 Queries creativas y avanzadas
-- ==========================================

-- 1. ¿Qué video tiene más Likes? (Uso de JOIN y GROUP BY)
SELECT v.titulo, u.nombre_usuario AS creador, COUNT(l.like_id) AS total_likes
FROM Videos v
JOIN Usuarios u ON v.usuario_id = u.usuario_id
LEFT JOIN Likes l ON v.video_id = l.video_id
GROUP BY v.video_id
ORDER BY total_likes DESC;

-- 2. Mostrar un feed de comentarios con el nombre del usuario que comentó y en qué video (Legibilidad)
SELECT c.fecha_comentario, u.nombre_usuario AS comentarista, v.titulo AS video, c.texto_comentario
FROM Comentarios c
JOIN Usuarios u ON c.usuario_id = u.usuario_id
JOIN Videos v ON c.video_id = v.video_id
ORDER BY c.fecha_comentario DESC;

-- 3. ¿Quién sigue a quién? (Self-JOIN con la tabla de Usuarios para ver los nombres en lugar de IDs)
SELECT seguidor.nombre_usuario AS sigue_a, seguido.nombre_usuario AS es_seguido, s.fecha_seguimiento
FROM Seguidores s
JOIN Usuarios seguidor ON s.usuario_seguidor = seguidor.usuario_id
JOIN Usuarios seguido ON s.usuario_seguido = seguido.usuario_id;
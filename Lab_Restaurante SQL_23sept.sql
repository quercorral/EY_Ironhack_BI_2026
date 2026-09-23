USE Restaurante;

-- 1. Total gastado por cada cliente
SELECT s.customer_id, SUM(m.price) AS total_gastado
FROM sales AS s
JOIN menu AS m ON m.product_id = s.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;


-- 2. Días distintos que visitó cada cliente
SELECT customer_id, COUNT(DISTINCT order_date) AS dias_visitados
FROM sales
GROUP BY customer_id
ORDER BY customer_id;


-- 3. Primer artículo comprado por cada cliente.
-- Si compró varios artículos en su primer día, aparecen todos.
WITH primeras_compras AS (
    SELECT customer_id, MIN(order_date) AS primera_fecha
    FROM sales
    GROUP BY customer_id
)
SELECT s.customer_id, m.product_name, s.order_date
FROM sales AS s
JOIN primeras_compras AS p
    ON p.customer_id = s.customer_id
   AND p.primera_fecha = s.order_date
JOIN menu AS m ON m.product_id = s.product_id
ORDER BY s.customer_id, m.product_name;


-- 4. Artículo(s) más comprado(s) entre todos los clientes.
-- Devuelve todos los artículos empatados en el primer puesto.
WITH conteo AS (
    SELECT m.product_id, m.product_name, COUNT(*) AS veces_comprado
    FROM sales AS s
    JOIN menu AS m ON m.product_id = s.product_id
    GROUP BY m.product_id, m.product_name
)
SELECT product_name, veces_comprado
FROM conteo
WHERE veces_comprado = (SELECT MAX(veces_comprado) FROM conteo);


-- 5. Artículo(s) más popular(es) para cada cliente.
-- Devuelve todos los artículos empatados por cliente.
WITH conteo AS (
    SELECT s.customer_id, m.product_id, m.product_name,
           COUNT(*) AS veces_comprado
    FROM sales AS s
    JOIN menu AS m ON m.product_id = s.product_id
    GROUP BY s.customer_id, m.product_id, m.product_name
),
clasificacion AS (
    SELECT conteo.*,
           DENSE_RANK() OVER (
               PARTITION BY customer_id
               ORDER BY veces_comprado DESC
           ) AS posicion
    FROM conteo
)
SELECT customer_id, product_name, veces_comprado
FROM clasificacion
WHERE posicion = 1
ORDER BY customer_id, product_name;


-- 6. Primer artículo comprado en la fecha de ingreso o después.
-- Si hay varios artículos en la primera fecha, aparecen todos.
WITH compras AS (
    SELECT s.customer_id, s.product_id, s.order_date,
           MIN(s.order_date) OVER (
               PARTITION BY s.customer_id
           ) AS fecha_compra
    FROM sales AS s
    JOIN members AS mb ON mb.customer_id = s.customer_id
    WHERE s.order_date >= mb.join_date
)
SELECT c.customer_id, m.product_name, c.order_date
FROM compras AS c
JOIN menu AS m ON m.product_id = c.product_id
WHERE c.order_date = c.fecha_compra
ORDER BY c.customer_id, m.product_name;


-- 7. Artículo(s) comprado(s) justo antes de convertirse en miembro.
-- Se consideran los artículos de la última fecha anterior al ingreso.
WITH compras AS (
    SELECT s.customer_id, s.product_id, s.order_date,
           MAX(s.order_date) OVER (
               PARTITION BY s.customer_id
           ) AS fecha_compra
    FROM sales AS s
    JOIN members AS mb ON mb.customer_id = s.customer_id
    WHERE s.order_date < mb.join_date
)
SELECT c.customer_id, m.product_name, c.order_date
FROM compras AS c
JOIN menu AS m ON m.product_id = c.product_id
WHERE c.order_date = c.fecha_compra
ORDER BY c.customer_id, m.product_name;


-- 8. Artículos y gasto de cada miembro antes de ingresar al programa
SELECT mb.customer_id,
       COUNT(s.product_id) AS total_articulos,
       COALESCE(SUM(m.price), 0) AS total_gastado
FROM members AS mb
LEFT JOIN sales AS s
    ON s.customer_id = mb.customer_id
   AND s.order_date < mb.join_date
LEFT JOIN menu AS m ON m.product_id = s.product_id
GROUP BY mb.customer_id
ORDER BY mb.customer_id;


-- 9. Puntos acumulados por compras realizadas desde la fecha de ingreso.
-- Cada dólar suma 10 puntos; sushi suma 20 puntos por dólar.
SELECT mb.customer_id,
       COALESCE(SUM(
           CASE
               WHEN m.product_name = 'sushi' THEN m.price * 20
               ELSE m.price * 10
           END
       ), 0) AS puntos
FROM members AS mb
LEFT JOIN sales AS s
    ON s.customer_id = mb.customer_id
   AND s.order_date >= mb.join_date
LEFT JOIN menu AS m ON m.product_id = s.product_id
GROUP BY mb.customer_id
ORDER BY mb.customer_id;


-- 10. Puntos de A y B acumulados hasta el 31 de enero de 2021.
-- En los primeros 7 días desde el ingreso (incluido el día de ingreso),
-- todos los artículos generan 20 puntos por dólar.
-- Después, sushi genera 20 puntos y los demás artículos 10 por dólar.
SELECT mb.customer_id,
       SUM(
           CASE
               WHEN s.order_date BETWEEN mb.join_date
                                     AND DATE_ADD(mb.join_date, INTERVAL 6 DAY)
                   THEN m.price * 20
               WHEN m.product_name = 'sushi'
                   THEN m.price * 20
               ELSE m.price * 10
           END
       ) AS puntos_hasta_fin_de_enero
FROM members AS mb
JOIN sales AS s
    ON s.customer_id = mb.customer_id
   AND s.order_date >= mb.join_date
   AND s.order_date < '2021-02-01'
JOIN menu AS m ON m.product_id = s.product_id
WHERE mb.customer_id IN ('A', 'B')
GROUP BY mb.customer_id
ORDER BY mb.customer_id;


-- 11. Variante: primera semana da 20 puntos por dólar en todos los artículos;
-- desde el octavo día, se aplica la regla normal de puntos del ejercicio 9.
SELECT mb.customer_id,
       SUM(
           CASE
               WHEN s.order_date BETWEEN mb.join_date
                                     AND DATE_ADD(mb.join_date, INTERVAL 6 DAY)
                   THEN m.price * 20
               WHEN m.product_name = 'sushi'
                   THEN m.price * 20
               ELSE m.price * 10
           END
       ) AS puntos
FROM members AS mb
JOIN sales AS s
    ON s.customer_id = mb.customer_id
   AND s.order_date >= mb.join_date
JOIN menu AS m ON m.product_id = s.product_id
GROUP BY mb.customer_id
ORDER BY mb.customer_id;
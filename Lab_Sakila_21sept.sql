USE sakila;

 

-- =====================================================
-- PARTE 1
-- =====================================================

 

-- Obtener todos los datos de actor, film y customer
SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;

 

-- Obtener títulos de películas
SELECT title
FROM film;

 

-- Lista única de idiomas
SELECT DISTINCT name AS language
FROM language;

 

-- Número de tiendas
SELECT COUNT(*) AS total_stores
FROM store;

 

-- Número de empleados
SELECT COUNT(*) AS total_staff
FROM staff;

 

-- Lista de nombres de empleados
SELECT first_name
FROM staff;

 

-- =====================================================
-- PARTE 2
-- =====================================================

 

-- 1. Actores con nombre Scarlett
SELECT *
FROM actor
WHERE first_name = 'SCARLETT';

 

-- 2. Actores con apellido Johansson
SELECT *
FROM actor
WHERE last_name = 'JOHANSSON';

 

-- 3. Películas disponibles para alquilar
SELECT COUNT(*) AS available_movies
FROM film;

 

-- 4. Películas alquiladas
SELECT COUNT(*) AS rented_movies
FROM rental;

 

-- 5. Período de alquiler más corto y más largo
SELECT
    MIN(rental_duration) AS shortest_rental_period,
    MAX(rental_duration) AS longest_rental_period
FROM film;

 

-- 6. Duración mínima y máxima de una película
SELECT
    MIN(length) AS min_duration,
    MAX(length) AS max_duration
FROM film;

 

-- 7. Duración media de una película
SELECT AVG(length) AS average_duration
FROM film;

 

-- 8. Duración promedio en horas y minutos
SELECT CONCAT(
        FLOOR(AVG(length)/60),
        ' horas ',
        ROUND(AVG(length)%60),
        ' minutos'
       ) AS average_duration_hm
FROM film;

 

-- 9. Películas que duran más de 3 horas
SELECT COUNT(*) AS movies_over_3_hours
FROM film
WHERE length > 180;

 

-- 10. Formato nombre y email
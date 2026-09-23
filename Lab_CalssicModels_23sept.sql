USE classicmodels;

-- EJERCICIO 1

-- 1. Contactos de oficina: código y teléfono
SELECT officeCode, phone
FROM offices;

-- 2. Empleados cuyo correo termina en ".es"
SELECT employeeNumber, firstName, lastName, email
FROM employees
WHERE email LIKE '%.es';

-- 3. Clientes sin información de estado
SELECT customerNumber, customerName, city, country
FROM customers
WHERE state IS NULL OR TRIM(state) = '';

-- 4. Pagos superiores a $20.000
SELECT customerNumber, checkNumber, paymentDate, amount
FROM payments
WHERE amount > 20000;

-- 5. Pagos superiores a $20.000 realizados en 2005
SELECT customerNumber, checkNumber, paymentDate, amount
FROM payments
WHERE amount > 20000
  AND paymentDate >= '2005-01-01'
  AND paymentDate <  '2006-01-01';

-- 6. Códigos de producto distintos en orderdetails
SELECT DISTINCT productCode
FROM orderdetails;

-- 7. Cantidad de pedidos por país del cliente
SELECT c.country, COUNT(o.orderNumber) AS cantidad_pedidos
FROM customers AS c
LEFT JOIN orders AS o
    ON o.customerNumber = c.customerNumber
GROUP BY c.country
ORDER BY cantidad_pedidos DESC;


-- EJERCICIO 2

-- 1. Línea de producto con la descripción de texto más larga
SELECT productLine, textDescription,
       CHAR_LENGTH(textDescription) AS longitud
FROM productlines
ORDER BY CHAR_LENGTH(textDescription) DESC
LIMIT 1;

-- 2. Cantidad de clientes asociados a cada oficina
-- Se asocia cada cliente con la oficina de su representante de ventas.
SELECT o.officeCode, o.city, COUNT(c.customerNumber) AS cantidad_clientes
FROM offices AS o
LEFT JOIN employees AS e
    ON e.officeCode = o.officeCode
LEFT JOIN customers AS c
    ON c.salesRepEmployeeNumber = e.employeeNumber
GROUP BY o.officeCode, o.city
ORDER BY o.officeCode;

-- 3. Día de la semana con más pedidos
-- Se cuenta cada pedido como una venta.
SELECT DAYNAME(orderDate) AS dia_semana,
       COUNT(*) AS cantidad_pedidos
FROM orders
GROUP BY DAYOFWEEK(orderDate), DAYNAME(orderDate)
ORDER BY cantidad_pedidos DESC
LIMIT 1;

-- 4. Mostrar territorio corregido, considerando NULL o 'NA' como faltante
SELECT officeCode, city, country,
       CASE
           WHEN territory IS NULL OR UPPER(TRIM(territory)) = 'NA'
               THEN 'USA'
           ELSE territory
       END AS territory_corregido
FROM offices;


-- EJERCICIO 3

-- 1. Promedio del importe del carrito y total de artículos por año y mes.
-- Incluye pedidos de 2004 y 2005 de clientes atendidos por empleados
-- cuyo apellido sea Patterson. El importe de cada carrito es la suma
-- de quantityOrdered * priceEach por pedido.
SELECT YEAR(x.orderDate) AS anio,
       MONTH(x.orderDate) AS mes,
       AVG(x.importe_carrito) AS importe_promedio_carrito,
       SUM(x.total_articulos) AS total_articulos
FROM (
    SELECT o.orderNumber,
           o.orderDate,
           SUM(od.quantityOrdered * od.priceEach) AS importe_carrito,
           SUM(od.quantityOrdered) AS total_articulos
    FROM orders AS o
    JOIN customers AS c
        ON c.customerNumber = o.customerNumber
    JOIN employees AS e
        ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN orderdetails AS od
        ON od.orderNumber = o.orderNumber
    WHERE e.lastName = 'Patterson'
      AND o.orderDate >= '2004-01-01'
      AND o.orderDate <  '2006-01-01'
    GROUP BY o.orderNumber, o.orderDate
) AS x
GROUP BY YEAR(x.orderDate), MONTH(x.orderDate)
ORDER BY anio, mes;

-- 2. Oficinas con empleados que atienden a clientes sin estado informado
SELECT DISTINCT o.officeCode, o.city, o.country
FROM offices AS o
JOIN employees AS e
    ON e.officeCode = o.officeCode
JOIN customers AS c
    ON c.salesRepEmployeeNumber = e.employeeNumber
WHERE c.state IS NULL OR TRIM(c.state) = ''
ORDER BY o.officeCode;
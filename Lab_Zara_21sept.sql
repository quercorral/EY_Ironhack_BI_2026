select *
from clientes;
select * 
from empleados;
select *
from tiendas;
select *
from prendas;
select *
from clientes
where nombre_cliente 
like 'L%';
select count(nombre_cliente)
from clientes;
select *
from Compras
where fecha_compra > '2023-05-01';
update Clientes
set email_cliente = 'nuevo@email.com'
where id_cliente = 1;
delete from Clientes
where id_cliente = 5;
select *
from Prendas
where color = 'Negro';
select *
from Tiendas
where ciudad = 'Madrid';
select count(*) as total_prendas
from Prendas
where precio > 50;
select *
from Empleados
where tienda_id = 1;
select *
from Clientes
where nombre_cliente like '%Andrew%';
select *
from Compras
where id_cliente = 2;
delete from Detalle_Compras
where cantidad < 30;
select *
from Prendas
where precio between 20 and 40;
select *
from Empleados
where nombre_empleado like '%a%';
select *
from Prendas
order by precio desc
limit 5;
select Compras.*, Detalle_Compras.cantidad
from Compras
join Detalle_Compras
on Compras.id_compra = Detalle_Compras.id_compra
where Detalle_Compras.cantidad > 75;
select *
from Prendas
where talla = 'M';
update Prendas
set talla = 'L'
where id_prenda = 1;
select *
from Empleados
where fecha_contratacion > '2022-01-01';
select *
from Tiendas
where ciudad = 'Barcelona';
delete from Empleados
where id_empleado = 5;
select *
from Compras
where fecha_compra < '2023-07-01';
select *
from Prendas
where tipo_prenda like '%eta';
select *
from Clientes
where email_cliente not like '%hotmail%';
select count(*) as total_compras
from Compras
where fecha_compra >= '2023-09-01'
and fecha_compra < '2023-10-01';
update Tiendas
set direccion = 'Calle Nueva, 10'
where id_tienda = 1;
select *
from Prendas
where tipo_prenda = 'Camiseta';
delete from Prendas
where precio < 20;
select *
from Tiendas
order by ciudad;
select *
from Empleados
where puesto = 'Vendedor';
select count(*) as total_prendas_blancas
from Prendas
where color = 'Blanco';
select *
from Clientes
where length(nombre_cliente) > 10;
select *
from Compras
where monto_total between 50 and 100;
select *
from Compras
order by fecha_compra desc
limit 3;
select color, count(*) as cantidad
from Prendas
group by color;
insert into Tiendas (nombre_tienda, direccion, ciudad, pais)
values
('Zara Calle Serrano', 'Calle Serrano, 50', 'Madrid', 'España'),
('Zara Plaza Mayor', 'Plaza Mayor, 5', 'Madrid', 'España');
update Clientes
set nombre_cliente = 'Micaela',
    email_cliente = 'micaela.torres@email.com'
where id_cliente = 5;
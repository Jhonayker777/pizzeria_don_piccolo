

--Resumen de pedidos por cliente (Mostrar nombre del cliente, cantidad de pedidos y total gastado)

create view pedidos_por_cliente as
select  c.nombre, c.apellido, count(p.id) as cantidad_pedidos, sum(p.total) as total_gastado
from persona c
inner join pedido p on c.id = p.cliente_fk group by c.nombre, c.apellido;

--Desempeño de repartidores (Mostrar número de entregas, tiempo promedio y zona de cada repartidor)
create view desempeño_repartidores as
select p.nombre,
p.apellido,
count(d.id) as entregas_realizadas,
avg(TIMESTAMPDIFF(hour, pe.fecha, d.hora_llegada))as tiempo_promedio_entrega,
r.zona

from persona p
inner join repartidor r on p.id = r.id
inner join domicilio d on r.id = d.repartidor_fk
inner join pedido pe on d.pedido_fk = pe.id
group by p.nombre, p.apellido, r.zona;

--Stock de ingredientes crítico (Mostrar ingredientes por debajo del mínimo permitido)

create view stock_ingredientes_critico as
select i.nombre, i.stock, i.stock_minimo
from ingredientes i
where i.stock < i.stock_minimo;

-- Ventas diarias (Resumen de ventas, pedidos y métodos de pago por día)

create view ventas_diarias as
select p.fecha, count(p.id) as cantidad_pedidos, sum(p.total) as total_ventas, p.metodo_pago
from pedido p
where p.estado != 'cancelado'
and day(p.fecha) = day(curdate())
group by p.fecha, p.metodo_pago ;

--Pizzas más vendidas (Ranking de pizzas con unidades vendidas e ingresos generados)
create view top3_pizzas_mas_vendidas as
select pi.nombre, sum(pp.cantidad) as unidades_vendidas, sum(pp.cantidad * p.total) as ingresos_generados
from pizza pi
inner join pedido_pizzas pp on pi.id = pp.pizza_fk
inner join pedido p on pp.pedido_fk = p.id
where p.estado != 'cancelado'
group by pi.nombre
order by unidades_vendidas desc
limit 3;

--Análisis de envíos (Métricas de entregas con distancias, tiempos y costos)

create view analisis_envios as
select d.id as envio_id,
p.id as pedido_id,
pr.nombre as repartidor_nombre,
pr.apellido as repartidor_apellido,
d.distancia,
TIMESTAMPDIFF(hour, p.fecha, d.hora_llegada) as tiempo_entrega,
d.precio_envio

from domicilio d
inner join pedido p on d.pedido_fk = p.id
inner join persona pr on d.repartidor_fk = pr.id
where p.estado != 'cancelado';
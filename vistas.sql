use pizzeria_don_piccolo;

-- =============================================
-- VISTA 1: Resumen de pedidos por cliente (CORREGIDA)
-- =============================================
create view pedidos_por_cliente as
select 
    c.Nombre as nombre,
    c.Apellido as apellido,
    count(p.id) as cantidad_pedidos,
    sum(p.total) as total_gastado
from persona c
inner join pedido p on c.id = p.cliente_fk 
group by c.Nombre, c.Apellido;

-- =============================================
-- VISTA 2: Desempeño de repartidores (CORREGIDA)
-- =============================================
create view desempeño_repartidores as
select 
    p.Nombre as nombre,
    p.Apellido as apellido,
    count(d.id) as entregas_realizadas,
    avg(TIMESTAMPDIFF(hour, pe.fecha, d.hora_llegada)) as tiempo_promedio_entrega,
    r.zona
from persona p
inner join empleado e on p.id = e.id
inner join repartidor r on e.id = r.id
inner join domicilio d on r.id = d.repartidor_fk
inner join pedido pe on d.pedido_fk = pe.id
where d.hora_llegada is not null  -- Solo entregas completadas
group by p.Nombre, p.Apellido, r.zona;

-- =============================================
-- VISTA 3: Stock de ingredientes crítico (CORRECTA)
-- =============================================
create view stock_ingredientes_critico as
select 
    i.nombre,
    i.stock,
    i.stock_minimo,
    (i.stock_minimo - i.stock) as unidades_faltantes
from ingredientes i
where i.stock < i.stock_minimo;

-- =============================================
-- VISTA 4: Ventas diarias (CORREGIDA)
-- =============================================
create view ventas_diarias as
select 
    date(p.fecha) as fecha,
    count(p.id) as cantidad_pedidos,
    sum(p.total) as total_ventas,
    p.metodo_pago
from pedido p
where p.estado != 'cancelado'
and date(p.fecha) = curdate()
group by date(p.fecha), p.metodo_pago;

-- =============================================
-- VISTA 5: Pizzas más vendidas (CORREGIDA)
-- =============================================
create view top3_pizzas_mas_vendidas as
select 
    pi.nombre as pizza,
    sum(pp.cantidad) as unidades_vendidas,
    sum(pp.cantidad * pp.precio_unitario) as ingresos_generados
from pizza pi
inner join pedido_pizzas pp on pi.id = pp.pizza_fk
inner join pedido p on pp.pedido_fk = p.id
where p.estado != 'cancelado'
group by pi.nombre
order by unidades_vendidas desc
limit 3;

-- =============================================
-- VISTA 6: Análisis de envíos (CORREGIDA)
-- =============================================
create view analisis_envios as
select 
    d.id as envio_id,
    p.id as pedido_id,
    pr.Nombre as repartidor_nombre,
    pr.Apellido as repartidor_apellido,
    d.distancia,
    TIMESTAMPDIFF(minute, d.hora_salida, d.hora_llegada) as tiempo_entrega_minutos,
    d.precio_envio
from domicilio d
inner join pedido p on d.pedido_fk = p.id
inner join repartidor r on d.repartidor_fk = r.id
inner join empleado e on r.id = e.id
inner join persona pr on e.id = pr.id
where p.estado != 'cancelado'
and d.hora_llegada is not null;

-- =============================================
-- VISTA 7: Repartidores disponibles (CORREGIDA)
-- =============================================
create view repartidores_disponibles as
select 
    p.Nombre as nombre,
    p.Apellido as apellido,
    r.zona,
    case 
        when r.estado = 1 then 'Disponible'
        else 'Ocupado'
    end as estado
from persona p
inner join empleado e on p.id = e.id
inner join repartidor r on e.id = r.id
where r.estado = 1;

use pizzaria_don_piccolo;
--	Clientes con pedidos entre fechas	(Obtener clientes con pedidos en un rango de fechas (BETWEEN))
select 
pc.nombre,
pc.apellido,
count(p.id) as cantidad_pedidos 
from persona pc inner join pedido p on pc.id = p.cliente_fk
where p.fecha between "2026-03-01" and "2026-03-02"
group by pc.nombre, pc.apellido;

--	Pizzas más vendidas	(Ranking de pizzas usando GROUP BY y COUNT)
select 
    p.nombre, 
    sum(pp.cantidad) as unidades_vendidas
from pedido_pizzas pp inner join pizza p on pp.pizza_fk = p.id
group by p.nombre
order by unidades_vendidas desc
limit 3;

--	Pedidos por repartidor	(Listar pedidos asignados a cada repartidor (JOIN))
Select 
    pr.nombre, 
    pr.apellido, 
    count(d.id)
from domicilio d inner join persona pr on d.repartidor_fk = pr.id
group by pr.nombre, pr.apellido;

--	Promedio de entrega por zona	(Calcular tiempo promedio de entrega agrupado por zona (AVG y JOIN))



--	Clientes con gasto superior a monto	(Filtrar clientes que gastaron más de X cantidad (HAVING))

select 
    pc.nombre, 
    pc.apellido, 
    sum(p.total) as total_gastado 
from pedido p 
inner join persona pc on p.cliente_fk = pc.id
group by pc.nombre, pc.apellido
having total_gastado > 50000;

--	Búsqueda por coincidencia parcial	(Buscar pizzas por nombre usando LIKE)

select p.id,p.nombre, p.tamaño, p.precio_base ,p.tipo from pizza p
where p.nombre like("%a");

--	Clientes frecuentes	(Subconsulta para obtener clientes con más de 5 pedidos mensuales)
select 
    concat(p.nombre, ' ', p.apellido) as cliente,
    c.direccion,
    c.fecha_registro,
    (
        select count(*) 
        from pedido ped2
        where ped2.cliente_fk = c.id
        and month(ped2.fecha) = month(curdate())
        and year(ped2.fecha) = year(curdate())
    ) as pedidos_este_mes
from persona p
inner join cliente c on p.id = c.id
where (
    select count(*) 
    from pedido ped2
    where ped2.cliente_fk = c.id
    and month(ped2.fecha) = month(curdate())
    and year(ped2.fecha) = year(curdate())
) > 5
order by pedidos_este_mes desc;

--	Ganancia neta diaria	(Usar función ganancia_neta_diaria() para análisis diario)

select ganancia_neta_diaria("2026-03-02") as ganancias_neta;

--	Análisis de ventas por categoría	(Agrupar ventas por tipo de pizza (vegetariana, especial, clásica))

select 
    p.tipo, 
    count(pp.cantidad * pp.pizza_fk) as cantidad 
from pedido_pizzas pp
inner join pizza p on pp.pizza_fk = p.id
group by p.tipo;

--	Métodos de pago más usados	(Estadísticas de uso por método de pago)

select 
    metodo_pago,
    count(*) as cantidad_pedidos
from pedido
group by metodo_pago
order by cantidad_pedidos desc;


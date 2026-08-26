use pizzeria_don_piccolo;


-- calcular total de un pedido (Suma de los precios de las pizzas y el costo de envío)

delimiter ¬¬

create function calcular_total_pedido(pedido_id int) 
returns double
deterministic
reads sql data
begin
    declare total double;
    declare iva double default 0.19;
    declare subtotal double;
    declare costo_envio double;
    
    select coalesce(sum(pp.cantidad * pp.precio_unitario), 0)
    into subtotal
    from pedido_pizzas pp
    where pp.pedido_fk = pedido_id;
    
    select coalesce(d.precio_envio, 0)
    into costo_envio
    from domicilio d
    where d.pedido_fk = pedido_id;
    
    set total = (subtotal + costo_envio) * (1 + iva);
    
    return total;
end ¬¬

delimiter ;

-- calcular ganancia neta diaria (Ingresos - Costos de ingredientes)

delimiter ¬¬

create function ganancia_neta_diaria(fecha_consulta date)
returns double
reads sql data
begin
    declare ganancia double;
    declare total_ventas double default 0;
    declare total_costos double default 0;

    select coalesce(sum(p.total), 0)
    into total_ventas
    from pedido p
    where date(p.fecha) = fecha_consulta
    and p.estado != 'cancelado';

    select coalesce(sum(i.precio_unitario * pi.cantidad * pp.cantidad), 0)
    into total_costos
    from ingredientes i
    join pizza_ingredientes pi on i.id = pi.ingredientes_fk
    join pizza p on pi.pizza_fk = p.id
    join pedido_pizzas pp on p.id = pp.pizza_fk
    join pedido pe on pe.id = pp.pedido_fk
    where date(pe.fecha) = fecha_consulta
    and pe.estado != 'cancelado';

    set ganancia = total_ventas - total_costos;

    return ganancia;
end ¬¬

delimiter ;

-- Calcular costo de envío basado en distancia (tarifa por km y tarifa mínima)

delimiter ¬¬

create function calcular_costo_envio(distancia double)
returns double
deterministic
reads sql data
begin
    declare costo double;
    declare tarifa_por_km double default 2500;
    declare tarifa_minima double default 3000;
    
    set costo = distancia * tarifa_por_km;

    if costo < tarifa_minima then
        set costo = tarifa_minima;
    end if;

    return costo;
end ¬¬

delimiter ;

-- Estimar tiempo de entrega basado en distancia y velocidad promedio

delimiter ¬¬

create function estimar_tiempo_entrega(distancia double)
returns int
deterministic
reads sql data
begin
    declare tiempo int;
    declare velocidad_promedio double default 30;

    set tiempo = (distancia / velocidad_promedio) * 60; 

    return tiempo;
end ¬¬

delimiter ;

-- Identificar clientes frecuentes (Determinar si un cliente ha realizado más de 5 pedidos en un mes)

delimiter ¬¬

create function es_cliente_frecuente(
    cliente_id int, 
    mes int, 
    año int
)
returns boolean
deterministic
reads sql data
begin
    declare cantidad_pedidos int default 0;

    select count(*) 
    into cantidad_pedidos
    from pedido p
    where p.cliente_fk = cliente_id
    and year(p.fecha) = año
    and month(p.fecha) = mes
    and p.estado != 'cancelado';

    if cantidad_pedidos > 5 then
        return true;
    else
        return false;
    end if;
end ¬¬

delimiter ;
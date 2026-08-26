
use pizzeria_don_piccolo;

-- Calcular total del pedido (Sumar precios de pizzas + costo de envío + IVA (19%))
create function calcular_total_pedido(pedido_id int) 
returns double
deterministic
reads sql data
 
begin
    declare total double;
    declare iva double default 1.19;        -- 19% de IVA
    declare subtotal double;
    declare costo_envio double;
    
    select coalesce(sum(pp.cantidad * pp.precio_unitario), 0)
    into subtotal
    from pedido_pizzas pp
    where pp.pedido_fk = pedido_id;
    
    -- 2. Obtener costo de envío (si existe domicilio)
    select coalesce(d.precio_envio, 0)
    into costo_envio
    from domicilio d
    where d.pedido_fk = pedido_id;
    
    -- 3. Calcular total final: (subtotal + envío) * (1 + IVA)
    set total = (subtotal + costo_envio) * iva;
    
    return total;
end ¬¬

delimiter ;

--	Calcular ganancia neta diaria (Calcular ventas - costos de ingredientes usados en el día)

delimiter ¬¬
create function ganancia_neta_diaria(fecha date)
returns double
not deterministic
reads sql data
begin
    declare ganacia double;
    declare total_ventas double;
    declare total_costos double;

    select sum(p.total)
    into total_ventas
    from pedido p
    where date(p.fecha) = fecha;

    select sum(i.precio_unitario * pi.cantidad)
    into total_costos
    from ingredientes i
    join pizza_ingredientes pi on i.id = pi.ingredientes_fk
    join pizza p on pi.pizza_fk = p.id
    join pedido_pizzas pp on p.id = pp.pizza_fk
    join pedido pe on pe.id = pp.pedido_fk
    where date(pe.fecha) = fecha;

    set ganacia = total_ventas - total_costos;

    return ganacia;

end ¬¬
delimiter ;

--	Calcular costo de envío por distancia (Determinar costo de envío según distancia recorrida (tarifa escalonada))
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

--	Estimar tiempo de entrega (Calcular tiempo estimado de entrega basado en distancia)

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

--	Identificar clientes frecuentes (Determinar si un cliente tiene más de 5 pedidos en el mes)

delimiter ¬¬
create function es_cliente_frecuente(cliente_id int, mes int, año int)
returns boolean
deterministic
reads sql data
begin

    declare cantidad_pedidos int;

    select count(*) 
    into cantidad_pedidos
    from pedido p
    where p.cliente_fk = cliente_id
    and year(p.fecha) = año
    and month(p.fecha) = mes;

    if cantidad_pedidos > 5 then
        return true;
    else
        return false;
    end if;

end ¬¬
delimiter ;

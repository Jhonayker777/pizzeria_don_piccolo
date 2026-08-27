use pizzeria_don_piccolo;

-- actualizar estock al agregar pizaa
delimiter ¬¬

create trigger actualizar_stock_al_agregar_pizza
after insert on pedido_pizzas
for each row
begin
    update ingredientes i
    inner join pizza_ingredientes pi on i.id = pi.ingredientes_fk
    set i.stock = i.stock - (new.cantidad * pi.cantidad)
    where pi.pizza_fk = new.pizza_fk;
end ¬¬

delimiter ;

-- Historial de precios

delimiter ¬¬

create trigger historial_precios_pizza
after update on pizza
for each row
begin
    if old.precio_base != new.precio_base then
        insert into historial_precios (
            pizza_id,
            precio_anterior,
            precio_nuevo,
            fecha_cambio
        ) values (
            new.id,
            old.precio_base,
            new.precio_base,
            now()
        );
    end if;
end ¬¬

delimiter ;

-- reparditor libre

delimiter ¬¬

create trigger liberar_repartidor
after update on domicilio
for each row
begin
    if old.hora_llegada is null and new.hora_llegada is not null then
        update repartidor
        set disponible = 1
        where id = new.repartidor_fk;
    end if;
end ¬¬

delimiter ;

-- validar repartidor disponible

delimiter ¬¬

create trigger validar_repartidor_disponible
before insert on domicilio
for each row
begin
    declare repartidor_disponible int;
    
    select count(*) into repartidor_disponible
    from repartidor
    where id = new.repartidor_fk 
    and estado = 1;
    
    if repartidor_disponible = 0 then
        signal sqlstate '45000' 
        set message_text = 'El repartidor no está disponible';
    end if;
end ¬¬

delimiter ;

-- calcular precio de envio

delimiter ¬¬

create trigger calcular_precio_envio
before insert on domicilio
for each row
begin
    set new.precio_envio = calcular_costo_envio(new.distancia);
end ¬¬

delimiter ;

-- actualizar precio de envio

delimiter ¬¬

create trigger actualizar_precio_envio
before update on domicilio
for each row
begin
    if old.distancia != new.distancia then
        set new.precio_envio = calcular_costo_envio(new.distancia);
        
        update pedido
        set total = calcular_total_pedido(new.pedido_fk)
        where id = new.pedido_fk;
    end if;
end ¬¬

delimiter ;

-- validar stock 

delimiter ¬¬

create trigger validar_stock_count
before insert on pedido_pizzas
for each row
begin
    declare ingredientes_faltantes int;
    
    select count(*)
    into ingredientes_faltantes
    from pizza_ingredientes pi
    inner join ingredientes i on pi.ingredientes_fk = i.id
    where pi.pizza_fk = new.pizza_fk
    and i.stock < (pi.cantidad * new.cantidad);
    
    if ingredientes_faltantes > 0 then
        signal sqlstate '45000' 
        set message_text = 'No hay suficiente stock de ingredientes';
    end if;
end ¬¬

delimiter ;
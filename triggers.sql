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

-- validar stock corregido

delimiter ¬¬

create trigger validar_stock_suficiente
before insert on pedido_pizzas
for each row
begin
    declare ingrediente_nombre varchar(45);
    declare stock_actual int;
    declare cantidad_necesaria int;
    declare cantidad_por_pizza int;
    declare done int default false;
    
    declare cursor_ingredientes cursor for
        select i.nombre, i.stock, pi.cantidad
        from ingredientes i
        inner join pizza_ingredientes pi on i.id = pi.ingredientes_fk
        where pi.pizza_fk = new.pizza_fk;
    
    declare continue handler for not found set done = true;
    
    open cursor_ingredientes;
    
    verificar: loop
        fetch cursor_ingredientes into ingrediente_nombre, stock_actual, cantidad_por_pizza;
        
        if done then
            leave verificar;
        end if;
        
        set cantidad_necesaria = cantidad_por_pizza * new.cantidad;
        
        if stock_actual < cantidad_necesaria then
            close cursor_ingredientes;
            signal sqlstate '45000' 
            set message_text = concat('Stock insuficiente para: ', ingrediente_nombre);
        end if;
        
    end loop;
    
    close cursor_ingredientes;
    
end ¬¬

delimiter ;
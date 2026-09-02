use pizzeria_don_piccolo;

-- =============================================
-- TRIGGER 1: Actualizar stock al agregar pizza (CORRECTO)
-- =============================================
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

-- =============================================
-- TRIGGER 2: Historial de precios (CORREGIDO)
-- =============================================
delimiter ¬¬

create trigger historial_precios_pizza
after update on pizza
for each row
begin
    if old.precio_base != new.precio_base then
        insert into historial_precios (
            pizza_fk,  -- ✅ Columna correcta
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

-- =============================================
-- TRIGGER 3: Liberar repartidor (CORREGIDO)
-- =============================================
delimiter ¬¬

create trigger liberar_repartidor
after update on domicilio
for each row
begin
    if old.hora_llegada is null and new.hora_llegada is not null then
        update repartidor
        set estado = 1  -- ✅ Columna correcta
        where id = new.repartidor_fk;
    end if;
end ¬¬

delimiter ;

-- =============================================
-- TRIGGER 4: Validar repartidor disponible (CORRECTO)
-- =============================================
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

-- =============================================
-- TRIGGER 5: Calcular precio de envío (CORRECTO)
-- =============================================
delimiter ¬¬

create trigger calcular_precio_envio
before insert on domicilio
for each row
begin
    set new.precio_envio = calcular_costo_envio(new.distancia);
end ¬¬

delimiter ;

-- =============================================
-- TRIGGER 6: Actualizar precio de envío (CORRECTO)
-- =============================================
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

-- =============================================
-- TRIGGER 7: Validar stock (MEJORADO)
-- =============================================
delimiter ¬¬

create trigger validar_stock_count
before insert on pedido_pizzas
for each row
begin
    declare ingrediente_faltante varchar(45);
    
    select i.nombre into ingrediente_faltante
    from pizza_ingredientes pi
    inner join ingredientes i on pi.ingredientes_fk = i.id
    where pi.pizza_fk = new.pizza_fk
    and i.stock < (pi.cantidad * new.cantidad)
    limit 1;
    
    if ingrediente_faltante is not null then
        signal sqlstate '45000' 
        set message_text = concat('Stock insuficiente para: ', ingrediente_faltante);
    end if;
end ¬¬

delimiter ;
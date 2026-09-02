use pizzeria_don_piccolo;

-- =============================================
-- PROCEDIMIENTO 1: Actualizar estado repartidor
-- =============================================
delimiter ¬¬

create procedure actualizar_estado_repartidor(
    in repartidor_id int,
    in nuevo_estado boolean
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        select 'Error al actualizar estado del repartidor' as mensaje_error;
    end;
    
    start transaction;
    
    if not exists (select 1 from repartidor where id = repartidor_id) then
        rollback;
        select 'El repartidor no existe' as mensaje_error;
    end if;
    
    update repartidor
    set estado = nuevo_estado
    where id = repartidor_id;
    
    commit;
    
    select concat(
        'Repartidor #', repartidor_id,
        ' actualizado a ',
        case 
            when nuevo_estado = 1 then 'disponible'
            else 'no disponible'
        end
    ) as mensaje_exito;
    
end ¬¬

delimiter ;

-- =============================================
-- PROCEDIMIENTO 2: Marcar pedido como entregado
-- =============================================
delimiter ¬¬

create procedure marcar_pedido_entregado(pedido_id int)
begin
    declare repartidor_id int;
    
    declare exit handler for sqlexception
    begin
        rollback;
        select 'Error al marcar pedido como entregado' as mensaje_error;
    end;
    
    start transaction;
    
    if not exists (select 1 from pedido where id = pedido_id) then
        rollback;
        select 'El pedido no existe' as mensaje_error;
    end if;
    
    if not exists (select 1 from domicilio where pedido_fk = pedido_id) then
        rollback;
        select 'El pedido no tiene domicilio asignado' as mensaje_error;
    end if;
    
    select repartidor_fk into repartidor_id 
    from domicilio 
    where pedido_fk = pedido_id;
    
    update pedido
    set estado = 'entregado'
    where id = pedido_id;
    
    update domicilio
    set hora_llegada = now()
    where pedido_fk = pedido_id;
    
    call actualizar_estado_repartidor(repartidor_id, 1);
    
    commit;
    
    select concat('Pedido #', pedido_id, ' marcado como entregado.') as mensaje_exito;
    
end ¬¬

delimiter ;

-- =============================================
-- PROCEDIMIENTO 3: Registrar nuevo pedido
-- =============================================
delimiter ¬¬

create procedure registrar_nuevo_pedido(
    in cliente_id int,
    in v_metodo_pago enum('efectivo', 'tarjeta'),
    in encargado_caja_id int,
    in v_distancia double,
    in v_zona varchar(45)
)
begin
    declare pedido_id int;
    declare repartidor_id int;
    declare costo_envio double;
    
    declare exit handler for sqlexception
    begin
        rollback;
        select 'Error al registrar el pedido' as mensaje_error;
    end;
    
    start transaction;
    
    if not exists (select 1 from cliente where id = cliente_id) then
        rollback;
        select 'El cliente no existe' as mensaje_error;
    end if;
    
    if not exists (select 1 from encargado_caja where id = encargado_caja_id) then
        rollback;
        select 'El encargado de caja no existe' as mensaje_error;
    end if;
    
    set costo_envio = calcular_costo_envio(v_distancia);
    
    insert into pedido (
        fecha,
        metodo_pago,
        estado,
        total,
        cliente_fk,
        encargado_caja_fk
    ) values (
        now(),
        v_metodo_pago,
        'pendiente',
        0,
        cliente_id,
        encargado_caja_id
    );
    
    set pedido_id = last_insert_id();
    
    select id into repartidor_id
    from repartidor
    where estado = 1
    and zona = v_zona
    limit 1;
    
    if repartidor_id is null then
        rollback;
        select 'No hay repartidor disponible en esta zona' as mensaje_error;
    end if;
    
    call registrar_nuevo_domicilio(
        pedido_id,
        repartidor_id,
        v_distancia,
        costo_envio
    );
    
    update repartidor
    set estado = 0
    where id = repartidor_id;
    
    update pedido
    set total = calcular_total_pedido(pedido_id)
    where id = pedido_id;
    
    commit;
    
    select concat(
        'Pedido #', pedido_id, 
        ' registrado exitosamente. Repartidor #', repartidor_id,
        ' asignado.'
    ) as mensaje_exito;
    
end ¬¬

delimiter ;

-- =============================================
-- PROCEDIMIENTO 4: Registrar nuevo domicilio
-- =============================================
delimiter ¬¬

create procedure registrar_nuevo_domicilio(
    in pedido_id int,
    in repartidor_id int,
    in v_distancia double,
    in v_costo_envio double
)
begin
    declare exit handler for sqlexception
    begin
        rollback;
        select 'Error al registrar el domicilio' as mensaje_error;
    end;
    
    start transaction;
    
    if not exists (select 1 from pedido where id = pedido_id) then
        rollback;
        select 'El pedido no existe' as mensaje_error;
    end if;
    
    if not exists (select 1 from repartidor where id = repartidor_id) then
        rollback;
        select 'El repartidor no existe' as mensaje_error;
    end if;
    
    insert into domicilio (
        hora_salida,
        hora_llegada,
        distancia,
        precio_envio,
        pedido_fk,
        repartidor_fk
    ) values (
        now(),
        null,
        v_distancia,
        v_costo_envio,
        pedido_id,
        repartidor_id
    );
    
    commit;
    
end ¬¬

delimiter ;

-- =============================================
-- PROCEDIMIENTO 5: Agregar pizza a pedido
-- =============================================
delimiter ¬¬

create procedure agregar_pizza_a_pedido(
    in pedido_id int,
    in pizza_id int,
    in cantidad int
)
begin
    declare precio_unitario double;
    
    declare exit handler for sqlexception
    begin
        rollback;
        select 'Error al agregar pizza al pedido' as mensaje_error;
    end;
    
    start transaction;
    
    if not exists (select 1 from pedido where id = pedido_id) then
        rollback;
        select 'El pedido no existe' as mensaje_error;
    end if;
    
    if not exists (select 1 from pizza where id = pizza_id) then
        rollback;
        select 'La pizza no existe' as mensaje_error;
    end if;
    
    select precio_base into precio_unitario
    from pizza
    where id = pizza_id;
    
    insert into pedido_pizzas (
        pedido_fk, 
        pizza_fk, 
        cantidad, 
        precio_unitario
    ) values (
        pedido_id, 
        pizza_id, 
        cantidad, 
        precio_unitario
    );
    
    update pedido
    set total = calcular_total_pedido(pedido_id)
    where id = pedido_id;
    
    commit;
    
    select concat(
        cantidad, ' pizza(s) agregada(s) al pedido #', pedido_id
    ) as mensaje_exito;
    
end ¬¬

delimiter ;
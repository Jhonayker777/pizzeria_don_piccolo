--	Marcar pedido como entregado (Cambiar automáticamente el estado del pedido a "entregado" cuando se registra la hora de entrega)

delimiter ¬¬
create procedure marcar_pedido_entregado(pedido_id int)
begin
    update pedido
    set estado = 'entregado'
    where id = pedido_id;
end ¬¬
delimiter ;

--	Registrar nuevo pedido	(Crear un pedido completo y asignar repartidor si es domicilio)
delimiter ¬¬

create procedure registrar_nuevo_pedido(
    in cliente_id int,
    in v_metodo_pago enum('efectivo', 'tarjeta'),
    in es_domicilio boolean,
    in encargado_caja_id int)

begin
    declare pedido_id int;
    declare repartidor_id int;

    -- Insertar el pedido
    insert into pedido (fecha, metodo_pago, estado, total, cliente_fk, encargado_caja_fk)
    values (now(), v_metodo_pago, 'pendiente', 0, cliente_id, encargado_caja_id);

    call registrar_nuevo_domicilio(pedido_id, repartidor_id);
    
end ¬¬
delimiter ;

delimiter ¬¬
create procedure registrar_nuevo_domicilio(
    in pedido_id int,
    in repartidor_id int)
begin
    

end ¬¬
delimiter ;

--	Actualizar estado de repartidor	(Cambiar manualmente la disponibilidad de un repartidor)


--	Agregar pizza a pedido	(Agregar una pizza a un pedido existente y recalcular el total)
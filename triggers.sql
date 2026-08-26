--	Actualizar stock de ingredientes	(AFTER INSERT en pedido_pizzas	Restar automáticamente el stock de ingredientes cuando se realiza un pedido)

--	Historial de precios de pizzas	(AFTER UPDATE en pizza	Registrar en tabla historial_precios cada vez que se modifique el precio de una pizza)

--	Liberar repartidor	(AFTER UPDATE en domicilio	Marcar repartidor como "disponible" nuevamente cuando termina un domicilio (hora_llegada no NULL))

-- validar repartidor disponible (BEFORE INSERT en domicilio	Verificar que el repartidor asignado esté disponible antes de registrar un nuevo domicilio)
delimiter ¬¬
create trigger validar_repartidor_disponible
before insert on domicilio
for each row
begin
    declare repartidor_disponible int;
    
    select count(*) into repartidor_disponible
    from repartidor
    where id = new.repartidor_fk and disponible = 1;
    
    if repartidor_disponible = 0 then
        signal sqlstate '45000' set message_text = 'El repartidor no está disponible';
    end if;
end ¬¬

--	Calcular precio de envío (INSERT)	(BEFORE INSERT en domicilio	Calcular automáticamente el precio_envio basado en la distancia al insertar)

--	Actualizar precio de envío (UPDATE)	(BEFORE UPDATE en domicilio	Recalcular el precio_envio si cambia la distancia)

--	Validar stock suficiente	(BEFORE INSERT en pedido_pizzas	Verificar que haya suficiente stock de ingredientes antes de agregar una pizza al pedido)
create trigger validar_stock_suficiente
before insert on pedido_pizzas
for each row
begin
    declare stock_suficiente int;
    
    select count(*) into stock_suficiente
    from pizza_ingredientes pi
    join ingredientes i on pi.ingredientes_fk = i.id
    where pi.pizza_fk = new.pizza_fk and i.stock >= (pi.cantidad * new.cantidad);
    
    if stock_suficiente = 0 then
        signal sqlstate '45000' set message_text = 'No hay suficiente stock de ingredientes para esta pizza';
    end if;
end ¬¬
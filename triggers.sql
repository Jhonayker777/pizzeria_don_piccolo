--	Actualizar stock de ingredientes	(AFTER INSERT en pedido_pizzas	Restar automáticamente el stock de ingredientes cuando se realiza un pedido)

--	Historial de precios de pizzas	(AFTER UPDATE en pizza	Registrar en tabla historial_precios cada vez que se modifique el precio de una pizza)

--	Liberar repartidor	(AFTER UPDATE en domicilio	Marcar repartidor como "disponible" nuevamente cuando termina un domicilio (hora_llegada no NULL))

--	Calcular precio de envío (INSERT)	(BEFORE INSERT en domicilio	Calcular automáticamente el precio_envio basado en la distancia al insertar)

--	Actualizar precio de envío (UPDATE)	(BEFORE UPDATE en domicilio	Recalcular el precio_envio si cambia la distancia)

--	Validar stock suficiente	(BEFORE INSERT en pedido_pizzas	Verificar que haya suficiente stock de ingredientes antes de agregar una pizza al pedido)
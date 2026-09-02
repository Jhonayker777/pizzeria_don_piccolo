# 🍕 Sistema de Gestión de Pedidos y Domicilios - Pizzería Don Piccolo

Base de datos relacional en **MySQL** para la gestión integral del proceso de venta de pizzas y domicilios de la Pizzería Don Piccolo: desde el registro del pedido hasta su entrega y pago.

---

## 🎯 Objetivo General

Diseñar y desarrollar una base de datos relacional que permita administrar de forma eficiente y centralizada la información del negocio: clientes, empleados, pizzas, ingredientes, pedidos, domicilios y pagos, garantizando integridad de los datos y automatizando procesos clave como el control de stock, el cálculo de costos de envío y el seguimiento del estado de los pedidos.

---

## ✨ Características Principales

- 👤 Gestión de clientes y empleados a partir de una entidad base `Persona` (herencia)
- 🛵 Control de repartidores con zona asignada y disponibilidad en tiempo real
- 🍕 Catálogo de pizzas clasificadas por tipo (vegetariana, especial, clásica)
- 🧀 Control de inventario de ingredientes con alertas de stock mínimo
- 🧾 Registro completo de pedidos, con múltiples pizzas por pedido
- 🚚 Gestión de domicilios con cálculo automático del costo de envío según distancia
- 💳 Registro y seguimiento de pagos por pedido
- 📈 Historial de cambios de precios de las pizzas
- ⚙️ Automatización mediante funciones, procedimientos y triggers
- 📊 Vistas analíticas para la toma de decisiones (ventas, clientes frecuentes, desempeño de repartidores, etc.)

---

## 📊 Modelo Entidad-Relación (MER)

![Modelo Entidad-Relación - Pizzería Don Piccolo](/MER.png)


El diagrama MER muestra las entidades, atributos y relaciones de la base de datos. Las relaciones clave son:

- **Persona** se especializa en **Cliente** y **Empleado** (herencia)
- **Empleado** se especializa en **Repartidor** y **Encargado_Caja** (herencia)
- **Cliente** tiene una relación 1:N con **Pedido**
- **Pedido** tiene una relación 1:N con **Pedido_Pizzas**
- **Pizza** tiene una relación 1:N con **Pedido_Pizzas**
- **Pizza** tiene una relación 1:N con **Pizza_Ingredientes**
- **Ingredientes** tiene una relación 1:N con **Pizza_Ingredientes**
- **Pedido** tiene una relación 1:1 con **Domicilio** (opcional)
- **Repartidor** tiene una relación 1:N con **Domicilio**
- **Pedido** tiene una relación 1:1 con **Pago**
- **Pizza** tiene una relación 1:N con **Historial_Precios**

---

## 🔧 Tecnologías Utilizadas

| Tecnología | Uso |
|---|---|
| MySQL 8.0+ | Motor de base de datos relacional |
| SQL | Definición de tablas, funciones, procedimientos, triggers y vistas |
| MySQL Workbench / Draw.io / Lucidchart | Diseño del modelo entidad-relación |

---

## 📋 Requisitos Previos

Antes de instalar el proyecto asegúrate de contar con:

- **MySQL Server 8.0** o superior instalado
- Un cliente de administración como **MySQL Workbench**, **DBeaver** o la línea de comandos `mysql`
- Permisos de creación de bases de datos y usuarios en el servidor
- Git (opcional, para clonar el repositorio)

---

## ⚙️ Instalación y Configuración

Sigue estos pasos en el orden indicado para desplegar la base de datos correctamente:

```bash
# 1. Clonar o descargar el proyecto
git clone https://github.com/tu-usuario/pizzeria-don-piccolo.git
cd pizzeria-don-piccolo

# 2. Ingresar a MySQL
mysql -u root -p
```

Luego, ejecuta los scripts **en este orden estricto** desde la consola de MySQL o tu cliente favorito:

```sql
SOURCE database.sql;        -- 1. Creación de la base de datos y tablas
SOURCE inserts.sql;         -- 2. Datos de ejemplo
SOURCE funciones.sql;       -- 3. Funciones
SOURCE procedimientos.sql;  -- 4. Procedimientos almacenados
SOURCE triggers.sql;        -- 5. Triggers
SOURCE vistas.sql;          -- 6. Vistas
SOURCE consultas.sql;       -- 7. Consultas de prueba
```

### Usuario de desarrollo

Para pruebas locales se recomienda crear un usuario de desarrollo:

```sql
CREATE USER 'daniel'@'localhost' IDENTIFIED BY '123';
GRANT ALL PRIVILEGES ON pizzeria_don_piccolo.* TO 'daniel'@'localhost';
FLUSH PRIVILEGES;
```

> ⚠️ Estas credenciales son **únicamente para entorno de desarrollo**. No deben usarse en producción.

---

## 📁 Estructura del Proyecto

```
pizzeria-don-piccolo/
│
├── database.sql          # Creación de la base de datos y tablas
├── inserts.sql            # Datos de ejemplo (seed data)
├── funciones.sql           # Funciones almacenadas
├── procedimientos.sql       # Procedimientos almacenados
├── triggers.sql             # Triggers de la base de datos
├── vistas.sql                # Vistas del sistema
├── consultas.sql              # Consultas SQL de prueba
├── images/
│   └── mer_pizzeria_don_piccolo.png   # Diagrama del modelo E-R
└── README.md                # Este documento
```

---

## 🗄️ Explicación de las Tablas

### 1. `Persona`
Entidad base que almacena los datos comunes de clientes y empleados.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK, AUTO_INCREMENT) | Identificador único |
| Nombre | VARCHAR(45) | Nombre de la persona |
| Apellido | VARCHAR(45) | Apellido de la persona |
| correo | VARCHAR(45) | Correo electrónico |

### 2. `telefono`
Almacena uno o varios números telefónicos asociados a una persona.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| numero | INT | Número telefónico |
| indicativo | INT | Indicativo/código de país |
| persona_fk | INT (FK → Persona.id) | Persona propietaria del número |

### 3. `cliente`
Especialización de `Persona` para los clientes de la pizzería.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK, FK → Persona.id) | Identificador (heredado) |
| direccion | VARCHAR(100) | Dirección de residencia |
| fecha_registro | DATE | Fecha de registro como cliente |

### 4. `empleado`
Especialización de `Persona` para el personal de la pizzería.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK, FK → Persona.id) | Identificador (heredado) |
| salario_base | DOUBLE | Salario base del empleado |
| fecha_contratacion | DATE | Fecha de contratación |

### 5. `encargado_caja`
Especialización de `empleado` responsable de registrar pedidos y pagos.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK, FK → empleado.id) | Identificador (heredado) |

### 6. `repartidor`
Especialización de `empleado` encargado de las entregas a domicilio.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK, FK → empleado.id) | Identificador (heredado) |
| zona | VARCHAR(45) DEFAULT 'libre' | Zona asignada de reparto |
| estado | TINYINT DEFAULT 0 | 1 = disponible, 0 = no disponible |

### 7. `ingredientes`
Inventario de insumos utilizados en la preparación de pizzas.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| nombre | VARCHAR(45) | Nombre del ingrediente |
| stock | INT | Cantidad disponible |
| stock_minimo | INT DEFAULT 5 | Umbral para generar alerta |
| precio_unitario | DOUBLE | Costo unitario del ingrediente |

### 8. `pizza`
Catálogo de pizzas ofrecidas por la pizzería.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| nombre | VARCHAR(45) | Nombre de la pizza |
| tamano_cm | DOUBLE | Diámetro en centímetros |
| precio_base | DOUBLE | Precio base sin adicionales |
| tipo | ENUM | vegetariana, especial, clasica |

### 9. `pizza_ingredientes`
Tabla intermedia que relaciona cada pizza con sus ingredientes y cantidades.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| cantidad | INT | Cantidad requerida del ingrediente |
| pizza_fk | INT (FK → pizza.id) | Pizza relacionada |
| ingredientes_fk | INT (FK → ingredientes.id) | Ingrediente relacionado |

### 10. `pedido`
Registro central de cada compra realizada por un cliente.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| fecha | DATETIME | Fecha y hora del pedido |
| metodo_pago | ENUM | efectivo, tarjeta, app |
| estado | ENUM | pendiente, preparando, entregado, cancelado |
| total | DOUBLE | Valor total del pedido |
| cliente_fk | INT (FK → cliente.id) | Cliente que realizó el pedido |
| encargado_caja_fk | INT (FK → encargado_caja.id) | Empleado que registró el pedido |

### 11. `pedido_pizzas`
Detalle de las pizzas incluidas en cada pedido.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| cantidad | INT | Unidades pedidas de la pizza |
| precio_unitario | DOUBLE | Precio al momento de la compra |
| pedido_fk | INT (FK → pedido.id) | Pedido relacionado |
| pizza_fk | INT (FK → pizza.id) | Pizza relacionada |

### 12. `domicilio`
Información sobre el envío a domicilio de un pedido.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| hora_salida | DATETIME | Hora en que el repartidor sale |
| hora_llegada | DATETIME (NULL) | Hora en que se entrega el pedido |
| distancia | DOUBLE | Distancia en kilómetros |
| precio_envio | DOUBLE | Costo del envío |
| pedido_fk | INT (FK → pedido.id) | Pedido asociado |
| repartidor_fk | INT (FK → repartidor.id) | Repartidor asignado |

### 13. `pago`
Registro del pago asociado a cada pedido.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| monto | DOUBLE | Valor pagado |
| metodo_pago | ENUM | efectivo, tarjeta |
| fecha_pago | DATE | Fecha del pago |
| estado_pago | ENUM | pagado, pendiente, rechazado |
| pedido_fk | INT (FK → pedido.id) | Pedido pagado |

### 14. `historial_precios`
Auditoría de los cambios de precio de las pizzas a lo largo del tiempo.

| Campo | Tipo | Descripción |
|---|---|---|
| id | INT (PK) | Identificador único |
| precio_anterior | DOUBLE | Precio antes del cambio |
| precio_nuevo | DOUBLE | Precio después del cambio |
| fecha_modificacion | DATETIME | Momento del cambio |
| pizza_fk | INT (FK → pizza.id) | Pizza modificada |

---

## 🧮 Funciones

### `calcular_total_pedido(pedido_id INT)`
Calcula el total de un pedido sumando el valor de las pizzas, el costo de envío y el IVA (19%).

```sql
SELECT calcular_total_pedido(15) AS total_pedido;
```

### `ganancia_neta_diaria(fecha DATE)`
Calcula la ganancia neta del día restando el costo de los ingredientes usados a las ventas totales.

```sql
SELECT ganancia_neta_diaria('2025-05-10') AS ganancia_neta;
```

### `calcular_costo_envio(distancia DOUBLE)`
Calcula el costo de envío aplicando una tarifa escalonada según la distancia recorrida.

```sql
SELECT calcular_costo_envio(4.5) AS costo_envio;
```

### `estimar_tiempo_entrega(distancia DOUBLE)`
Estima el tiempo de entrega en minutos con base en la distancia del domicilio.

```sql
SELECT estimar_tiempo_entrega(3.2) AS tiempo_estimado_min;
```

### `es_cliente_frecuente(cliente_id INT, mes INT, año INT)`
Determina si un cliente realizó más de 5 pedidos durante un mes específico.

```sql
SELECT es_cliente_frecuente(8, 5, 2025) AS es_frecuente;
```

---

## ⚡ Procedimientos Almacenados

### `marcar_pedido_entregado(pedido_id INT)`
Cambia el estado del pedido a `'entregado'` y registra la hora de llegada en la tabla `domicilio`.

```sql
CALL marcar_pedido_entregado(20);
```

### `registrar_nuevo_pedido(cliente_id, metodo_pago, encargado_caja_id, distancia, zona)`
Crea un nuevo pedido y asigna automáticamente un repartidor disponible en la zona indicada.

```sql
CALL registrar_nuevo_pedido(3, 'tarjeta', 1, 5.0, 'norte');
```

### `registrar_nuevo_domicilio(pedido_id, repartidor_id, distancia, costo_envio)`
Registra el envío de un pedido con el costo de domicilio ya calculado.

```sql
CALL registrar_nuevo_domicilio(20, 2, 5.0, 6500);
```

### `actualizar_estado_repartidor(repartidor_id, nuevo_estado)`
Cambia la disponibilidad de un repartidor (disponible / no disponible).

```sql
CALL actualizar_estado_repartidor(2, 1);
```

### `agregar_pizza_a_pedido(pedido_id, pizza_id, cantidad)`
Agrega una pizza a un pedido existente y recalcula el total automáticamente.

```sql
CALL agregar_pizza_a_pedido(20, 4, 2);
```

---

## 🔁 Triggers

| Trigger | Evento | Función |
|---|---|---|
| `actualizar_stock_al_agregar_pizza` | AFTER INSERT en `pedido_pizzas` | Descuenta del stock los ingredientes usados por la pizza pedida |
| `historial_precios_pizza` | AFTER UPDATE en `pizza` | Registra en `historial_precios` cada cambio de precio |
| `liberar_repartidor` | AFTER UPDATE en `domicilio` | Marca al repartidor como disponible cuando se completa la entrega |
| `validar_repartidor_disponible` | BEFORE INSERT en `domicilio` | Verifica que el repartidor asignado esté disponible antes de crear el envío |
| `calcular_precio_envio` | BEFORE INSERT en `domicilio` | Calcula automáticamente el precio de envío según la distancia |
| `actualizar_precio_envio` | BEFORE UPDATE en `domicilio` | Recalcula el precio de envío si la distancia es modificada |
| `validar_stock_suficiente` | BEFORE INSERT en `pedido_pizzas` | Verifica que haya stock suficiente de ingredientes antes de confirmar la pizza |

---

## 👁️ Vistas Disponibles

| Vista | Descripción |
|---|---|
| `vista_resumen_clientes` | Nombre del cliente, total de pedidos, total gastado y promedio de gasto |
| `vista_desempeno_repartidores` | Repartidor, zona, número de entregas y tiempo promedio de entrega |
| `vista_stock_critico` | Ingredientes cuyo stock actual está por debajo del stock mínimo |
| `vista_ventas_diarias` | Ventas totales por día, número de pedidos y distribución por método de pago |
| `vista_pizzas_mas_vendidas` | Pizzas con mayor número de veces pedidas, unidades vendidas e ingresos generados |
| `vista_analisis_envios` | Detalle de cada envío: cliente, repartidor, distancia, costo y tiempo de entrega |

---

## 🔎 Ejemplos de Consultas SQL

**1. Clientes con pedidos entre dos fechas**
```sql
SELECT p.Nombre, p.Apellido, ped.fecha, ped.total
FROM pedido ped
JOIN cliente c ON ped.cliente_fk = c.id
JOIN Persona p ON c.id = p.id
WHERE ped.fecha BETWEEN '2025-05-01' AND '2025-05-31';
```

**2. Pizzas más vendidas**
```sql
SELECT pz.nombre, COUNT(*) AS veces_pedida, SUM(pp.cantidad) AS unidades_vendidas
FROM pedido_pizzas pp
JOIN pizza pz ON pp.pizza_fk = pz.id
GROUP BY pz.nombre
ORDER BY unidades_vendidas DESC;
```

**3. Pedidos por repartidor**
```sql
SELECT p.Nombre, p.Apellido, COUNT(d.id) AS total_domicilios
FROM domicilio d
JOIN repartidor r ON d.repartidor_fk = r.id
JOIN Persona p ON r.id = p.id
GROUP BY p.Nombre, p.Apellido;
```

**4. Clientes que gastaron más de un monto determinado**
```sql
SELECT c.id, p.Nombre, SUM(ped.total) AS total_gastado
FROM pedido ped
JOIN cliente c ON ped.cliente_fk = c.id
JOIN Persona p ON c.id = p.id
GROUP BY c.id, p.Nombre
HAVING SUM(ped.total) > 200000;
```

**5. Clientes frecuentes (más de 5 pedidos en el mes) usando subconsulta**
```sql
SELECT p.Nombre, p.Apellido
FROM cliente c
JOIN Persona p ON c.id = p.id
WHERE c.id IN (
    SELECT cliente_fk
    FROM pedido
    WHERE MONTH(fecha) = 5 AND YEAR(fecha) = 2025
    GROUP BY cliente_fk
    HAVING COUNT(*) > 5
);
```

---

## 🔄 Ejemplo de Flujo de Trabajo

1. **Registro del pedido:** el encargado de caja llama a `registrar_nuevo_pedido()` con los datos del cliente y el método de pago.
2. **Selección de pizzas:** se usa `agregar_pizza_a_pedido()` para cada pizza solicitada; el trigger `validar_stock_suficiente` valida el inventario y `actualizar_stock_al_agregar_pizza` descuenta los ingredientes usados.
3. **Cálculo del total:** la función `calcular_total_pedido()` determina el valor final incluyendo IVA y envío.
4. **Asignación de domicilio:** se ejecuta `registrar_nuevo_domicilio()`; el trigger `calcular_precio_envio` define el costo automáticamente y `validar_repartidor_disponible` confirma que el repartidor pueda tomar el pedido.
5. **Entrega:** al finalizar el recorrido se llama a `marcar_pedido_entregado()`, lo que actualiza el estado del pedido y, mediante el trigger `liberar_repartidor`, libera al repartidor para una nueva entrega.
6. **Pago:** se registra el pago correspondiente en la tabla `pago`, quedando el pedido completamente cerrado.
7. **Análisis:** el negocio consulta las vistas (`vista_ventas_diarias`, `vista_pizzas_mas_vendidas`, `vista_stock_critico`, etc.) para tomar decisiones operativas y comerciales.

---

## 👨‍💻 Autores

- **Jhonayker Quintero**

---

<p align="center">🍕 Hecho con dedicación para <strong>Pizzería Don Piccolo</strong> 🍕</p>
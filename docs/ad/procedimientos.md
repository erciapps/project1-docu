---
sidebar_position: 4
---

# FUNCIONES Y PROCEDIMIENTOS ALMACENADOS I
## Introducción a los procedimientos almacenados

### Creacción básica de un procedimiento

````postgresql
-- Crear un procedimiento que suma dos números
CREATE OR REPLACE FUNCTION suma(a INT, b INT)
    RETURNS INT
AS $$
DECLARE
    total INT;
BEGIN
    total := a + b;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

````
#### Partes del procedimiento
* `CREATE OR REPLACE FUNCTION` define el procedimiento.
* Parámetros `a` y `b` de tipo entero (`INT`)
* `RETURNS INT` define el tipo de retorno.
* **`DECLARE`** se usa para iniciar un bloque de declaración de variables 
* **`total INT`** declaración que define una variable llamada `total` de tipo entero `INT` 
* **`AS $$ ... $$`**: Delimita el **bloque completo** de código del procedimiento o función, señalando dónde empieza y termina el cuerpo principal del código.
* **`BEGIN ... END`**: Delimita el **bloque interno** de instrucciones que se ejecutarán dentro del cuerpo, permitiendo agrupar y estructurar varias instrucciones o lógica de control (como condiciones y bucles) en una secuencia organizada.
* **Diferencia clave**: `AS $$ ... $$` encapsula el cuerpo completo de la función o procedimiento, mientras que `BEGIN ... END` organiza y ejecuta instrucciones específicas dentro de ese cuerpo.


<details>
<summary>Tipos de Datos Comunes en PostgreSQL</summary>

#### Tipos Numéricos
- **INT o INTEGER**: Enteros de tamaño estándar.
- **SMALLINT**: Enteros pequeños.
- **BIGINT**: Enteros grandes.
- **NUMERIC(precision, scale) o DECIMAL**: Números de precisión arbitraria.
- **REAL**: Números en coma flotante (precisión simple).
- **DOUBLE PRECISION**: Números en coma flotante (doble precisión).

#### Tipos de Caracteres
- **VARCHAR(n)**: Cadenas de texto con longitud variable, donde `n` es la longitud máxima.
- **CHAR(n)**: Cadenas de texto de longitud fija, donde `n` es la longitud.
- **TEXT**: Cadenas de texto de longitud ilimitada.

#### Tipos de Fecha y Hora
- **DATE**: Fecha (año, mes, día).
- **TIME**: Hora del día (hora, minuto, segundo).
- **TIMESTAMP**: Marca de tiempo (fecha y hora).
- **INTERVAL**: Un intervalo de tiempo.

#### Tipos Booleanos
- **BOOLEAN**: `TRUE`, `FALSE` o `NULL`.

#### Tipos de Datos Binarios
- **BYTEA**: Datos binarios en formato de byte.

#### Tipos de Enumeraciones
- **ENUM**: Un conjunto fijo de valores predefinidos.

#### Tipos Geométricos
- **POINT**, **LINE**, **CIRCLE**, **POLYGON**, etc. para manejar geometría.

#### Tipos de Arrays
- Puedes pasar arrays de cualquier tipo. Por ejemplo, `INT[]` o `TEXT[]`.

#### Tipos JSON y XML
- **JSON**, **JSONB**: Para almacenar y manipular datos JSON.
- **XML**: Para datos en formato XML.

#### UUID (Universal Unique Identifier)
- **UUID**: Almacena identificadores únicos.

#### Tipos de IP
- **INET**: Direcciones IPv4 o IPv6.
- **CIDR**: Redes IP.

</details>


## Ejecutar un procedimiento desde consola
Para llamar a un procedimiento que **no retona ningún valor** se ejecuta con la sentencia:
````sql
CALL nombre_funcion();
````

Para llamar a un procedimiento que **retona valores** se ejecuta con la sentencia:
````sql
SELECT nombre_funcion();
````


## Ejemplos de procedimientos
Para realizar los ejemplos proponemos la siguiente base de datos
### Base de datos de ejemplo
````sql
-- Tabla Producto
CREATE TABLE Producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- Tabla Venta
CREATE TABLE Venta (
    id_venta SERIAL PRIMARY KEY,
    id_producto INT REFERENCES Producto(id_producto),
    cantidad INT NOT NULL,
    fecha_venta DATE NOT NULL
);

-- Datos de ejemplo para Producto
INSERT INTO Producto (nombre, precio) VALUES
('Producto A', 10.00),
('Producto B', 20.00),
('Producto C', 15.50);

-- Datos de ejemplo para Venta
INSERT INTO Venta (id_producto, cantidad, fecha_venta) VALUES
(1, 2, '2024-10-01'),
(2, 1, '2024-10-02'),
(3, 5, '2024-10-03');

````

### PROCEDIMIENTO 0. Registrar producto
Crea un procedimiento almacenado con el nombre `registrar_producto`, para registrar un nuevo producto y que reciba:
* nombre del producto
* precio del producto

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE PROCEDURE registrar_producto(
    _nombre VARCHAR,
    _precio DECIMAL(10, 2)
)
AS $$
BEGIN
    INSERT INTO Producto (nombre, precio)
    VALUES (_nombre, _precio);
    RAISE NOTICE 'Producto registrado: %', _nombre;  -- Mensaje de éxito
END;
$$ LANGUAGE plpgsql;
````

````sql
CALL registrar_producto('Producto D', 25.00);
````

#### Método DAO

````java
public boolean registrarProducto(String nombre, BigDecimal precio) throws SQLException {
        if (!initDBConnection()) {
            throw new SQLException("Error al conectar con la base de datos");
        }
        try{
            String sql = "CALL registrar_producto(?, ?)";
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setString(1, nombre);
            stmt.setBigDecimal(2, precio); // Usa BigDecimal para DECIMAL
            stmt.execute();
            return true;
        }catch (Exception e){
            return false;
        }finally {
            // Asegúrate de cerrar la conexión si es necesario
            if (connection != null) {
                connection.close();
            }
        }
    }
````

#### Llamada al método
````java
TiendaDAO tiendaDAO = new TiendaDAO();

        try {
            if(tiendaDAO.registrarProducto("Un producto", BigDecimal.valueOf(12.34))){
                JOptionPane.showMessageDialog(null, "Producto registrado");
            }else{
                JOptionPane.showMessageDialog(null, "No se pudo registrar producto");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            JOptionPane.showMessageDialog(null, "No se pudo registrar el producto");
        }
````

</details>

### PROCEDIMIENTO 1. Registrar venta

Crea un procedimiento almacenado con el nombre `registrar_venta`, para regustrar la venta de un producto 
y que reciba:
* id del producto
* cantidad
* fecha

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE PROCEDURE registrar_venta(
    _id_producto INT,
    _cantidad INT,
    _fecha_venta DATE
)
AS $$
BEGIN
    INSERT INTO Venta (id_producto, cantidad, fecha_venta)
    VALUES (_id_producto, _cantidad, _fecha_venta);
END;
$$ LANGUAGE plpgsql;

````

````sql
CALL registrar_venta(1,3,'2023-10-21');
````

#### Método DAO

````java
public boolean registrarVenta(int id_producto, int cantidad, LocalDate fecha) throws SQLException {
        if (!initDBConnection()) {
            throw new SQLException("Error al conectar con la base de datos");
        }
        try{
            String sql = "CALL registrar_venta(?, ?, ?)";
            CallableStatement stmt = connection.prepareCall(sql);
            stmt.setInt(1, id_producto);
            stmt.setInt(2, cantidad);
            stmt.setDate(3, Date.valueOf(fecha));
            stmt.execute();
            return true;
        }catch (Exception e){
            return false;
        }finally {
            // Asegúrate de cerrar la conexión si es necesario
            if (connection != null) {
                connection.close();
            }
        }
    }
````

#### Llamada al método
````java
try {
            if(tiendaDAO.registrarVenta(1, 34, LocalDate.now())){
                JOptionPane.showMessageDialog(null, "Venta registrada");
            }else{
                JOptionPane.showMessageDialog(null, "No se pudo registrar la venta");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            JOptionPane.showMessageDialog(null, "No se pudo registrar la venta");
        }
````

</details>

### PROCEDIMIENTO 2. Actualiza precio

Crea un procedimiento almacenado para actualizar el precio de un producto, 
con el nombre `actualizar_precio`, y que reciba:
* id del producto
* precio

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE PROCEDURE actualizar_precio(
    _id_producto INT,
    _nuevo_precio DECIMAL
)
AS $$
BEGIN
UPDATE Producto SET precio = _nuevo_precio WHERE id_producto = _id_producto;
END;
$$ LANGUAGE plpgsql;
````
````sql
CALL actualizar_precio(1,2.25);
````

</details>

### PROCEDIMIENTO 3. Eliminar producto

Crea un procedimiento almacenado con el nombre `eliminar_producto` que reciba:
* id del producto

<details>

<summary>Haz clic para ver la solución</summary>
Eliminar un producto que tiene una venta asociada, es decir, se hace referencia a la id del producto en otra tabla,
sólo es posible si:
1. **Eliminar la venta del producto manualmente**: esto implica tener que ejecutar la consulta e identificar donde aparece el producto 
(incluso podría aparecer en varias tablas).
2. **Modificar la tabla para indicar que se realize la eliminación en cascada**. Esto no es recomendable en bases de datos
donde es necesario mantener un registro de los datos almacenados.

````sql
ALTER TABLE Venta
ADD CONSTRAINT fk_producto_venta
FOREIGN KEY (id_producto)
REFERENCES Producto(id_producto)
ON DELETE CASCADE;
````
Una vez que has configurado la relación con `ON DELETE CASCADE`, tu procedimiento funcionará como esperas, 
eliminando tanto el producto como todas las ventas asociadas:

```sql
CREATE OR REPLACE PROCEDURE eliminar_producto(_id_producto INT)
AS $$
BEGIN
    DELETE FROM Producto WHERE id_producto = _id_producto;
END;
$$ LANGUAGE plpgsql;
````

3. Eliminar el producto si no tiene ventas asociadas. Esto no es una solución a largo plazo.
````sql
CREATE OR REPLACE PROCEDURE eliminar_producto(_id_producto INT)
AS $$
BEGIN
    -- Verificar si hay ventas asociadas
    IF NOT EXISTS (SELECT 1 FROM Venta WHERE id_producto = _id_producto) THEN
        DELETE FROM Producto WHERE id_producto = _id_producto;
    ELSE
        RAISE NOTICE 'No se puede eliminar el producto, tiene ventas asociadas';
    END IF;
END;
$$ LANGUAGE plpgsql;
````

4. Marcar el producto como inactivo en lugar de eliminarlo. Esto es aconsejable para base de datos que en un determinado
momento no necesitan mostrar cierta información, pero es necesario mantener constancia de los datos.
Modificar tabla Producto para añadir dato activo:
````sql
ALTER TABLE Producto ADD COLUMN activo BOOLEAN DEFAULT TRUE;
````
Procedimiento almacenado:
````sql
CREATE OR REPLACE PROCEDURE eliminar_producto(_id_producto INT)
AS $$
BEGIN
    UPDATE Producto SET activo = FALSE WHERE id_producto = _id_producto;
END;
$$ LANGUAGE plpgsql;
````
</details>


### PROCEDIMIENTO 4. Cambiar nombre de un producto
Crea un procedimiento almacenado para cambiar el nombre de un producto,
con el nombre `cambiar_nombre_producto`, y que reciba:
* id del producto
* nuevo nombre

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE PROCEDURE cambiar_nombre_producto(
    _id_producto INT,
    _nuevo_nombre VARCHAR
)
AS $$
BEGIN
UPDATE Producto SET nombre = _nuevo_nombre WHERE id_producto = _id_producto;
END;
$$ LANGUAGE plpgsql;
````
</details>

### PROCEDIMIENTO 5. Obtener precio de un producto
Crea un procedimiento almacenado para cambiar el nombre de un producto,
con el nombre `obtener_precio_producto`, y que reciba:
* id del producto

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION obtener_precio_producto(_id_producto INT)
RETURNS DECIMAL
AS $$
DECLARE
    _precio DECIMAL;
BEGIN
    SELECT precio INTO _precio FROM Producto WHERE id_producto = _id_producto;
    RETURN _precio;
END;
$$ LANGUAGE plpgsql;

````

#### Método DAO

````java
public BigDecimal obtenerPrecioProducto(int id_producto) throws SQLException {
    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }
    try {
        String sql = "{ ? = CALL obtener_precio_producto(?) }"; // Preparar la llamada a la función
        CallableStatement stmt = connection.prepareCall(sql);

        // Registramos el tipo de retorno
        stmt.registerOutParameter(1, Types.DECIMAL); // Tipo de retorno de la función
        stmt.setInt(2, id_producto); // Establecer el parámetro de entrada

        stmt.execute(); // Ejecutar la llamada a la función

        // Obtener el valor de retorno
        BigDecimal precio = stmt.getBigDecimal(1); // Obtener el precio devuelto por la función
        return precio;
    } catch (SQLException e) {
        // Manejar excepciones específicas de SQL
        throw new SQLException("Error al obtener el precio del producto: " + e.getMessage(), e);
    } finally {
        // Asegúrate de cerrar la conexión si es necesario
        if (connection != null) {
            connection.close();
        }
    }
}
````

#### Llamada al método
````java
try {
    BigDecimal precio = tiendaDAO.obtenerPrecioProducto(1);
    if (precio != null) {
        JOptionPane.showMessageDialog(null, "El precio del producto es: " + precio);
    } else {
        JOptionPane.showMessageDialog(null, "No se encontró el producto");
    }
} catch (SQLException e) {
    System.out.println(e.getMessage());
    JOptionPane.showMessageDialog(null, "No se pudo obtener el precio del producto");
}
````

</details>


### PROCEDIMIENTO 6. Contar ventas de un producto
Crea un procedimiento almacenado para obtener las veces que un producto ha sido vendido (cada 
operación, no el total de la cantidad de vendida).
con el nombre `contar_ventas_producto`, y que reciba:
* id del producto

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION contar_ventas_producto(_id_producto INT)
RETURNS INT
AS $$
DECLARE
    _total_ventas INT;
BEGIN
    SELECT COUNT(*) INTO _total_ventas FROM Venta WHERE id_producto = _id_producto;
    RETURN _total_ventas;
END;
$$ LANGUAGE plpgsql;
````
</details>


### PROCEDIMIENTO 7. Obtener la cantidad total vendida de un producto
Crea un procedimiento almacenado para cambiar el nombre de un producto,
con el nombre `obtener_total_cantidad_vendida`, y que reciba:
* id del producto

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION obtener_total_cantidad_vendida(_id_producto INT)
RETURNS INT
AS $$
DECLARE
    _total_cantidad INT;
BEGIN
    SELECT SUM(cantidad) INTO _total_cantidad FROM Venta WHERE id_producto = _id_producto;
    RETURN _total_cantidad;
END;
$$ LANGUAGE plpgsql;

````
</details>

### PROCEDIMIENTO 8. Verificar nombre al registrar con SELECT

Crea un procedimiento almacenado con el nombre `registrar_producto_2`, para registrar un nuevo producto y que reciba:

* nombre del producto
* precio del producto
El procedimiento debe retornar:
* **`TRUE`** si la operación es exitosa (el producto fue registrado).
* **`FALSE`** si ya existe un producto con el mismo nombre.

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION registrar_producto_2(
    _nombre VARCHAR,
    _precio DECIMAL(10, 2)
)
RETURNS BOOLEAN 
AS $$
BEGIN
    -- Verificar si el producto ya existe
    IF EXISTS (SELECT 1 FROM Producto WHERE nombre = _nombre) THEN
        RETURN FALSE;  -- Producto ya existe
    ELSE
        -- Insertar el nuevo producto
        INSERT INTO Producto (nombre, precio)
        VALUES (_nombre, _precio);
        RETURN TRUE;  -- Producto registrado exitosamente
    END IF;
END;
$$ LANGUAGE plpgsql;
````

````sql
SELECT registrar_producto_2('Producto A', 30.00) AS resultado;
````

#### Método DAO
````java
public boolean registrarProducto(String nombre, BigDecimal precio) throws SQLException {
    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }
    try {
        String sql = "{ ? = CALL registrar_producto_2(?, ?) }"; // Llamada a la función
        CallableStatement stmt = connection.prepareCall(sql);
        stmt.registerOutParameter(1, Types.BOOLEAN); // Registrar parámetro de salida
        stmt.setString(2, nombre); // Establecer el nombre del producto
        stmt.setBigDecimal(3, precio); // Establecer el precio del producto
        stmt.execute(); // Ejecutar la llamada
        return stmt.getBoolean(1); // Obtener el resultado (true o false)
    } catch (Exception e) {
        throw new SQLException("Error al registrar el producto: " + e.getMessage());
    }finally {
        // Asegúrate de cerrar la conexión si es necesario
        if (connection != null) {
            connection.close();
        }
    }
}

````

#### Llamada al método
```java
try {
    boolean resultado = tiendaDAO.registrarProducto("Producto 1", new BigDecimal("20.50"));
    if (resultado) {
        JOptionPane.showMessageDialog(null, "Producto registrado exitosamente");
    } else {
        JOptionPane.showMessageDialog(null, "El producto ya existe");
    }
} catch (SQLException e) {
    System.out.println(e.getMessage());
    JOptionPane.showMessageDialog(null, "No se pudo registrar el producto");
}

```

</details>


### PROCEDIMIENTO 9. Crear producto verificando nombre con excepciones (sin elevar)
Modifica la tabla `producto` para que la columna `nombre` sea única:

````sql
ALTER TABLE Producto
ADD CONSTRAINT unique_nombre UNIQUE (nombre);
````

Crea un procedimiento llamado `registrar_producto_3`, que registre un nuevo producto en la tabla `producto`. 
La función debe recibir:
* Nombre del producto
* Precio del producto

Debe retornar `TRUE` si el producto se registra correctamente y `FALSE` si ya existe un producto con el mismo nombre (con excepciones).

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION registrar_producto_3(
    _nombre VARCHAR,
    _precio DECIMAL(10, 2)
)
RETURNS BOOLEAN
AS $$
BEGIN
    INSERT INTO Producto (nombre, precio)
    VALUES (_nombre, _precio);
    RAISE NOTICE 'Producto registrado: %', _nombre;  -- Mensaje de éxito
    RETURN TRUE;  -- Retorna verdadero si la inserción es exitosa

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'El producto con el nombre "%" ya existe.', _nombre;  -- Mensaje de error
        RETURN FALSE;  -- Retorna falso si hay una violación de unicidad
END;
$$ LANGUAGE plpgsql;


````

````sql
SELECT registrar_producto_3('Producto A', 30.00) AS resultado;
````

#### Método DAO
````java
public boolean registrarProducto(String nombre, BigDecimal precio) throws SQLException {
    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }
    try{
        String sql = "{ ? = CALL registrar_producto_3(?, ?) }"; // Llamada a la función
        CallableStatement stmt = connection.prepareCall(sql);
        stmt.registerOutParameter(1, Types.BOOLEAN); // Registrar parámetro de salida
        stmt.setString(2, nombre); // Establecer el nombre del producto
        stmt.setBigDecimal(3, precio); // Establecer el precio del producto
        stmt.execute(); // Ejecutar la llamada
        return stmt.getBoolean(1); // Obtener el resultado (true o false)
    }catch (Exception e){
        throw new SQLException("Error al registrar el producto: " + e.getMessage());
    }finally {
        // Asegúrate de cerrar la conexión si es necesario
        if (connection != null) {
            connection.close();
        }
    }
}
````


#### Llamada al método
````java
try {
    boolean resultado = tiendaDAO.registrarProducto("Producto 1", new BigDecimal("20.50"));
    if (resultado) {
        JOptionPane.showMessageDialog(null, "Producto registrado exitosamente");
    } else {
        JOptionPane.showMessageDialog(null, "El producto ya existe");
    }
} catch (SQLException e) {
    System.out.println(e.getMessage());
    JOptionPane.showMessageDialog(null, "No se pudo registrar el producto");
}

````


</details>


### PROCEDIMIENTO 10. Registrar producto comprobando precio positivo y elevando excepciones
Crea un procedimiento llamado `registrar_producto_4`, que registre un nuevo producto en la tabla Producto. 
El procedimiento debe recibir:

* Nombre del producto
* Precio del producto

Antes de insertar el producto, debe verificar que el precio sea un valor positivo. 
Si el precio es menor o igual a cero, se debe lanzar una excepción con un mensaje adecuado. 
Si ya existe un producto con el mismo nombre, también se debe lanzar una excepción personalizada.

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE PROCEDURE registrar_producto_4(
    _nombre VARCHAR,
    _precio DECIMAL(10, 2)
)
AS $$
BEGIN
    -- Verificar que el precio sea positivo
    IF _precio <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser un valor positivo.';
    END IF;

    INSERT INTO Producto (nombre, precio)
    VALUES (_nombre, _precio);
    
    RAISE NOTICE 'Producto registrado: %', _nombre;  -- Mensaje de éxito

EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'El producto con el nombre "%" ya existe.', _nombre;  -- Mensaje de error personalizado
END;
$$ LANGUAGE plpgsql;
````

````sql
CALL registrar_producto_4('Producto A', 30.00);
````

#### Método DAO
````java
public boolean registrarProducto_4(String nombre, BigDecimal precio) throws SQLException {
    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }
    try{
        String sql = "CALL registrar_producto_4(?, ?)"; // Llamada al procedimiento
        CallableStatement stmt = connection.prepareCall(sql);
        stmt.setString(1, nombre); // Establecer el nombre del producto
        stmt.setBigDecimal(2, precio); // Establecer el precio del producto
        stmt.execute(); // Ejecutar la llamada
        return true; // Producto registrado exitosamente
    } catch (SQLException e) {
        // Aquí capturamos la excepción y verificamos el mensaje
        if (e.getMessage().contains("El producto con el nombre")) {
            return false; // Retornar falso si el error es por precio no positivo
        }
        throw e;
    } finally {
        // Asegúrate de cerrar la conexión si es necesario
        if (connection != null) {
            connection.close();
        }
    }
}
````

#### Llamada al método
````java
try {
    boolean resultado = tiendaDAO.registrarProducto_4("Producto 212", new BigDecimal("20.50"));
    if (resultado) {
        JOptionPane.showMessageDialog(null, "Producto registrado exitosamente");
    } else {
        JOptionPane.showMessageDialog(null, "El nombre del producto ya existe");
    }
} catch (SQLException e) {
    System.out.println(e.getMessage());
    JOptionPane.showMessageDialog(null, e.getMessage().split("\n")[0]);
}
````


</details>




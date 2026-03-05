---
sidebar_position: 1
---

# SQL
## Tipos de Datos Comunes
* **INTEGER:** Para números enteros.
* **SERIAL:** Tipo de dato autoincremental para enteros.
* **VARCHAR(n):** Cadena de texto de longitud variable.
* **TEXT:** Cadena de texto sin límite de longitud.
* **BOOLEAN:** Valores verdadero/falso.
* **DATE:** Para almacenar fechas.
* **TIMESTAMP:** Para almacenar fecha y hora.
* **NUMERIC(precision, scale):** Para almacenar números con decimales.

## Crear una tabla
```postgresql
CREATE TABLE nombre_tabla (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INTEGER,
    fecha_registro DATE DEFAULT CURRENT_DATE
);
```


## Restricciones (Constraints)
Los **constraints** (o restricciones) en PostgreSQL son reglas que se aplican a las columnas de una tabla para asegurar 
la integridad de los datos.

### PRIMARY KEY
* Asegura que cada fila en una tabla tenga un identificador único.
* No se permiten valores nulos en la columna o columnas que forman la clave primaria.

```postgresql
CREATE TABLE empleados (
    empleado_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);
```

### FOREIGN KEY
* Establece una relación entre dos tablas. Asegura que el valor en la columna de la tabla hija exista en la columna 
correspondiente de la tabla padre.

```postgresql
CREATE TABLE departamentos (
    departamento_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE empleados (
    empleado_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    departamento_id INTEGER REFERENCES departamentos(departamento_id)
);

```

### UNIQUE
* Asegura que todos los valores en una columna o combinación de columnas sean únicos.
* A diferencia de la clave primaria, permite valores nulos.

```postgresql
CREATE TABLE usuarios (
    usuario_id SERIAL PRIMARY KEY,
    correo VARCHAR(100) UNIQUE
);

```

### NOT NULL
* Asegura que una columna no pueda contener valores nulos.
```postgresql
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC NOT NULL
);

```

### CHECK
* Permite definir una condición que debe ser verdadera para los valores de una columna o de una fila.

```postgresql
CREATE TABLE empleados (
    empleado_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    edad INTEGER CHECK (edad >= 18)
);
```

### DEFAULT
* Establece un valor por defecto para una columna cuando no se proporciona ningún valor durante la inserción.

```postgresql
CREATE TABLE eventos (
    evento_id SERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### EXCLUDE
* Define restricciones de exclusión para asegurar que los valores en una o más columnas no se superpongan de acuerdo a una condición.
```postgresql
CREATE TABLE reservaciones (
    id SERIAL PRIMARY KEY,
    inicio TIMESTAMP,
    fin TIMESTAMP,
    EXCLUDE USING GIST (tsrange(inicio, fin) WITH &&)
);
```
Este ejemplo evita que se superpongan rangos de fechas.

### Modificar Restricciones
Si necesitas agregar o eliminar restricciones después de crear la tabla, puedes usar los siguientes comandos:

* Agregar una restricción:
```postgresql
ALTER TABLE nombre_tabla ADD CONSTRAINT nombre_restriccion UNIQUE (columna);
```
* Eliminar una restricción: 
```postgresql
ALTER TABLE nombre_tabla DROP CONSTRAINT nombre_restriccion;
```

## EJEMPLO - Crear tabla
:::info Ejemplo
**Crea una tabla con el nombre `dinosaurios`, que tenga los siguientes valores:**
* `id` - autoincremental como clave primaria.
* `nombre` - VARCHAR(50) No permitir valores nulos/vacíos. De tipo `UNIQUE`
* `volador` - Tipo booleano (verdadero / falso). Valor por defecto `false`
* `peso` - Tipo entero: No permitir valores mayores a 100
* `fecha` - Tipo `DATE`
* `ataque` - `VARCHAR(50)`
* `alimentacion` - los valores de alimentación deben de tener relación con la tabla `alimentacion` la cual debes crear:
    * `id` - autoincremental como clave primaria.
    * `alimentacion` - `VARCHAR(50)`, valor único y no nulo
:::

<details>
<summary>Haz clic para ver la solución</summary>

```sql
-- Crear la tabla alimentacion
CREATE TABLE alimentacion (
    id SERIAL PRIMARY KEY,          -- Clave primaria autoincremental
    alimentacion VARCHAR(50) UNIQUE NOT NULL  -- Valor único y no nulo
);

-- Crear la tabla dinosaurios
CREATE TABLE dinosaurios (
id SERIAL PRIMARY KEY,            -- Clave primaria autoincremental
nombre VARCHAR(50) UNIQUE NOT NULL,  -- Valor único y no nulo
volador BOOLEAN DEFAULT FALSE,    -- Valor booleano, por defecto falso
peso INTEGER CHECK (peso <= 100), -- Entero, no permitir valores mayores a 100
fecha DATE,                       -- Tipo DATE para la fecha
ataque VARCHAR(50),               -- Cadena para el ataque
alimentacion_id INTEGER REFERENCES alimentacion(id) -- Relación con la tabla alimentacion
);

```
</details>



## Insertar
### `INSERT INTO`
Inserta nuevas filas en una tabla
```postgresql
INSERT INTO table_name (column1, column2) 
VALUES (value1, value2);
```
Ejemplo:
```postgresql
INSERT INTO employees (name, age, department_id) 
VALUES ('John Doe', 28, 1);

```

## EJEMPLO - Insertar
:::info Ejemplo para insertar en tabla
**Inserta 5 elementos en la tabla `dinosaurios` y 5 elementos en la tabla `alimentacion`**
:::

<details>
<summary>Haz clic para ver la solución</summary>

```sql
-- Insertar 5 elementos en la tabla alimentacion
INSERT INTO alimentacion (alimentacion) VALUES ('Herbívoro');
INSERT INTO alimentacion (alimentacion) VALUES ('Carnívoro');
INSERT INTO alimentacion (alimentacion) VALUES ('Omnívoro');
INSERT INTO alimentacion (alimentacion) VALUES ('Insectívoro');
INSERT INTO alimentacion (alimentacion) VALUES ('Piscívoro');

-- Insertar 5 elementos en la tabla dinosaurios
INSERT INTO dinosaurios (nombre, volador, peso, fecha, ataque, alimentacion_id)
VALUES ('Tyrannosaurus Rex', false, 80, '2024-01-01', 'Mordida poderosa', 2);

INSERT INTO dinosaurios (nombre, volador, peso, fecha, ataque, alimentacion_id)
VALUES ('Velociraptor', false, 15, '2024-02-15', 'Garras afiladas', 2);

INSERT INTO dinosaurios (nombre, volador, peso, fecha, ataque, alimentacion_id)
VALUES ('Pteranodon', true, 25, '2024-03-20', 'Ataque en picada', 5);

INSERT INTO dinosaurios (nombre, volador, peso, fecha, ataque, alimentacion_id)
VALUES ('Triceratops', false, 100, '2024-04-10', 'Embiste con cuernos', 1);

INSERT INTO dinosaurios (nombre, volador, peso, fecha, ataque, alimentacion_id)
VALUES ('Stegosaurus', false, 75, '2024-05-05', 'Cola con púas', 1);
```
</details>


## Seleccionar Datos
### `SELECT` 
Recupera datos de una tabla.
#### Seleccionar columnas específicas:
```postgresql
SELECT column1, column2 
FROM table_name;
```

#### Seleccionar todas las columnas:
```postgresql
SELECT * 
FROM table_name;
```

## Filtrar Datos
### `WHERE` 
Filtra filas basadas en una condición.
```postgresql
SELECT column1, column2 
FROM table_name WHERE condition;
```
Ejemplo:
```postgresql
SELECT name, age 
FROM employees 
WHERE age > 30;
```
### `LIKE`
La cláusula `LIKE` se utiliza para buscar un patrón en una columna de texto (cadena de caracteres). 
Es muy útil cuando no conoces el valor exacto que estás buscando, pero tienes una idea del patrón que debe coincidir.
```postgresql
SELECT column1, column2
FROM table_name
WHERE column_name LIKE 'pattern';
```
**Patrones comunes:**
* `%`: Representa cero, uno o más caracteres.   
Ejemplo: `'A%'` coincide con cualquier cadena que comience con la letra **A**.
* `_`: Representa un solo carácter.   
Ejemplo: `'A_'` coincide con cualquier cadena de dos caracteres que comience con la letra **A**.

**Ejemplos**
1. Buscar nombres que comiencen con "Jo":
```postgresql
SELECT * FROM employees
WHERE first_name LIKE 'Jo%';
```
Esto devuelve resultados como "John", "Joseph", etc.

2. Buscar nombres que terminen con "n":
```postgresql
SELECT * FROM employees
WHERE first_name LIKE '%n';
```
Esto devolverá resultados como "John", "Brian", etc.

3. Buscar nombres de cuatro letras que comiencen con "A":Buscar nombres de cuatro letras que comiencen con "A":
```postgresql
SELECT * FROM employees
WHERE first_name LIKE 'A___';
```
Esto busca cualquier nombre de cuatro letras que comience con la letra "A".

### `BETWEEN`
La cláusula BETWEEN se utiliza para filtrar los resultados que están dentro de un rango, incluyendo los límites. 
Puede aplicarse a números, fechas y valores de texto en algunos casos.

```postgresql
SELECT column1, column2
FROM table_name
WHERE column_name BETWEEN value1 AND value2;
```

**Ejemplos**
1. Filtrar empleados con un salario entre 3000 y 7000:
```postgresql
SELECT * FROM employees
WHERE salary BETWEEN 3000 AND 7000;
```

2. Filtrar registros de ventas entre dos fechas:
```postgresql
SELECT * FROM sales
WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31';
```


### `IN`
La cláusula `IN` se utiliza para especificar múltiples valores en la cláusula `WHERE`. Es más eficiente que usar múltiples condiciones `OR`.
```
SELECT column1, column2
FROM table_name
WHERE column_name IN (value1, value2, value3, ...);
```
**Ejemplo**:
Seleccionar empleados que trabajan en los departamentos 1, 2 o 3:
```postgresql
SELECT * FROM employees
WHERE department_id IN (1, 2, 3);
```
Es equivalente a:
```postgresql
SELECT * FROM employees
WHERE department_id = 1 OR department_id = 2 OR department_id = 3;
```

### `DISTINCT`
La cláusula `DISTINCT` se usa para devolver solo valores únicos, eliminando duplicados.

```postgresql
SELECT DISTINCT column1
FROM table_name;
```

**Ejemplo**
Seleccionar los departamentos únicos de una tabla de empleados:
```postgresql
SELECT DISTINCT department
FROM employees;
```

### `LIMIT / OFFSET`
Estas cláusulas se usan para limitar el número de filas devueltas o para "saltar" un número de filas antes de 
comenzar a devolver resultados.
```postgresql
SELECT column1, column2
FROM table_name
LIMIT number OFFSET number;
```
**Ejemplo:**
Seleccionar los 5 primeros empleados con salarios más altos:
```postgresql
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 5;
```
Seleccionar los siguientes 5 empleados (saltando los primeros 5):
```postgresql
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 5 OFFSET 5;
```

## EJEMPLO - Filtrar datos
:::info Ejemplo para filtrar en tabla
**Realiza las siguientes consultas SQL sobre la tabla dinosaurios que creaste previamente. Utiliza las cláusulas `WHERE, LIKE, BETWEEN, IN, DISTINCT, LIMIT y OFFSET`.**

**Apartados:**
1. **Seleccionar dinosaurios cuyo nombre comience con la letra "T".**
* Usa la cláusula `LIKE` para buscar nombres que comiencen con una letra específica.

2. **Seleccionar dinosaurios que pesen entre 20 y 80 kg.**
* Utiliza la cláusula `BETWEEN` para seleccionar un rango de peso.

3. **Seleccionar dinosaurios con un tipo de alimentación "Carnívoro" o "Herbívoro".**
* Usa la cláusula `IN` para filtrar por varios valores de la tabla relacionada.

4. **Obtener los tipos de ataque distintos que tienen los dinosaurios.**
* Utiliza la cláusula `DISTINCT` para obtener valores únicos.

5. **Mostrar los primeros 3 dinosaurios registrados en la tabla, saltando el primero.**
* Usa `LIMIT` para limitar el número de resultados y `OFFSET` para saltar los primeros.
:::

<details>

  <summary>Haz clic para ver la solución</summary>
  
  **Solución en SQL:**
  1. Seleccionar dinosaurios cuyo nombre comience con la letra "T".
  ```sql
  SELECT * 
  FROM dinosaurios 
  WHERE nombre LIKE 'T%';
  ```
  
  2. **Seleccionar dinosaurios que pesen entre 20 y 80 kg.**
  ```sql
  SELECT * 
  FROM dinosaurios 
  WHERE peso BETWEEN 20 AND 80;
  ```
  
  3. **Seleccionar dinosaurios con un tipo de alimentación "Carnívoro" o "Herbívoro".**
  ```sql
  SELECT * 
  FROM dinosaurios 
  WHERE alimentacion_id IN (
      SELECT id 
      FROM alimentacion 
      WHERE alimentacion IN ('Carnívoro', 'Herbívoro')
  );
  ```
  _Este comando selecciona los dinosaurios que tienen una alimentación de tipo "Carnívoro" o "Herbívoro", 
  utilizando la cláusula `IN` para filtrar valores relacionados de la tabla `alimentacion`._
  
  4. **Obtener los tipos de ataque distintos que tienen los dinosaurios.**
  ```sql
  SELECT DISTINCT ataque 
  FROM dinosaurios;
  ```
  
  5. **Mostrar los primeros 3 dinosaurios registrados en la tabla, saltando el primero.**
  ```sql
  SELECT * 
  FROM dinosaurios 
  ORDER BY id 
  LIMIT 3 OFFSET 1;
  ```
  _Este comando selecciona los primeros 3 dinosaurios, pero saltando el primero en el orden por `id`. `LIMIT` 3 limita 
  el resultado a 3 filas, y `OFFSET` 1 salta la primera fila._

</details>


## Ordenar Datos
### `ORDER BY`
Ordena los resultados de una consulta.
```postgresql
SELECT column1, column2 
FROM table_name 
ORDER BY column1 [ASC|DESC];
```
Ejemplo:
```postgresql
SELECT name, age 
FROM employees 
ORDER BY age DESC;

```

## Funciones de Agregación
### `COUNT():` 
Cuenta el número de filas.
```postgresql
SELECT COUNT(*) FROM table_name;
```
Ejemplo:
```postgresql
SELECT COUNT(*) FROM employees;
```

### `SUM():` 
Suma los valores de una columna numérica.
```postgresql
SELECT SUM(column_name) FROM table_name;

```
Ejemplo:
```postgresql
SELECT SUM(salary) FROM employees;

```

### `AVG()`: 
Calcula el promedio de una columna numérica.
```postgresql
SELECT AVG(column_name) FROM table_name;

```
Ejemplo:
```postgresql
SELECT AVG(age) FROM employees;
```

### `MAX() y MIN()`: 
Devuelven el valor máximo o mínimo de una columna.
```postgresql
SELECT MAX(column_name) FROM table_name;
SELECT MIN(column_name) FROM table_name;

```
Ejemplo:
```postgresql
SELECT MAX(salary) FROM employees;
SELECT MIN(age) FROM employees;
```


## EJEMPLO - Consultas agregadas
:::info Ejemplo para consultas agregadas en tabla
**Realiza las siguientes consultas SQL sobre la tabla dinosaurios utilizando las funciones agregadas `COUNT, SUM, AVG, MAX y MIN.`**

**Apartados:**
**1. Contar cuántos dinosaurios existen en la tabla.**
* Usa la función `COUNT` para contar el número total de dinosaurios.

**2. Calcular el peso total de todos los dinosaurios.**
* Utiliza la función `SUM` para sumar el valor del peso de todos los dinosaurios.

**3. Calcular el peso promedio de los dinosaurios.**
* Usa la función `AVG` para obtener el peso medio de los dinosaurios.

**4. Obtener el peso máximo de los dinosaurios.**
* Utiliza la función `MAX` para encontrar el peso más alto registrado en la tabla.

**5. Obtener el peso mínimo de los dinosaurios.**
* Utiliza la función `MIN` para encontrar el peso más bajo registrado en la tabla.
:::

<details>

  <summary>Haz clic para ver la solución</summary>

**Solución en SQL:**
**1. Contar cuántos dinosaurios existen en la tabla.**
  ```sql
SELECT COUNT(*) AS total_dinosaurios
FROM dinosaurios;
  ```

**2. Calcular el peso total de todos los dinosaurios**
  ```sql
SELECT SUM(peso) AS peso_total
FROM dinosaurios;
  ```

**3. Calcular el peso promedio de los dinosaurios.**
  ```sql
SELECT AVG(peso) AS peso_promedio
FROM dinosaurios;
  ```

**4. Obtener el peso máximo de los dinosaurios.**
  ```sql
SELECT MAX(peso) AS peso_maximo
FROM dinosaurios;
  ```

**5. Obtener el peso mínimo de los dinosaurios.**
  ```sql
SELECT MIN(peso) AS peso_minimo
FROM dinosaurios;
  ```

</details>



## Agrupación de datos
### `GROUP BY` 
Agrupa filas que tienen el mismo valor en columnas especificadas.

```postgresql
SELECT column1, AGGREGATE_FUNCTION(column2)
FROM table_name 
GROUP BY column1;
```

Ejemplo:
```postgresql
SELECT department, name 
FROM employees 
GROUP BY department;
```
### `HAVING` 
Filtra grupos de datos después de la agrupación.
En la cláusula `HAVING` es necesario usar una función agregada (como `COUNT(), SUM(), AVG()`, etc.). 
La razón es que `HAVING` se utiliza para filtrar los resultados después de que se haya hecho la agrupación con `GROUP BY`
```postgresql
SELECT column1, AGGREGATE_FUNCTION(column2)
FROM table_name
GROUP BY column1
HAVING condition;

```

## EJEMPLO - Agrupación de datos
:::info Ejemplo para agrupación de datos
**Realiza las siguientes consultas SQL sobre la tabla dinosaurios utilizando las cláusulas `GROUP BY` y `HAVING`.**

**Apartados:**
**1. Agrupar los dinosaurios por tipo de alimentación y contar cuántos dinosaurios pertenecen a cada tipo.**
* Usa la cláusula `GROUP BY` para agrupar los dinosaurios según el campo `alimentacion_id`.

**2. Obtener el peso promedio de los dinosaurios agrupados por tipo de alimentación.**
* Usa `GROUP BY` para agrupar y luego AVG para calcular el promedio del peso en cada grupo

**3. Agrupar los dinosaurios por si son voladores o no, y obtener el peso máximo en cada grupo.**
* Usa `GROUP BY` para agrupar los dinosaurios según la columna volador y calcula el peso máximo con `MAX`.

**4. Filtrar grupos de tipos de alimentación que tengan más de 1 dinosaurio.**
* Usa `HAVING` para filtrar los resultados donde el número de dinosaurios por alimentación sea mayor que 1.

**5. Obtener el peso total de los dinosaurios agrupados por tipo de alimentación, pero solo mostrar los grupos cuyo peso total sea mayor que 50**
* Usa `HAVING` para filtrar los grupos cuyo peso total sea mayor que un valor determinado.
  :::

<details>

  <summary>Haz clic para ver la solución</summary>

**Solución en SQL:**
**1. Agrupar los dinosaurios por tipo de alimentación y contar cuántos dinosaurios pertenecen a cada tipo.**
  ```sql
SELECT alimentacion_id, COUNT(*) AS total_dinosaurios
FROM dinosaurios
GROUP BY alimentacion_id;
  ```

**2. Obtener el peso promedio de los dinosaurios agrupados por tipo de alimentación.**
  ```sql
SELECT alimentacion_id, AVG(peso) AS peso_promedio
FROM dinosaurios
GROUP BY alimentacion_id;
  ```

**3. Agrupar los dinosaurios por si son voladores o no, y obtener el peso máximo en cada grupo.**
  ```sql
SELECT volador, MAX(peso) AS peso_maximo
FROM dinosaurios
GROUP BY volador;
  ```
_Este comando agrupa los dinosaurios en función de si son voladores (`volador = true`) o no (`volador = false`) y luego obtiene el peso máximo en cada grupo._

**4. Filtrar grupos de tipos de alimentación que tengan más de 1 dinosaurio.**
  ```sql
SELECT alimentacion_id, COUNT(*) AS total_dinosaurios
FROM dinosaurios
GROUP BY alimentacion_id
HAVING COUNT(*) > 1;
  ```

**5.  Obtener el peso total de los dinosaurios agrupados por tipo de alimentación, pero solo mostrar los grupos cuyo peso total sea mayor que 50.**
  ```sql
SELECT alimentacion_id, SUM(peso) AS peso_total
FROM dinosaurios
GROUP BY alimentacion_id
HAVING SUM(peso) > 50;
  ```

</details>

## CONSULTAS VARIAS TABLAS
### `JOIN`
Combina filas de dos o más tablas basado en una condición de relación.
#### `INNER JOIN:` Devuelve solo las filas que tienen coincidencias en ambas tablas.
```postgresql
SELECT columns 
FROM table1 
INNER JOIN table2 
ON table1.column = table2.column;
```
Ejemplo:
```postgresql
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.id;

```


## EJEMPLO - Consultas `INNER JOIN`
:::info Ejemplo para agrupación de datos
**Realiza las siguientes consultas SQL sobre la tabla dinosaurios y alimentación utilizando la cláusula `INNER JOIN`.**

**Apartados:**
**1. Obtener los nombres de los dinosaurios y su tipo de alimentación**
* Usa `INNER JOIN` para combinar los datos de las dos tablas y mostrar los nombres de los dinosaurios junto con su tipo de alimentación.

**2. Obtener los nombres de los dinosaurios que sean carnívoros.**
* Utiliza `INNER JOIN` y filtra solo los dinosaurios cuyo tipo de alimentación sea "Carnívoro".

**3. Obtener el peso total de los dinosaurios para cada tipo de alimentación.**
* Utiliza `INNER JOIN` para combinar las tablas y agrupar por tipo de alimentación, calculando el peso total de los dinosaurios de cada tipo.

**4. Obtener el nombre y peso de los dinosaurios que pesan más de 50 kg y su tipo de alimentación.**
* Usa `INNER JOIN` para mostrar el nombre, peso y tipo de alimentación de los dinosaurios cuyo peso sea mayor a 50 kg.

**5. Listar los dinosaurios voladores y su tipo de alimentación.**
* Usa `INNER JOIN` y filtra solo aquellos dinosaurios que sean voladores.
  :::

<details>

  <summary>Haz clic para ver la solución</summary>

**Solución en SQL:**
**1. Obtener los nombres de los dinosaurios y su tipo de alimentación.**
  ```sql
SELECT d.nombre, a.alimentacion
FROM dinosaurios d
INNER JOIN alimentacion a ON d.alimentacion_id = a.id;
  ```

**2. Obtener los nombres de los dinosaurios que sean carnívoros.**
  ```sql
SELECT d.nombre
FROM dinosaurios d
INNER JOIN alimentacion a ON d.alimentacion_id = a.id
WHERE a.alimentacion = 'Carnívoro';
  ```

**3. Obtener el peso total de los dinosaurios para cada tipo de alimentación.**
  ```sql
SELECT a.alimentacion, SUM(d.peso) AS peso_total
FROM dinosaurios d
INNER JOIN alimentacion a ON d.alimentacion_id = a.id
GROUP BY a.alimentacion;
  ```

**4. Obtener el nombre y peso de los dinosaurios que pesan más de 50 kg y su tipo de alimentación.**
  ```sql
SELECT d.nombre, d.peso, a.alimentacion
FROM dinosaurios d
INNER JOIN alimentacion a ON d.alimentacion_id = a.id
WHERE d.peso > 50;
  ```

**5.  Listar los dinosaurios voladores y su tipo de alimentación.**
  ```sql
SELECT d.nombre, a.alimentacion
FROM dinosaurios d
INNER JOIN alimentacion a ON d.alimentacion_id = a.id
WHERE d.volador = true;

  ```

</details>
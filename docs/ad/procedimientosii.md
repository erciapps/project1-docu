---
sidebar_position: 5
---

# FUNCIONES Y PROCEDIMIENTOS ALMACENADOS II
## Ejemplo REGISTRO y LOGIN
El siguiente ejemplo muestra la forma de usar los procedimientos almacenados
para proceder al registro y login de usuarios, con contraseña **hasheada**.

### Tabla de usuarios (Simple)

````sql
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100) UNIQUE,
    passwd VARCHAR(255)  -- Aquí almacenamos la contraseña hasheada
);
````

### Procedimiento REGISTRAR USUARIO

Para poder **hashear** la contraseña, en necesario instalar (habilitar) la extensión
que realiza esa operación: `pgcrypto`   
Es necesario ejecutar la siguiente sentencia por consola:
````sql
-- Asegúrate de que la extensión pgcrypto esté habilitada
CREATE EXTENSION IF NOT EXISTS pgcrypto;
````
El procedimiento almacenado simple es el siguiente:
````sql
CREATE OR REPLACE PROCEDURE registrar_usuario(
    _nombre VARCHAR,
    _correo VARCHAR,
    _passwd VARCHAR
)
AS $$
BEGIN
    INSERT INTO usuarios (nombre, correo, passwd)
    VALUES (
               _nombre,
               _correo,
               crypt(_passwd, gen_salt('bf'))  -- Hasheamos la contraseña con bcrypt
           );
END;
$$ LANGUAGE plpgsql;
````
En el proceso de inserción, la contraseña es hasheada con el algoritmo `bcrypt` usando 
la función `crypt()`, que toma como entrada la contraseña y un "sal" generado con 
`gen_salt('bf')`.   
El "sal" es un valor aleatorio que ayuda a proteger contra ataques de diccionario y rainbow tables.

:::note EJERCICIO 1

A partir del procedimiento facilitado, agrega manejo de excepciones y retorna un boolean para
determinar las siguientes situaciones:
* El usuario fue registrado correctamente. (retornar `true`)
* Contraseña demasiado corta (mínimo 5 caracteres)
  * Podemos usar `length(contraseña_facilitada) < 5` con un condicional (retornar `false`)
* El correo ya existe (elevar excepción).
:::

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION registrar_usuario(
    _nombre VARCHAR,
    _correo VARCHAR,
    _passwd VARCHAR
)
    RETURNS BOOLEAN
AS $$
BEGIN

    IF length(_passwd) < 5 THEN
        RETURN FALSE;
end if;

INSERT INTO usuarios (nombre, correo, passwd)
VALUES (
         _nombre,
         _correo,
         crypt(_passwd, gen_salt('bf'))  -- Hasheamos la contraseña con bcrypt
       );
RETURN TRUE;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'El correo "%" ya existe.', _correo;
END;
$$ LANGUAGE plpgsql;
````

</details>

### Procedimiento LOGIN USUARIO
Para realizar el login de usuario vamos a necesitar el correo y la contraseña.
Las partes más importantes de la función son las siguientes:
* Se intenta obtener la passwd y almacenarla en una variable. Si el correo facilitado no existe salimos del método.
* Comprobar si las constraseñas **HASHEADAS** coinciden, el login es correcto. Caso contrario, el login es incorrecto.
````sql
CREATE OR REPLACE FUNCTION login_usuario(
    _correo VARCHAR,
    _passwd VARCHAR
)
RETURNS BOOLEAN 
AS $$
DECLARE
    v_passwd_almacenada VARCHAR(255);
BEGIN
    -- Recuperamos la passwd almacenada para el usuario con el correo proporcionado
    SELECT passwd INTO v_passwd_almacenada
    FROM usuarios
    WHERE correo = _correo;

    -- Si el correo no existe, el login falla
    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;

    -- Comparamos la passwd proporcionada con la almacenada (utilizando la función crypt)
    IF crypt(_passwd, v_passwd_almacenada) = v_passwd_almacenada THEN
        -- Si las passwd coinciden, el login es correcto
        RETURN TRUE;
    ELSE
        -- Si no coinciden, el login falla
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

````
La función `crypt(_passwd, v_passwd_almacenada)` realiza lo siguiente:

1. **Generación del Hash:** Toma la contraseña en texto plano (`_passwd`) y usa el valor 
de v_passwd_almacenada (el hash almacenado en la base de datos) como "sal" (salt), 
que es un valor aleatorio usado en criptografía para evitar que dos contraseñas 
iguales generen el mismo hash.

2. Uso del Salt Existente: `v_passwd_almacenada` contiene tanto el hash como el salt 
utilizado para la contraseña original. La función `crypt()` toma ese salt y aplica 
el mismo algoritmo de hash para generar un hash de la contraseña ingresada (`_passwd`), 
usando el mismo salt. Esto asegura que, si el usuario ingresó la misma contraseña, 
el hash resultante será idéntico al almacenado.

3. Comparación de Hashes: Al comparar el resultado de `crypt(_passwd, v_passwd_almacenada)` 
con `v_passwd_almacenada`, puedes verificar si la contraseña ingresada coincide con 
la contraseña guardada en la base de datos.

:::note EJERCICIO 2
Modifica el método anterior para permitir realizar el login tanto por nombre de usuario, como email.
:::

<details>

<summary>Haz clic para ver la solución</summary>

````sql
CREATE OR REPLACE FUNCTION login_usuario(
    _login VARCHAR,
    _passwd VARCHAR
)
    RETURNS BOOLEAN
AS $$
DECLARE
    v_passwd_almacenada VARCHAR(255);
BEGIN
    -- Recuperamos la passwd almacenada para el usuario con el correo o nombre proporcionado
    SELECT passwd INTO v_passwd_almacenada
    FROM usuarios
    WHERE correo = _login OR nombre = _login;

    -- Si el nombre o correo no existe, el login falla
    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;

    -- Comparamos la passwd proporcionada con la almacenada (utilizando la función crypt)
    IF crypt(_passwd, v_passwd_almacenada) = v_passwd_almacenada THEN
        -- Si las passwd coinciden, el login es correcto
        RETURN TRUE;
    ELSE
        -- Si no coinciden, el login falla
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
````
</details>


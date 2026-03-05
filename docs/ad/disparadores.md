---
sidebar_position: 6
---

# TRIGGERS Y NOTIFICACIONES
## Introducción a los triggers

Los **disparadores** o **triggers** en bases de datos son procedimientos que se ejecutan automáticamente cuando ocurre un evento específico (como `INSERT`, `UPDATE` o `DELETE`) en una tabla. Son útiles para mantener la integridad de los datos y realizar tareas automáticas, como auditorías, notificaciones o validaciones.

### ¿Por qué usar triggers?
Algunos de los beneficios de usar triggers incluyen:
- **Automatización** de tareas repetitivas, como el registro de cambios en los datos.
- **Validación** automática para evitar datos incorrectos.
- **Notificaciones** de cambios en la base de datos, que pueden enviar alertas o activar procesos adicionales.
- **Mantenimiento** de la integridad de los datos sin depender del código de la aplicación.

## Creación básica de un trigger en PostgreSQL

### Estructura básica de un trigger
En PostgreSQL, un trigger se compone de:
1. Una **función de trigger** que define lo que debe hacer el trigger.
2. La **declaración del trigger**, que especifica cuándo y cómo se debe ejecutar la función.

### Ejemplo de creación de un trigger
En este ejemplo, vamos a crear un trigger que registre en una tabla de auditoría cada vez que se inserte un nuevo registro en la tabla `ventas`.

#### Paso 1: Crear la tabla de ventas y auditoría
Primero, creamos las tablas llamadas `ventas` y `ventas_auditoria` donde registraremos la fecha y el ID de cada venta insertada en `ventas`.

```sql
-- Crear la tabla ventas
CREATE TABLE ventas (
                        id SERIAL PRIMARY KEY,
                        producto VARCHAR(100),
                        cantidad INT
);

-- Algunos ejemplos
INSERT INTO ventas (producto, cantidad, estado)
VALUES ('Smartphone', 1),
       ('Televisor', 2),
       ('Laptop', 1)

-- Crear la tabla de auditoría
CREATE TABLE ventas_auditoria (
                                  auditoria_id SERIAL PRIMARY KEY,
                                  venta_id INT,
                                  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Paso 2: Crear la función del trigger
Creamos la función que se activará cuando ocurra el evento en la tabla `ventas`

````sql
-- Crear la función que se ejecutará cuando se inserte una venta
CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    -- El trigger se asocia con la tabla ventas
    -- Se accede a la tabla 'ventas' de manera implícita a través de NEW
INSERT INTO ventas_auditoria (venta_id)
VALUES (NEW.id);  -- Accede al 'id' de la nueva venta que se está insertando en la tabla 'ventas'

-- Devuelve la fila 'NEW' para continuar con la operación de inserción
RETURN NEW;
END;
$$ LANGUAGE plpgsql;
````

### Paso 3: Crear el trigger
Finalmente, creamos el trigger que ejecutará la función `registrar_auditoria()` después de cada `INSERT` en la tabla `ventas`
````sql
-- Crear el trigger en la tabla ventas
CREATE TRIGGER trigger_registrar_auditoria
AFTER INSERT ON ventas  -- El trigger se ejecutará después de cada inserción en la tabla 'ventas'
FOR EACH ROW  -- Para cada fila insertada
EXECUTE FUNCTION registrar_auditoria();  -- Ejecuta la función 'registrar_auditoria'
````

### Explicación del trigger
1. **`AFTER INSERT ON ventas`**: define que el trigger se ejecuta después de cada inserción en la tabla `ventas`.
2. **`FOR EACH ROW`**: especifica que el trigger se activará para cada fila insertada.
3. **`EXECUTE FUNCTION:`** indica la función que se ejecutará cuando el trigger se dispare.


:::note EJERCICIO 
1. Añade un nuevo campo tipo `TIMESTAMP` con el nombre `last_login` en la tabla `usuarios` creada en el 
partado de **Procedimientos II**. Por defecto ese valor es la hora actual (`DEFAULT CURRENT_TIMESTAMP`)

2. Añade otro campo tipo `VARCHAR(10)`, para almacenar el rol de usuario. Por defecto `user`.

3. Modifica el procedimiento almacenado de login (`login_usuario`), para que en caso de que los datos de acceso sean correctos,
registre la hora del login (`DEFAULT CURRENT_TIMESTAMP` realizado un `UPDATE`).

4. Crea una tabla (`login_auditoria`) para auditar el login de los usuarios con el rol `admin`, que disponga los campos:
    * `auditoria_id` de tipo `INT` autoincremental como clave primaria.
    * `user_id` de tipo  `INT`
    * `fecha` de tipo `TIMESTAMP` y `CURRENT_TIMESTAMP` por defecto.

5. Crea la función del **`trigger`** (`auditar_login`) que se activará cuando ocurra un login, y que debe disponer de los datos
indicados en el punto anterior: insertar id de usuario y fecha.

6. Crea el **`trigger`** que se ejecute despues de cada `UPDATE` en la tabla `login` (cuando se hace el login de usuario,
se actualiza el campo `last_login`) **SIEMPRE Y CUANDO EL USUARIO TENGA UN ROL DE ADMIN**

:::

<details>

<summary>Haz clic para ver la solución</summary>

1. Modificar tabla
````sql
ALTER TABLE usuarios
    ADD COLUMN last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN rol VARCHAR(10) DEFAULT 'user';
````

2. Modificar función para reflejar fecha y hora último login
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
        -- Actualizar campo last_login
        UPDATE usuarios
        SET last_login = CURRENT_TIMESTAMP
        WHERE correo = _login OR nombre = _login;
        RETURN TRUE;
    ELSE
        -- Si no coinciden, el login falla
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
````

3. Crear tabla `login_auditoria`
````sql
CREATE TABLE login_auditoria (
    auditoria_id SERIAL PRIMARY KEY,
    user_id INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
````

3. Crear función para `trigger`
````sql
CREATE OR REPLACE FUNCTION auditar_login()
RETURNS TRIGGER 
AS $$
BEGIN
    -- Verificar si el usuario tiene rol 'admin'
    IF NEW.rol = 'admin' THEN
        -- Insertar un nuevo registro en la tabla login_auditoria
        INSERT INTO login_auditoria (user_id, fecha)
        VALUES (NEW.id, CURRENT_TIMESTAMP);
    END IF;

    -- Devolver el registro actualizado
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

````

4. Crear trigger
````sql
CREATE TRIGGER after_login_update
AFTER UPDATE OF last_login
ON usuarios
FOR EACH ROW
EXECUTE FUNCTION auditar_login();

````
</details>

## Notificaciones (log en archivo de texto).

### 1. Crear la función para la notificación
````sql
-- Crear la función que enviará la notificación
CREATE OR REPLACE FUNCTION notificar_venta()
RETURNS TRIGGER 
AS $$
BEGIN
    -- Enviar una notificación al canal 'ventas_notificaciones'
    PERFORM pg_notify(
        'ventas_notificaciones', -- Canal de la notificación
        'Se ha realizado una operación en la tabla ventas. ID de venta: ' || NEW.id || ', Producto: ' || NEW.producto || ', Cantidad: ' || NEW.cantidad
    );
    RETURN NEW; -- Asegúrate de retornar NEW si es un INSERT o UPDATE
END;
$$ LANGUAGE plpgsql;

````

### 2. Crear el Trigger para la tabla ventas
````sql
-- Crear el trigger que llama a la función 'notificar_venta'
CREATE TRIGGER trigger_notificar_venta
AFTER INSERT OR UPDATE OR DELETE ON ventas
FOR EACH ROW
EXECUTE FUNCTION notificar_venta();
````

### 3. Programa de escucha
Necesitamos un programa que realice las labores de escucha. Entre todas las opciones disponibles, la más sencilla
es utilizar un pequeño script en `python` que se encargue de escuchar cada cierto tiempo si existen notificaciones
en el canal indicado.
Aquí tienes el código que tendrás que adaptar para realizar la escucha:

:::info
DESCARGA LA VERSIÓN PROFESIONAL DEL IDE PYCHARM:
**https://www.jetbrains.com/pycharm/download/?section=windows**   

USA TU LICENCIA DE USUARIO (IGUAL QUE CON INTELLIJ)
:::

````py
# Configuración del túnel SSH usando una clave privada
with SSHTunnelForwarder(
        ("<DIRECCION_DEL_SERVIDOR_SSH>", <PUERTO_DEL_SERVIDOR_SSH>),  # Dirección y puerto del servidor SSH (usuario debe cambiar estos valores)
        ssh_username="<USUARIO_SSH>",  # Usuario SSH (usuario debe cambiar este valor)
        ssh_pkey="<RUTA_DEL_ARCHIVO_ID_RSA>",  # Ruta a tu archivo id_rsa (usuario debe proporcionar la ruta correcta)
        #ssh_key_password="<TU_PASSPHRASE>",  # Passphrase para la clave privada (si la tiene)
        remote_bind_address=("localhost", <PUERTO_REMOTO_POSTGRESQL>),  # Dirección y puerto del servidor PostgreSQL (usuario debe cambiar estos valores)
        local_bind_address=("localhost", 22)  # Puerto local para el túnel (puede cambiarse si es necesario)
) as tunnel:
    print("Túnel SSH establecido con éxito.")  # Imprime un mensaje cuando el túnel SSH esté listo

    # Conexión a la base de datos PostgreSQL a través del túnel SSH
    conexion = psycopg2.connect(
        dbname="<NOMBRE_BASE_DE_DATOS>",  # Nombre de la base de datos (usuario debe proporcionar el nombre correcto)
        user="<USUARIO_BD>",  # Usuario de la base de datos (usuario debe proporcionar el usuario adecuado)
        password="<CONTRASENA_BD>",  # Contraseña de la base de datos (usuario debe proporcionar la contraseña correcta)
        host="localhost",  # Usamos localhost porque estamos trabajando a través del túnel SSH
        port=tunnel.local_bind_port  # Usar el puerto del túnel para la conexión local
    )

    # Establecer el nivel de aislamiento para la conexión
    conexion.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
    cursor = conexion.cursor()

    # Ejecutar un comando SQL para escuchar las notificaciones en el canal 'ventas_notificaciones'
    cursor.execute("LISTEN ventas_notificaciones;")

    print("Escuchando actualizaciones...")  # Indica que está escuchando las notificaciones

    # Abrir el archivo de log de forma manual en modo 'a' (append) para agregar nuevas entradas
    log_file = open('log_actualizaciones.txt', 'a')

    try:
        while True:
            # Esperar notificación de cambios en la base de datos
            if select.select([conexion], [], [], 5) == ([], [], []):
                # Si no hay notificaciones, espera 5 segundos antes de continuar
                print("Esperando notificación...")
            else:
                conexion.poll()  # Verificar si hay nuevas notificaciones
                while conexion.notifies:
                    # Si hay notificaciones, procesarlas
                    notificacion = conexion.notifies.pop(0)
                    print("Notificación recibida:", notificacion.payload)  # Imprime la notificación en la consola

                    # Escribir la notificación en el archivo de log
                    log_file.write(f"Notificación recibida: {notificacion.payload}\n")
                    log_file.flush()  # Asegúrate de que los datos se escriben inmediatamente en el archivo

    except KeyboardInterrupt:
        print("Cerrando la conexión...")  # Si se interrumpe el proceso, imprime este mensaje

    finally:
        # Cerrar el cursor y la conexión de forma segura
        cursor.close()
        conexion.close()
        log_file.close()  # No olvides cerrar el archivo de log
````

:::note EJERCICIO
A partir del ejemplo de ventas, crea un disparador para un nuevo canal de notificaciones (`login_notificaciones`) que refleje el login de 
los usuarios con rol `admin`. Se debe reflejar:
* Nombre de usuario
* Correo
* Fecha login
:::

## Notificaciones por email.
Las notificaciones por email es una herramienta muy interesante para poder ser utilizada en diferentes escenarios
de nuestra aplicación. Para ver su funcionamiento veremos este pequeño ejemplo donde notificaremos a un correo
en concreto, de que se ha realizado un login desde una cuenta de usuario con rol de administrador.

:::danger ⚠️⚠️ CUIDADO ⚠️⚠️⚠️
**PARA REALIZAR ESTE APARTADO ES NECESARIO CREAR UNA NUEVA CUENTA DE GMAIL, NO UTILICES UNA CUENTA DE CORREO PERSONAL!!!**
:::

### Obtener contraseña de aplicación.
* La forma en la cual vamos a enviar emails, es dando autorización a nuestra aplicación de python 
para realizar esa operación en nuestro nombre.
* **MUY IMPORTANTE:** Debemos dispones de una **cuenta de prueba** y nunca usar nuestro correo personal. Usaremos **GMAIL**
* Para obtener una contraseña de aplicación previamente debemos activar la verificación en dos fpasos (2FA) en nuestra cuenta de gmail.   
**Para el 2FA es necesario un teléfono móvil.**   
  https://support.google.com/accounts/answer/185839
* Una vez activado el 2FA, podremos obtener una contraseña de aplicación (seguir instrucciones en clase).


````py
import smtplib
from email.mime.text import MIMEText

def enviar_email(mensaje):
    # Sustituye con tu dirección de correo
    remitente = "<TU_CORREO_EMAIL>"  # Dirección de correo del remitente
    # Sustituye con la dirección de correo del destinatario
    destinatario = "<DESTINATARIO_EMAIL>"  # Dirección de correo del destinatario
    mensaje_email = MIMEText(mensaje)
    mensaje_email["Subject"] = "Notificación de actualización en ordenes"  # Asunto del correo
    mensaje_email["From"] = remitente
    mensaje_email["To"] = destinatario

    # Configuración del servidor SMTP
    try:
        # Usamos Gmail como ejemplo. Cambia si usas otro proveedor
        with smtplib.SMTP("smtp.gmail.com", 587) as servidor:
            servidor.starttls()  # Establecer conexión segura
            # Cambia por tu contraseña de correo o contraseña de aplicación
            servidor.login(remitente, "<CONTRASENA_DE_APLICACION_SIN_ESPACIOS>")  # Contraseña o contraseña de aplicación
            servidor.sendmail(remitente, destinatario, mensaje_email.as_string())
            print("Correo enviado con éxito.")
    except Exception as e:
        print(f"Ocurrió un error al enviar el correo: {e}")
````

Simplemente, añade este método a tu archivo `main.py`, y llamalo cuando ocurra una notificación de la siguiente manera:   
`enviar_email(notificacion.payload)`

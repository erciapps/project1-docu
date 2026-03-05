---
sidebar_position: 3
---

# LOGIN II
## Método para la conexión
* Este código establece una conexión segura a una base de datos PostgreSQL mediante un túnel SSH. Utiliza la librería paramiko para la conexión SSH y psycopg2 para interactuar con la base de datos. Primero, configura y establece la conexión SSH a un servidor remoto mediante una clave privada RSA. Luego, crea un túnel SSH que reenvía el tráfico desde el puerto local al puerto del servidor de base de datos. Finalmente, establece la conexión a PostgreSQL a través de este túnel seguro.
````py title='ddbb.py'
import psycopg2  # Importa la librería psycopg2 para interactuar con PostgreSQL
import paramiko  # Importa la librería paramiko para interactuar con SSH
from sshtunnel import SSHTunnelForwarder  # Importa la clase SSHTunnelForwarder para reenvío de puertos SSH

# Datos de conexión SSH
ssh_host = 'mvs.sytes.net'  # IP del servidor SSH
ssh_port = <TU PUERTO>  # Puerto SSH
ssh_username = 'sshuser'  # Nombre de usuario SSH
ssh_private_key_path = "C:\\TU\\RUTA\\AL\\id_rsa"  # Ruta de la clave privada RSA

# Datos de conexión a la base de datos PostgreSQL
db_host = '127.0.0.1'  # IP del servidor de la base de datos PostgreSQL
db_port = 5432  # Puerto de PostgreSQL
db_username = 'postgres'  # Nombre de usuario de la base de datos PostgreSQL
db_password = '1234'  # Contraseña de la base de datos PostgreSQL
db_name = '<TU BASE DE DATOS>'  # Nombre de la base de datos PostgreSQL

# Función para establecer la conexión SSH y la conexión a la base de datos PostgreSQL
def get_db_connection():
    # Configurar la conexión SSH
    ssh_client = paramiko.SSHClient()  # Crea un objeto de cliente SSH
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())  # Configura la política de manejo de claves faltantes
    ssh_private_key = paramiko.RSAKey.from_private_key_file(ssh_private_key_path)  # Carga la clave privada RSA
    ssh_client.connect(ssh_host, port=ssh_port, username=ssh_username, pkey=ssh_private_key)  # Realiza la conexión SSH

    # Configurar el reenvío de puertos SSH
    tunnel = SSHTunnelForwarder(  # Crea un objeto de reenvío de puertos SSH
        ssh_address=(ssh_host, ssh_port),  # Dirección del servidor SSH
        ssh_username=ssh_username,  # Nombre de usuario SSH
        ssh_pkey=ssh_private_key,  # Clave privada RSA
        remote_bind_address=(db_host, db_port)  # Dirección y puerto remoto a los que reenviar el tráfico
    )
    tunnel.start()  # Inicia el reenvío de puertos SSH

    # Conectar a la base de datos PostgreSQL a través del túnel SSH
    db_connection = psycopg2.connect(  # Establece la conexión a la base de datos PostgreSQL
        user=db_username,  # Nombre de usuario de la base de datos PostgreSQL
        password=db_password,  # Contraseña de la base de datos PostgreSQL
        host=db_host,  # Dirección IP del servidor de la base de datos PostgreSQL
        port=tunnel.local_bind_port,  # Puerto local al que se ha reenviado el tráfico
        database=db_name,  # Nombre de la base de datos PostgreSQL
        client_encoding="utf8"  # Codificación de caracteres
    )

    return db_connection, tunnel  # Retorna la conexión a la base de datos PostgreSQL, y el tunel SSH
````

:::warning POSTGRES
Antes de continuar, debes disponer de al menos una función o procedimiento almacenado en Postgres para realizar el login.
Además de disponer de usuarios en la base de datos.
En nuestro caso usaremos la función `login_usuario`
:::

````py
@app.route('/sign_in', methods=['POST'])
def sign_in():
    # Obtener los datos del formulario
    login = request.form['login']
    passwd = request.form['passwd']

    try:
        # Obtener un cursor de la conexión
        cursor = conexion.cursor()

        # Llamar al procedimiento almacenado 'login_usuario'
        cursor.callproc('login_usuario', (login, passwd))

        # Obtener el valor de retorno del procedimiento (booleano)
        result = cursor.fetchone()  # Debería devolver (True,) o (False,)
        if result and result[0]:
            print("Login exitoso.")
            # Generar un token JWT utilizando el nombre de usuario
            token = 'token de ejemplo' # deberemos usar generate_token(login) pero lo dejamos así de momento

            # Crear la respuesta
            response = make_response(redirect('/login_ok'))  # Redirigir a login_o
            
            # Establecer una cookie en la respuesta con el token JWT
            response.set_cookie('token', token)
            response.set_cookie('userlogin', login)

            # Devolver la respuesta con la cookie establecida
            return response

        else:
            print("Credenciales incorrectas.")
            return render_template('/login_incorrecto_template.html')

    except Exception as e:
        print(f"Error al llamar al procedimiento almacenado: {e}")
        return 'Error al verificar las credenciales.'

    finally:
        cursor.close()

````

Para que esto funcione es necesaria la conexión y el tunel (después lo usaremos). Declara debajo de los `imports` de tu clase `main.py`:
````py
conexion = None
tunnel = None
````

Instancia ambos objetos antes de iniciar la app:
````py
if __name__ == '__main__':
    conexion, tunnel = get_db_connection()  # Establece la conexión antes de iniciar la aplicación
    app.run(debug=True)
````

Se deberá importar el método:
````py
from ddbb import get_db_connection
````

## Login Incorrecto
````html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Error en el inicio de sesión</title>
    <meta http-equiv="refresh" content="3; url=/form_login"> <!-- Redirige después de 3 segundos -->
</head>
<body>
    <h1>¡Error en el inicio de sesión!</h1>
    <p>Las credenciales ingresadas son incorrectas. Serás redirigido al formulario de inicio de sesión en breve.</p>
    <p>Si no eres redirigido automáticamente, haz clic <a href="/form_login">aquí</a>.</p>
</body>
</html>
````

## TOKEN JWT
Los tokens JWT (JSON Web Tokens) se utilizan para autenticar y autorizar usuarios en aplicaciones web y API,
proporcionando un mecanismo seguro y eficiente para transmitir información de forma firmada y cifrada entre el
cliente y el servidor, facilitando la gestión de sesiones de usuario y la implementación de sistemas de autenticación
basados en tokens.

<figure>
  <img src="/2024/redes/img/python/tokenjwt.png" alt="token jwt" width="450" />
</figure>


## Token de acceso
Un token JWT se genera firmando (encriptando) un objeto JSON con una clave secreta. En nuestro caso, vamos a
encriptar el json: `{'userlogin': userlogin}` (puede ser más complejo si se quiere), con una palabra clave que será
almacenada en un archivo privado a nivel de proyecto (jamás debe ser compartido).

### Archivo de variables de entorno `.env`
El primer paso es crear nuestro archivo para almacenar esta palabra clave. El nombre del archivo tiene que
ser `.env`. El contenido del archivo debe ser:
````title='.env'
SECRET_KEY=tu_clave_supersecreta
````
<figure>
  <img src="/2024/redes/img/python/env.png" alt="env" width="150" />
</figure>
No te olvides de establecer una clave segura

### Método para generar token a partir de un nombre de usuario
Para poder hacer uso de la variable de entorno creada en nuestro archivo `.env`, además de usar la librería para generar tokens,
tenemos que importar lo siguiente:
```py
from dotenv import load_dotenv
import os
import jwt
```
Necesitamos instalar los paquetes correspondientes. Pulsamos `control+alt+s`, y nos desplazamos hasta el apartado `Project`
y entramos en `Python Interpreter`. Veremos los paquetes que ya tenemos instalados en el proyecto.
<figure>
  <img src="/2024/redes/img/python/packagesflask1.png" alt="packages flask" width="450" />
</figure>
Pulsamos sobre el botón **+** para instalar las que necesitamos.   

Necesitamos los paquetes:
* **PyJWT**
* **python-dotenv**
<figure>
  <img src="/2024/redes/img/python/packagesflask2.png" alt="packages flask2" width="450" />
</figure>
Los paquetes quedan instalados:
<figure>
  <img src="/2024/redes/img/python/packagesflask3.png" alt="packages flask3" width="450" />
</figure>

Para generar el token usaremos el siguiente método. Como puedes ver lo que hacemos en encriptar el JSON (o diccionario),
con la clave `userlogin` y el valor que le pasemos al método (el nombre de usuario).
```py
# Función para generar token
def generate_token(userlogin):
    # Codifica el token JWT con el nombre de usuario y la clave secreta
    token = jwt.encode({'userlogin': userlogin}, os.getenv('SECRET_KEY'), algorithm='HS512')
    return token
```


### Método para comprobar un token
Para comprobar el token, es decir, verificar la firma del token, y verificar si su contenido se corresponde con lo esperado.
Dado que al encriptar el token añadimos el JSON con el nombre de usuario, cuando lo desencriptamos comprobamos además,
que el nombre de usuario se corresponde con los datos del token. Si el token no ha sido firmado con nuestra clave secreta,
producirá una excepción.

```py
# Función para verificar token
def verify_token(token, userlogin):
    try:
        # Verifica la firma del token JWT utilizando la clave secreta
        decoded_token = jwt.decode(token, os.getenv('SECRET_KEY'), algorithms=['HS512'])

        # Verificar si el nombre de usuario del token coincide con el usuario proporcionado
        if decoded_token['userlogin'] == userlogin:
            return True
    except jwt.ExpiredSignatureError:
        # Manejar el caso en que el token ha expirado
        return None
    except jwt.InvalidTokenError:
        # Manejar el caso en que el token es inválido
        return None

```

:::danger MUY IMPORTANTE
**La información que hemos puesto en el token (`userlogin`), no son datos encriptados, CUALQUIERA PUEDE VER ESA INFORMACIÓN.**

Si lo quieres comprobar entra en https://jwt.io/ y pega tu token.

La línea `decoded_token = jwt.decode(token, os.getenv('SECRET_KEY'), algorithms=['HS512'])` obtiene el nombre de usuario,
pero además, **COMPRUEBA LA FIRMA DEL TOKEN**.

Si el token no ha sido firmado con nuestra `SECRET_KEY`, se producirá una excepción.
:::


## Sign in
Tenemos que modificar levemente nuestro código de inicio de sessión de un usuario. Después de verificar que el
usuario está registrado, y que la contraseña es correcta, llamamos al método que genera el token (pasando el nombre de usuario).

El token se establece en las cookies de la respuesta. Este valor estará disponible en cada petición HTTP que realicemos
desde el cliente al servidor. También guardamos en una cookie el nombre de usuario, que nos será de ayuda a la hora
de verificar el usuario que realiza la petición.
* Quita `token de ejemplo`
```py
token = 'token de ejemplo' # deberemos usar generate_token(login) pero lo dejamos así de momento
```
* Llama al método para generar token
```py
token = generate_token(login)
```

## Acceso a ruta protegida
Para acceder a nuestra ruta protegida será imprescindible utilizar un token válido.
```py
# Ejemplo de una ruta protegida
@app.route('/login_ok')
def login_ok():
    # Obtener el token y el nombre de usuario desde las cookies de la solicitud
    token = request.cookies.get('token')         # Obtener el token JWT de la cookie
    userlogin = request.cookies.get('userlogin') # Obtener el nombre de usuario de la cookie

    # Verificar si el token o el nombre de usuario están ausentes
    if not token or not userlogin:
        # Si faltan el token o el nombre de usuario, renderizar una plantilla de error de token
        return render_template('token_fail.html')

    # Verificar la validez del token
    decoded_token = verify_token(token, userlogin)

    # Verificar si el token es válido
    if decoded_token:
        # Si el token es válido, renderizar la plantilla para la ruta protegida
        return render_template('login_ok_template.html')
    else:
        # Si el token no es válido, renderizar una plantilla de error de token
        return render_template('token_fail.html')

```

Plantilla para indicar que se debe iniciar sesión para acceder
````html title='token_fail.html'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Acceso Requerido</title>
</head>
<body>
    <h1>¡Acceso denegado!</h1>
    <p>Por favor, <a href="/login">inicie sesión nuevamente</a> para continuar.</p>
</body>
</html>

````
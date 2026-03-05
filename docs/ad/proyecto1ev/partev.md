---
sidebar_position: 5
---


# PARTE V - LANZAR SERVICIOS


## Pautas
Las siguientes indicaciones son aplicables tanto para webserver (sistema de autenticación y registro de usuarios),
como para el servicio de lectura de qr (en caso de tener servicios separados).

::::danger
ES OBLIGATORIO LANZAR EL SERVICIO DE `WEBSERVER`, `NOTIFYSERVER` Y EN EL CASO DE TENER QR, `QRSERVER`
::::

::::warning
Si durante el transcurso de las operaciones son necesarios cambios en el código, realizarlos y 
sincronizar con el repositorio github. Ejecutar la sincronización entre servidor y repositorio con el comando `git pull`
::::

### RAMA EN GIT
Antes de empezar crear una rama basada en master, con el nombre de `release`:
<figure>
  <img src="/2025/ad/img/flask/new_branch.png" alt="nueva rama" width="300" />
</figure>

Asegúrate de cambiar a esa rama, para que los cambios no afecten a los cambios locales.

### Anular tunel ssh
Dado que vamos a trabajar en el mismo servidor donde se encuentra la base de datos, no es
necesario establecer ningún tunel.   

Elimina la conexión al tunel, e indica el puerto de la base de datos como `5432`

### Generar archivo requeriments.txt con las dependencias:
Ejecuta el siguiente comando en la consola de Pycharm:
`pip freeze > requirements.txt`

Este archivo contiene una lista de comandos pip que instalan las versiones necesarias de paquetes dependientes para el proyecto.   

Abre el archivo y verifica que el paquete `psycopg2` que es el que se encarga de conectar 
con la base de datos, sea `psycopg2-binary==2.9.10` (sustituye si es necesario por ese paquete)

### Indicar certificado

Sustituye la línea `app.run()` por estas otras:

````py
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)

context.load_cert_chain('/root/home/certs/cerciapps_sytes_net.pem', '/root/home/certs/erciapps.key')

app.run(ssl_context=context, host='0.0.0.0', port=5001, debug=True)
````

Revisa el puerto para cada caso (webserver:5001, camaraqr:5002)

### Subir cambios
Sincroniza los cambios haciendo clic derecho sobre la nueva rama, y seleccionando `push`
<figure>
  <img src="/2025/ad/img/flask/push.png" alt="push" width="300" />
</figure>

### Acceder al servidor
Accede a la consola de tu servidor en `Proxmox`. Para ello lo puedes realizar desde
el servidor linux, e indicando la ip: https://192.168.88.99:8006   
El nombre de usuario es tu identificador `dam`, y la contraseña es el dni con letra mayúscula.
En `Realm` selecciona Proxmox VE   
Si no te permite acceder pulsa las teclas `control+F5`

### Ejecutar comandos para lanzar app
Abre la consola de tu servidor y ejecuta los siguientes comandos de forma ordenada.

#### Actualiza la lista de paquetes disponibles en los repositorios.
````shell
apt update
````

#### Instala las versiones más recientes de los paquetes instalados.
````shell
apt upgrade
````

#### Instala Git, el sistema de control de versiones.
````shell
apt install git
````

#### Instala el módulo para crear entornos virtuales en Python 3.10
````shell
apt install python3.10-venv
````

#### Configura Git para guardar las credenciales de forma permanente en el sistema.
````shell
git config --global credential.helper store
````

::::warning
Necesario crear un token de acceso en github (seguir instrucciones en clase)
::::

#### Clona el repositorio en la rama 'realease' desde GitHub.
````shell
git clone -b release <ruta a tu repositorio github>
````

#### Cambia al directorio del usuario, crea un directorio 'venvs', entra en él y crea un entorno virtual llamado 'webserver_env' (en el caso del servidor web)
````shell
cd
mkdir venvs
cd venvs
python3.10 -m venv webserver_env
````

#### Activa el entorno virtual 'webserver_env'.
````shell
source webserver_env/bin/activate
````

Desplázate a tu directorio donde has clonado el servidor (en este caso webserver)

Instala las dependencias listadas en el archivo 'requirements.txt'
````shell
pip install -r requirements.txt
````

Para probar si funciona el programa ejecutando `python main.py`.   

Entra en la configuración de tu router pfsense, y crea una redirección de tu segundo puerto asignado, a tu máquina al puerto 5001 (en el caso de webserver).   

::::warning
Se debe realizar esta operación tanto para webserver, como qr.
::::


### Crear servicio

#### Crea un archivo de configuración para el servicio en `/etc/systemd/system/`

````shell
sudo nano /etc/systemd/system/webserver.service
````

#### Añade el siguiente contenido al archivo, ajustando los valores según tu configuración:

````shell
[Unit]
Description=Web Server Python App
After=network.target

[Service]
User=root
WorkingDirectory=/root/webserver
ExecStart=/root/venvs/webserver_env/bin/python /root/webserver/app.py
Restart=always
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target

````

::::danger
AJUSTAR A TUS RUTAS Y NECESIDADES
::::

#### Ejecuta los siguientes comandos para recargar la configuración de systemd y habilitar el servicio para que se inicie automáticamente al arrancar el sistema:

````shell
sudo systemctl daemon-reload
sudo systemctl enable webserver.service
````

#### Arranca el servicio por primera vez:
````shell
sudo systemctl start webserver.service
````


#### Verificar el estado del servicio:
````shell
sudo systemctl status webserver.service
````

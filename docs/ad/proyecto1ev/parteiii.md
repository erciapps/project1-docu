---
sidebar_position: 3
---

# PARTE III - REGISTRAR TICKET / BOLETO / ENTRADA
## Antes de empezar

* Es necesario instalar diferentes paquetes y dependencias para poder realizar esta parte del proyecto.
La idea es exprimir lo máximo posible nuestro servidor de base de datos `PostgreSQL` junto con la experiencia
de diseño de un pequeño servidor web desarrollado en `Python`.

* Debes acceder a la base de datos. Para ello debes establecer la conexión de escritorio remoto. 
Este es el contenido del archivo ejecutable para windows. Si es necesario añade esa parte: `-L 5556:192.168.88.81:3389`, 
ya que eso nos permite conectar también al escritorio remoto de Windows (para hacer pruebas en interfaces).
````shell title='conexion_remota.bat'
ssh -i "ruta absoluta al id_rsa" -p 15000 sshuser@mvs.sytes.net -L 5555:127.0.0.1:3389 -L 5050:192.160.50.71:3389
````
- Ejecuta el script, y abre el programa Conexión a Escritorio Remoto (conecta a linux o windows)
- Para Linux Mint (acceso a Pfsense):
  - localhost:5555
- Para Windows (pruebas ejecutables)
  - localhost:5050
- Pon tu identificador de usuario DAM y tu DNI (letras mayúsculas todo junto) como contraseña (**En windows termina en _25**)

* Entra en un navegador y pon la url de acceso a proxmox: https://192.168.88.99:8006
  - Usuario : identificador DAM
  - Contraseña: DNI (letras mayúsculas todo junto)
* Localiza tu servidor y entra en la consola.
* Una vez dentro ejecuta los siguientes comandos:
````shell
sudo apt update
sudo apt upgrade
sudo apt install python3-pip
sudo -u postgres pip3 install pyjwt
sudo apt-get install postgresql-plpython3-14
sudo systemctl restart postgresql
````

## Función para verificar token
La idea igual que en nuestro servidor de Login desarrollado en python, verificar si el token que facilitamos es correcto.
Observa que estamos utilizando código Python en el procedimiento.
Antes de ejecutar lanza la siguiente expresión para indicar a la base de datos que usaremos
`python en el procedimiento`:
````sql
CREATE FUNCTION plpython3u;
````
````sql
create function verify_token(token text) returns text
    language plpython3u
as
$$
import jwt

# La clave secreta para verificar el token (debe estar segura en un entorno real)
secret_key = 'tu_clave_supersecreta'

try:
    # Decodificar el token
    decoded = jwt.decode(token, secret_key, algorithms=["HS512"])
    return f"Token válido para el usuario {decoded['userlogin']}"
except jwt.ExpiredSignatureError:
    return 'El token ha expirado'
except jwt.InvalidTokenError:
    return 'Token inválido'
$$;
````

:::warning CLAVE
`secret_key` debe ser el mismo configurado en el archivo `.env` de tu servidor web.   
Puede que no dispongas de la clave `userlogin` al decodificar, ajusta a tu `json`
::: 

:::info NECESARIO
Actualiza el método anterior para solicitar y comprobar también el usuario al que pertenece el token.
:::

## COMPRA/RESERVA DE TICKETS/ENTRADAS
En el punto 2 del documento facilitado de temáticas, consiste en realizar la compra/reserva de tickets o entradas.
Debemos tener en cuenta lo siguiente:
Crear un procedimiento/función almacenada que efectúe la compra de tickets.   
**CONDICIONES**
* Este procedimiento debe recibir como parámetros (obligatorios), el token y el usuario que realiza la compra.
  - Llamar desde el procedimiento al procedimiento creado al principio de esta parte III (`verify_token`)
* La función debe registrar el siguiente parámetro para la compra de un ticket:
  - Número de ticket/entrada (que servirá de confirmación) con el siguiente formato: **codigo_aleatorio_8_cifras-id_usuario-dia_mes_año**. Por ejemplo:
    - `id_usuario` es **423**
    - Código aleatorio generado **32132134**
    - Fecha: 27 / 10 / 2024
    El código final: **`32132134-423-27102024`**
* La función además, deberá registrar datos como el usuario que ha realizado la compra, precio, fecha y hora, lugar, etc... Es decir, todo lo necesario acorde
a tu base de datos.
* Es necesario manejar excepciones y retornar valores que nos sean útiles para desarrollar la aplicación.

### FORMA DE EFECTUAR LA COMPRA/RESERVA
En la ventana principal de la aplicación (`JFrame`), crea la **interfaz mínima** 
(no es necesario crear un formulario completo) para efectuar la compra de un ticket/entrada.   

**CONDICIONES MÍNIMAS**
- Muestra en varios desplegables (según tu temática y base de datos) los datos básicos para crear un ticket (**definir con el jefe de proyecto**)
- Botón de efectuar la compra:
  - Al pulsar el botón se ejecuta la llamada a la función creada en el paso anterior.
* Resto de campos (si fuera necesario) **definir con el jefe de proyecto**
* Es necesario informar al usuario de las condiciones y excepciones que se produzcan al llamar al método.

### AYUDA PARA LA FUNCIÓN DE CREAR TICKET
Para poder crear el ticket es necesario saber que se necesita, y que operaciones debe realizar la función.   

Veamos el siguiente ejemplo de una base de datos dedicada a obras de teatro:

<figure>
  <img src="/2025/ad/img/flask/teatro.png" alt="teatro" width="300" />
</figure>

Y ahora veamos las partes de la función que se necesitaría:

<figure>
  <img src="/2025/ad/img/flask/teatro_funcion.jpg" alt="teatro funcion" width="300" />
</figure>


## NOTIFICAR POR CORREO AL USUARIO
:::danger
IMPRESCINDIBLE REALIZAR MEDIANTE TRIGGER
:::

Cada vez que se realice la reserva/compra de un ticket, notificar mediante correo electrónico de la operación
realizada, acorde a lo especificado en el documento impreso facilitado (resumen de la compra/reserva)

[//]: # (Por ejemplo:)

[//]: # (  1. Parking privado: Planta, plaza)

[//]: # (  2. Entradas de cine: Película, butaca)

[//]: # (  3. Entrada festival: )

[//]: # (  4. Entradas concierto: )

[//]: # (  5. Parking en supermercado: Planta, plaza)

[//]: # (  6. Tickets para transporte público:)

[//]: # (  7. Tickets de acceso a museos: Museo)

[//]: # (Reservas de hotel)

[//]: # (Órdenes de servicio taller mecánico)

[//]: # (Eventos deportivos)

[//]: # (Entradas para ferias o exposiciones)

[//]: # (Tickets de consulta médica)

[//]: # (Entradas para zoológicos)

[//]: # (Boletos para clases o talleres)

[//]: # (Entradas para obras de teatro)

[//]: # (Pedidos de comida a domicilio)

[//]: # (Entradas actividades turísticas)
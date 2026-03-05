---
sidebar_position: 7
---

# NOTIFICACIONES (FUNCIONES/TRIGGERS)

## NOTIFICACIONES CON JSON
Dado que lo que nos interesa es tratar el flujo de información que enviamos al canal de notificación,
desde nuestro programa en `python` (puede ser otro lenguaje), debemos facilitar el tratamiento de datos.
Para ello una práctica común es proporcionar la información en formato JSON. Este formato nos permite
organizar la información de una manera clara y sencilla.

### NOTIFICAR EN JSON
````sql
PERFORM pg_notify(
    'canal_ejemplo',  -- Canal de la notificación
    json_build_object(  -- Construcción de un objeto JSON
        'campo1', NEW.valor1,  -- Primer campo y su valor
        'campo2', NEW.valor2,  -- Segundo campo y su valor
        'campoX', NEW.valorX,  -- Campo X y su valor (puedes poner los que necesites)
    )::text  -- Convertir el objeto JSON a texto
);
````
:::note NOTA 1
Usamos `json_build_object` por simplificar la forma que usamos para indicar los datos.
En caso de no usar este método, deberemos usar la siguiente expresión.
````sql
PERFORM pg_notify(
    'canal_ejemplo',  -- Canal de la notificación
    '{"campo1": "' || NEW.valor1 || '", ' ||  -- Primer campo y su valor
    '"campo2": "' || NEW.valor2 || '", ' ||  -- Segundo campo y su valor
    '"campoX": "' || NEW.valorX || '"}'  -- Campo X y su valor
);

````
:::

:::info NOTA 2
¿Podemos retornar un json en una función? La respuesta es **SI**
````sql
CREATE OR REPLACE FUNCTION obtener_datos_json()
RETURNS json 
AS $$
BEGIN
    -- Retornar un objeto JSON con algunos valores de ejemplo
    RETURN json_build_object(
        'campo1', 'valor1',
        'campo2', 'valor2',
        'campo3', 'valor3'
    );
END;
$$ LANGUAGE plpgsql;
````
:::

### TRANSFORMAR TEXTO PLANO A JSON CON PYTHON
Cuando recibimos datos desde un canal de notificación en PostgreSQL, 
estos se entregan como texto plano. Para procesarlos adecuadamente en Python, 
necesitamos convertir este texto a un objeto JSON que podamos manipular. 
Para ello, utilizamos la librería `json` de Python (tenemos que importar la librería).

````python
# Convertir el texto plano a JSON
data = json.loads(notificacion.payload)
print("Datos del JSON:", data)  # Imprimir los datos del JSON
````

#### Acceso a los valores del JSON:
Una vez convertido el texto en un objeto JSON, podemos acceder a los valores de cada 
campo utilizando el método `get`:

````python
# Acceder a los valores del JSON
valor_campo1 = data.get('campo1')
valor_campo2 = data.get('campo2')
valor_campoX = data.get('campoX')
````

## USAR PLANTILLAS PARA CORREOS

Para dar un aspecto más profesional a nuestras notificaciones por mail, usaremos la librería
`Jinja2` de `python`, la cual nos permite diseñar a partir de  `PLANTILLAS` emails personalizados
con los datos obtenidos del canal de comunicaciones (json).    
#### Crear plantilla.
1. Debemos crear un nuevo directorio a nivel de proyecto, con el nombre de `templates`.
2. Crear nuestra plantilla dentro del directorio `templates` con el nombre `email_template.html`, con el siguiente
código de ejemplo


````html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notificación de Actualización</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #4CAF50;
        }
        p {
            font-size: 16px;
            color: #333;
        }
        .footer {
            font-size: 12px;
            color: #888;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Hola {{ campo1 }}!</h1>
        <p>Se ha realizado una actualización en tu cuenta. A continuación, te detallamos la información:</p>
        <ul>
            <li><strong>Rol:</strong> {{ campo2 }}</li>
            <li><strong>Última actualización:</strong> {{ campoX }}</li>
        </ul>
        <p>Gracias por estar con nosotros.</p>
        <div class="footer">
            <p>Este es un correo automatizado. No respondas a este mensaje.</p>
        </div>
    </div>
</body>
</html>

````
Observa que `{{ campo1 }} {{ campo2 }} {{ campoX }}` serán los valores que deberemos
facilitar a la plantilla.

#### Pasar valores a la plantilla
A continuación se muestra el código necesario que necesitaremos para cargar nuestra plantilla:

````python
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from msilib.schema import Environment
from jinja2 import Environment, FileSystemLoader
````

````python
# Cargar y renderizar la plantilla con Jinja2
    env = Environment(loader=FileSystemLoader('templates'))  # 'templates' es el directorio con tu plantilla HTML
    template = env.get_template('email_template.html')
    html_content = template.render(campo1=data.get('campo1'),
                                   campo2=data.get('campo2'),
                                   campoX=data.get('campoX'))

    mensaje_email = MIMEMultipart()
    # Adjuntar el contenido HTML al mensaje
    mensaje_email.attach(MIMEText(html_content, "html"))
````

Esto implica que debemos eliminar `mensaje_email = MIMEText(mensaje)` de nuestro método anterior


### EJERCICI0 1
Envía un correo de bienvenida a los usuarios que se registran. El correo debe enviarse siempre que un usuario se registre, al correo indicado.
Para ello haz uso de json.
Aplica una plantilla con Python (`jinja2`)


## GENERAR NÚMERO ENTERO ALEATORIO
Generar un número entero aleatorio en el rango de 100000 a 900000 utilizando SQL en PostgreSQL.

````sql
FLOOR(RANDOM() * (900000 - 100000 + 1)) + 100000::INTEGER
````
1. `RANDOM():` Genera un número decimal aleatorio entre 0 (inclusive) y 1 (exclusive).
2. `(900000 - 100000 + 1)`: Define el rango de valores posibles. En este caso, el rango es de 100000 a 900000, es decir, 800001 valores posibles.
3. `FLOOR()`: Convierte el número decimal generado por RANDOM() en un número entero, redondeando hacia abajo.
4. `+ 100000`: Ajusta el número aleatorio para que empiece desde 100000 en lugar de 0.

### EJERCICIO 2
Crea un número aleatorio cuando un usuario se registre. Almacena ese número en una nueva columna de la tabla `usuario` con el nombre `codigo`.
Envía el código al usuario en el correo de bienvenida.

### EJERCICIO 3
Crea un nuevo campo para reflejar el estado del usuario. El usuario por defecto está desactivado. Esto quiere decir que no podrá realizar el login.
Para poder realizar el login, el usuario deberá introducir el código que ha recibido en su correo.


[//]: # (<details>)

[//]: # ()
[//]: # (<summary>Haz clic para ver la solución</summary>)

[//]: # ()
[//]: # (</details>)
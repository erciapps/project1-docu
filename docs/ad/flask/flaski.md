---
sidebar_position: 1
---

# ENTORNO
## CREAR PROYECTO

* Crea un nuevo proyecto en python.
* Una vez creado el proyecto podremos ver algo como lo mostrado en la siguiente imagen:

<figure>
  <img src="/2024/redes/img/python/python1.png" alt="python1" width="500" />
</figure>

1. En el lateral izquierdo se encuentran la estructura del proyecto.
2. Disponemos de diferentes botones para ejecutar y depurar la aplicación (detener la ejecución mediante puntos de interrupción).
3. El programa básico incluye:

   ```python
   from flask import Flask
   ```
   Importar la clase `Flask` del módulo `flask`. La clase `Flask` es la base para crear instancias de aplicaciones Flask.
   ```python
   app = Flask(__name__)
   ```
   Instancia de la aplicación Flask. El argumento `__name__` que se pasa al constructor de clase, hace referencia a la
   palabra `__main__` si el script es ejecutado directamente con `Python`. En el caso de que el script sea importado (este es el caso),
   el valor de `__name__` corresponde al nombre del módulo. En nuestro caso `app`.
   ```python
   @app.route('/')
   ```
   Decorador de ruta. Indica que la función debajo de él manejará las solicitudes HTTP para la ruta principal (raiz).
   ```python
   def hello_world():
    return 'Hello World!'
   ```
   Esta es la función de vista que manejará las solicitudes para la ruta raíz. Cuando un usuario accede a la ruta raíz
   de la aplicación, esta función se ejecutará. En este caso, la función simplemente devuelve la cadena 'Hello World!'.
   ```python
   if __name__ == '__main__':
      app.run()
   ```
   Esta parte del código será ejecutada siempre y cuando el script sea directamente ejecutado por el intérprete Python.
   Cuando se ejecuta un script (`python3.11 app.py`) esta variable tomará el valor '__main__', por lo que ejecutará
   el servidor web. En este caso, no ocurre esto, ya que este script es directamente importado en la ejecución (no entra en este `if`).


## Ejecutar servidor
Para poner a prueba nuestro servidor, pulsaremos sobre el botón verde de "PLAY". Veremos algo parecido:
<figure>
  <img src="/2024/redes/img/python/flaskserver.png" alt="flask server" width="500" />
</figure>
Lo que nos informa la salida es que el servidor se encuentra funcionando en la URL: `http://127.0.0.1:5000`    
* **http://** Protocolo de transferencia de hipertexto (.css, .js, .html, .pdf, json, xml, etc... ), es decir, 
que lo que se transmite "normalmente en servidores web" es una página web completa, pero también puede transportar 
información en formato xml o json que nos puede ser de utilizar para base de datos noSQL.   
* **127.0.0.1** Esta dirección IP ase refiere a la IP que se encuentra en escucha. En este caso se refiere a nuestro propio ordenador.   
* **5000** Es el puerto de "pruebas" de escucha del servidor. En el caso de una página web cuando se encuentra en producción, 
es el puerto 80 para http, y 443 para https.

Al acceder a la ruta desde un navegador web, veremos que simplemente muestra la frase `Hello World!`, que es exactamente lo que hace el método
`hello_word()` en la ruta raiz (`/`).
<figure>
  <img src="/2024/redes/img/python/flaskweb.png" alt="flaskweb" width="500" />
</figure>

## Crear plantilla (template)
Dentro del directorio `templates` crearemos nuestra página web de ejemplo (archivo `html`).   
Pulsamos botón derecho sobre la carpeta `templates/New/HTML File`.
<figure>
  <img src="/2024/redes/img/python/createhtml.png" alt="html" width="500" />
</figure>
Ponemos el nombre que queramos, en nuestro caso, `home`.
<figure>
  <img src="/2024/redes/img/python/homeweb.png" alt="homeweb" width="200" />
</figure>
Nos creará una plantilla por defecto de la estructura de una página web. Incluimos una etiqueta
tipo `h1` con el texto: "ESTA ES MI PÁGINA WEB" (ver siguiente imagen)
<figure>
  <img src="/2024/redes/img/python/homeweb2.png" alt="homeweb2" width="500" />
</figure>
Lanzamos nuestro servidor web:
<figure>
  <img src="/2024/redes/img/python/staticweb.png" alt="statiweb" width="500" />
</figure>
Para acceder a nuestra maravillosa página web, abrimos un navegador e indicamos la ip y puerto.
<figure>
  <img src="/2024/redes/img/python/staticweb2.png" alt="statiweb2" width="500" />
</figure>
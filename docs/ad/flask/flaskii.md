---
sidebar_position: 2
---

# LOGIN I
## PLANTILLA HTML PARA LOGIN
Crea en el directorio `templates` la siguiente plantilla:

````html title='login_template.html'
<!DOCTYPE html> <!-- Declara el tipo de documento HTML5 -->
<html lang="es"> <!-- Define el idioma de la página como español -->
<head>
    <meta charset="UTF-8"> <!-- Define la codificación de caracteres como UTF-8 -->
    <title>Login</title> <!-- Título que aparecerá en la pestaña del navegador -->
</head>
<body>
<!-- Formulario que enviará los datos al servidor usando el método POST -->
<form action="/sign_in" method="POST">
    <!-- Campo para ingresar el correo o nombre de usuario -->
    <label for="email">Correo / Usuario:</label>
    <input type="text" id="email" name="login" required> <!-- Campo de texto, requerido -->
    <br> <!-- Salto de línea -->

    <!-- Campo para ingresar la contraseña -->
    <label for="password">Contraseña:</label>
    <input type="password" id="password" name="passwd" required> <!-- Campo de contraseña, requerido -->
    <br> <!-- Salto de línea -->

    <!-- Botón para enviar el formulario -->
    <button type="submit">Aceptar</button>
</form>
</body>
</html>
````

## END POINT
Añade el siguiente `end point` a tu proyecto para retornar la página web que contiene el formulario.   
Para acceder a esta página web recuerda que el servidor está funcionando en local en el puerto 5000: http://localhost:5000/form_login
````py
@app.route('/form_login')  # Define la ruta para manejar solicitudes GET en '/form_login'
def login():
    # Renderiza la plantilla HTML llamada 'login_template.html' cuando se accede a la ruta '/form_login'
    return render_template('login_template.html')  # Devuelve la plantilla de login para que se muestre en el navegador
````

<figure>
  <img src="/2025/ad/img/flask/formlogin.png" alt="formlogin" width="300" />
</figure>


## MÉTODO PARA REALIZAR LOGIN
* Observa que el formulario de la plantilla destinada a realizar el login, dispone de los siguientes atributos:
`action="/sign_in" method="POST"`. Esto quiere decir que al pulsar el botón aceptar, estamos llamando al `end_point` `sign_in`, usando el 
método http `POST`.
* El siguiente `end point` tiene el nombre `sign_in`, y se accede mediante `POST`, por lo que al pulsar aceptar desde
el formulario, se están enviando las credenciales de acceso tal y como se explica en los comentarios del código.
* Es un método que iremos construyendo a lo largo de esta y posteriores secciones, por lo que de momento su función es
únicamente la de mostrar los datos que hemos enviado para posteriormente redirigir a otro `end_point`.
````py
@app.route('/sign_in', methods=['POST'])  # Define la ruta para el método POST en /sign_in
def sign_in():
    # Obtener los datos del formulario (login y contraseña)
    login = request.form['login']  # Obtiene el valor del campo 'login' (correo o usuario)
    passwd = request.form['passwd']  # Obtiene el valor del campo 'passwd' (contraseña)
    
    # Imprimir el usuario y la contraseña en la consola (para propósitos de depuración)
    print(f'Usuario: {login}')  # Muestra el login (usuario o correo)
    print(f'Contraseña: {passwd}')  # Muestra la contraseña
    
    # Crear una respuesta de redirección a la página '/login_ok'
    response = make_response(redirect('/login_ok'))  # Redirige a la página '/login_ok'
    
    # Establecer una cookie con el token JWT (ejemplo en este caso)
    response.set_cookie('token', 'esto es un token de ejemplo')  # Se establece una cookie llamada 'token'
    
    # Establecer una cookie con el nombre de usuario (ejemplo en este caso)
    response.set_cookie('userlogin', 'el usuario')  # Se establece una cookie llamada 'userlogin'
    
    # Devolver la respuesta con las cookies configuradas
    return response  # Retorna la respuesta con las cookies y la redirección
````

<figure>
  <img src="/2025/ad/img/flask/getformlogin.png" alt="getformlogin" width="300" />
</figure>


## PLANTILLA PARA LOGIN CORRECTO
Crea la siguiente plantilla cuyo único cometido es informar al usuario de que el login fue ejecutado de manera correcta.
````html title='login_ok_template.html'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login OK</title>
</head>
<body>
    <h1>¡Inicio de sesión exitoso!</h1>
    <p>Has iniciado sesión correctamente.</p>
</body>
</html>

````

## END POINT LOGIN CORRECTO
````py
@app.route('/login_ok')  # Define la ruta para manejar solicitudes GET en '/login_ok'
def login_ok():
    # Renderiza la plantilla HTML llamada 'login_ok_template.html' cuando se accede a la ruta '/login_ok'
    return render_template('login_ok_template.html')  # Devuelve la plantilla de login_ok para que se muestre al usuario
````

<figure>
  <img src="/2025/ad/img/flask/loginok.png" alt="loginok" width="300" />
</figure>

## OBSERVAR COOKIES
En el navegador pulsamos botón derecho y seleccionamos **Inspeccionar**
<figure>
  <img src="/2025/ad/img/flask/cookies1.png" alt="cookies1" width="300" />
</figure>

Observa que en el apartado de **Cookies** aparecen las cookies creadas con los valores indicados en nuestro servidor
<figure>
  <img src="/2025/ad/img/flask/cookies2.png" alt="cookies2" width="300" />
</figure>
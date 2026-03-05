---
sidebar_position: 2
---

# PARTE II - REGISTRO Y LOGIN (servidor web)

## INCORPORAR SISTEMA WEB AUTENTICACIÓN

El cuadro de diálogo de la aplicación debe incorporar el control de navegación `WebView`, visto en el apartado
de servidor web Flask.   

Recordamos los requisitos mínimos (se irán añadiendo durante las etapas):
- Los usuarios se podrán loguear mediante nombre de usuario o correo
- La cuenta no estará activa hasta ser verificada mediante código enviado por correo.
- El código no es válido pasado un minuto.
- La fecha y ahora del login de los usuarios debe quedar siempre reflejada.
- Existen roles de usuario (admin y user)
- Más de 3 intentos fallidos las cuentas quedarán deshabilitadas.

1. Este navegador web debe mostrar nada más abrir la página web de login. Está página debe incluir
un enlace para una página de registro. El registro debe disponer de todos los campos necesarios para registrar un usuario (ver Parte I).
Al realizarse el registro se enviará un correo con el código de activación.

2. Tal y como se ha indicado, la cuenta no estará activada hasta activarla. Esto quiere decir que
al intentar realizar el login, debe indicar al usuario mediante página web. que la cuenta no está activada.
En esa misma página web informativa, añadir un campo (formulario), con el que indicar el código de activación. 
   - En caso de que el código sea correcto, activar la cuenta y retornar a la página de login. 
   - En caso de que sea incorrecto, mostrar una página indicando que el código no es correcto.

3. Al realizar un login correcto, el programa debe almacenar el token e usuario (clase Session) y cerrar ventana. Muestra
el usuario/correo en `MainFrame`.


[//]: # (Además, vamos a aprovechar para generar una clave privada que nos permita mantener una conexión abierta desde un escenario)

[//]: # (windows. Principalmente, usaremos esta conexión para generar los informes en **Desarrollo de interfaces**)

[//]: # ()
[//]: # (:::danger MUCHO OJO)

[//]: # (Para dar mayor seguridad a la conexión, establecer una palabra clave para el archivo id_rsa_reports.   )

[//]: # (**USA TU DNI**)

[//]: # (:::)

[//]: # ()
[//]: # (Ejecuta los siguientes comandos y crea un archivo `id_rsa_reports` y guárdalo en la misma ubicación del `id_rsa` de tu base)

[//]: # (de datos)

[//]: # (````shell)

[//]: # (su sshuser)

[//]: # (cd ~)

[//]: # (cd ~/.ssh)

[//]: # (ssh-keygen -t rsa -b 2048 -m PEM -f id_rsa_reports)

[//]: # (cat ~/.ssh/id_rsa_reports.pub >> ~/.ssh/authorized_keys)

[//]: # (chmod 700 ~/.ssh)

[//]: # (chmod 600 ~/.ssh/authorized_keys)

[//]: # (cat id_rsa_reports)

[//]: # (exit)

[//]: # (````)

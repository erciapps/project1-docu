---
sidebar_position: 1
---

# PARTE I - Comienzo del proyecto
## Temáticas

<div>
    <iframe src="/2025/ad/pdf/TEMATICAS TICKETS.pdf" width="100%" height="500px" />
</div>

## Diseño de la base de datos
Crea la base de datos acorde a los requisitos del proyecto indicados en el documento PDF disponible
Ten en cuenta el tipo de dato que tiene que almacenar cada tabla, asumiendo que se debe de disponer de datos tipo:
* `VARCHAR`
* `TEXT`
* `DECIMAL`
* `INTEGER`
* `TIMESPAN`
* `BOOLEAN`
* `DATE`
* ...

### GESTION DE USUARIOS (tabla `usuarios`)
:::warning ATENCIÓN
Lo que se expone a continuación hace referencia al **DISEÑO DE LA TABLA `USUARIOS`**, no quiere decir
que tengas que crear las funciones / procedimientos / disparadores en esta etapa del proyecto.
:::
La tabla `usuarios` debe ser capaz de manejar los siguientes escenarios:
* Los usuarios deberán facilitar **al menos** estos datos:
  * Nombre de usuario (único y obligatorio)
  * Correo (único y obligatorio)
  * Contraseña al menos 5 caracteres
  * Teléfono
  * Dirección
* Los usuarios se podrán loguear mediante nombre de usuario o correo
* La cuenta no estará activa hasta ser verificada mediante código enviado por correo.
* El código no es válido pasado un minuto.
* La fecha y ahora del login de los usuarios debe quedar siempre reflejada.
* Existen roles de usuario (admin y user)
* Más de 3 intentos fallidos las cuentas quedarán deshabilitadas.

## Crear proyecto inicial
* Crea la estructura del proyecto y añade los paquetes y dependencias necesarias.
* Reutiliza las clases y métodos empleados en clase.
* Crea la ventana principal (`JFrame`) y añade una ventana de diálogo (`JDialog`) destinada para mostrar el login (servidor web).

## Sincronizar cambios en repositorio de `GitHub`
Cada sesión de trabajo debe ir acompañada de una sincronización con el repositorio de trabajo en GitHub.
---
sidebar_position: 4
---

# PARTE IV - VALIDAR TICKET / BOLETO / ENTRADA
## Antes de empezar
### ¿Quién y como se valida la operación?
#### **¿¿¿Quién???**   
Cuando nosotros creamos un ticket y llega toda la información al correo electrónico (el código muy importante), es con la idea
de presentar ese código para ser validado por otra persona. Por ejemplo, si nuestra aplicación es un hotel, presentaremos
el código de reserva en la hole del hotel, y será validado por la persona encargada de la recepción.   

#### **¿¿¿Cómo validamos???**   
1. Al igual que un usuario se tiene que autenticar en nuestro sistema para poder realizar la compra o reserva de tickets,
la persona encargada de validar, deberá de disponer de los privilegios suficientes para poder manejar los datos del usuario
que está realizando la compra del ticket. Aquí es donde será necesario disponer de un token que disponga de los privilegios
necesarios para realizar esta operación.
2. **¿Qué tecnología usaremos para validar el ticket?**

:::info
Dependiendo de la dificultad de la tecnología elegida se obtendrá una nota u otra.
:::
   * **Interfaz gráfica en java swing con llamada a función almacenada (misma aplicación de escritorio):**
     * Loguear con usuario autorizado para realizar esta operación (obtener token y usuario)
     * Mostrar JTextField para capturar valor del código.
     * Enviar código a función almacenada, junto con el token del usuario autorizado.
   * **Intefaz web con Flask (desde cualquier navegador: ordenador, móvil, tablet, etc. ):**
     * Loguear (llamada al `endpoint` que retorna la página de login) con usuario autorizado para realizar esta operación (obtener token y usuario)
     * Crear `endpoint` que retorne un `template` que solicite el código de ticket (es decir, un formulario de un campo).
     * Enviar el código (mediante `POST`) al endpoint que dispone de la función almacenada que validará el código.
     
   
    :::danger
    La siguiente tecnología requiere un nivel de dificultad medio-alto. Compromiso por vuestra parte.
    :::

   * **Interfaz web con Flask para lectura de código QR (desde cualquier navegador: ordenador, móvil, tablet, etc...):**
     * Generar QR y adjuntar en el correo al realizar la compra del ticket.
     * Loguear (llamada al `endpoint` que retorna la página de login) con usuario autorizado para realizar esta operación (obtener token y usuario).
     * Crear `endpoint` que retorne un `template` que solicite el código de ticket mediante el uso de cámara web.
     VER APARTADO ESPECÍFICO PARA REALIZAR ESTA PARTE
     
### NOTIFICACIÓN AL USUARIO
Notificar al usuario/cliente mediante correo electrónico, de que la lectura del código se realizó con éxito.

:::danger
IMPRESCINDIBLE REALIZAR MEDIANTE TRIGGER
:::


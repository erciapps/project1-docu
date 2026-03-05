---
sidebar_position: 8
---

# QR

## Dependencias necesarias (Servidor correos)
````py
import qrcode #qr-code
from PIL import Image #PILLOW
import io
import base64
````


## Función para generar QR en Python
````py
def generar_qr_base64(data):
    # Generar la imagen QR
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)

    img = qr.make_image(fill='black', back_color='white')

    # Guardar la imagen en un buffer y convertirla a base64
    buffer = io.BytesIO()
    img.save(buffer, format='PNG')
    qr_image_base64 = base64.b64encode(buffer.getvalue()).decode()

    return qr_image_base64
````

## Añadir QR en el correo electrónico
Añadir después de `mensaje_email["To"] = destinatario`   
No te olvides de pasar el código para generar el qr
````py
qr_base64 = generar_qr_base64("prueba qr") # Pasar aqui el codigo para convertirlo imagen qr
    # Incrustar el QR como una imagen inline
    img_data = base64.b64decode(qr_base64)
    image = MIMEImage(img_data, name="qr_code.png")
    image.add_header('Content-ID', '<qr_code>')  # Usar un ID único para referenciar en el HTML
    mensaje_email.attach(image)
````

## EndPoint para lectura del QR

````py
@app.route('/read_qr')
def read_qr():
    return render_template('read_qr.html')
````

````html title='read_qr.html'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Escanear QR con Flask</title>
</head>
<body>
    <h1>Escanea un Código QR</h1>
    <video id="video" autoplay playsinline></video>
    <canvas id="canvas" hidden></canvas>
    <p id="qrResult">Esperando QR...</p>

    <script src="/static/jsQR.js"></script>
    <script src="/static/script.js"></script>
</body>
</html>
````

## Scripts para el funcionamiento de la cámara (Javascript)
Crear en el directorio `static` del proyecto.
````javascript
const video = document.getElementById('video');
const canvas = document.getElementById('canvas');
const context = canvas.getContext('2d');
const qrResult = document.getElementById('qrResult');

// Función para escanear el QR
function scanQR() {
    if (video.readyState === video.HAVE_ENOUGH_DATA) {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
        const qrCode = jsQR(imageData.data, imageData.width, imageData.height);

        if (qrCode) {
            qrResult.textContent = `QR Detectado: ${qrCode.data}`;
            sendQRData(qrCode.data);
        } else {
            qrResult.textContent = "Buscando QR...";
            requestAnimationFrame(scanQR);
        }
    } else {
        requestAnimationFrame(scanQR);
    }
}

// Función para enviar los datos del QR al servidor
function sendQRData(qrData) {
    fetch('/qr-data', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ qr_data: qrData })
    })
        .then(response => response.json())
        .then(data => {
            if (data.content === "qr_ok") {
                window.location.href = '/qr_ok';
            } else {
                window.location.href = '/qr_fail';
            }
        })
        .catch(err => {
            console.error("Error enviando QR:", err);
        });
}

// Función para iniciar la cámara
function startCamera() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        console.error("getUserMedia no es compatible con este navegador.");
        qrResult.textContent = "Tu navegador no soporta acceso a la cámara.";
        return;
    }

    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
        .then(stream => {
            video.srcObject = stream;
            video.setAttribute("playsinline", true); // Para iOS
            video.play();
            requestAnimationFrame(scanQR);
        })
        .catch(err => {
            console.error("Error al acceder a la cámara:", err.message);
            qrResult.textContent = `Error: ${err.message}. Verifica permisos.`;
        });
}

// Iniciar la cámara al cargar la página
startCamera();
````

En el mismo directorio `static`, crear el archivo `jsQR.js` y pega el contenido de este archivo: https://github.com/cozmo/jsQR/blob/master/dist/jsQR.js
También puedes descargar y poner el archivo en la ruta de proyecto.

## Rutas para el manejo del QR

````py
@app.route('/qr_ok')
def qr_ok():
    return render_template('qr_ok.html')

@app.route('/qr_fail')
def qr_fail():
    return render_template('qr_fail.html')


@app.route('/qr-data', methods=['POST'])
def qr_data():
    if request.is_json:
        qr_content = request.json.get('qr_data')
        print("Contenido del QR:", qr_content)

        # Responder con JSON indicando éxito y redirigir en el cliente
        return jsonify({"message": "QR recibido", "content": "qr_fail"})

    else:
        return jsonify({"error": "No se recibió JSON válido"}), 400
````

## Generar certificado autofirmado
Abrir la consola de Pycharm y ejecutar el siguiente comando en la ruta por defecto que te abra:
````shell
openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365
````
Es importante poner en commonName la IP de tu equipo.

## Especificar los certificados al iniciar:
````shell
app.run(ssl_context=('cert.pem', 'key.pem'), host='0.0.0.0', port=5000, debug=True)
````

:::danger OJO
Al ejecutar el servidor web con este certificado, la página web del cliente en Java Swing **DEJA DE FUNCIONAR** (hasta que lo lancemos a producción)   
Formas de solucionar esto:
1. Ejecutar `app.run(host='0.0.0.0', port=5000, debug=True)` para poder ver la página, y con certificados `app.run(ssl_context=('cert.pem', 'key.pem'), host='0.0.0.0', port=5000, debug=True)` si queremos ejecutar la camara.
Es decir, parar el servidor, comentar una línea y descomentar otra.
2. Crear un propio servidor de camara web. Crea un nuevo proyecto y especifíca un nuevo puerto. Recuerda especificar ese nuevo puerto
al llamar al `endpoint`, además del protocolo `https`.   
Por ejemplo, si tu servidor de camara web está en el 5003: **https://tuip:5003/read_qr**
:::

[//]: # (## COMUNICACIÓN ENTRE SERVIDORES WEB)

[//]: # (Si decides utilizar dos servidores web para tu aplicación &#40;autenticación y lectura QR&#41;, necesitarás)

[//]: # (de alguna manera comunicar ambos servicios. Aquí te traigo una solución.)

[//]: # (* Imagina que tienes un servicio en el puerto 5001 y otro en el 5002. 5002 quiere enviar un mensaje)

[//]: # (al 5001. La forma de hacerlo es con `requests`.)

[//]: # ()
[//]: # (* El siguiente ejemplo muestra como el servidor 5002 manda un mensaje a 5001 en su `endpoint` `/api/fetch` mediante)

[//]: # (````py)

[//]: # (response = requests.get&#40;'http://localhost:5001/api/data'&#41;    )

[//]: # (````)

[//]: # (5001 responde con un JSON ` {'message': 'Hello from 5001'}`.   )

[//]: # (5002 recoge la respuesta y la retorna al cliente:)

[//]: # (````py)

[//]: # (return jsonify&#40;{'received': data}&#41;)

[//]: # (````)

[//]: # ()
[//]: # ()
[//]: # (### Ejemplo código servidor 1)

[//]: # (````py)

[//]: # (from flask import Flask, jsonify)

[//]: # ()
[//]: # (app = Flask&#40;__name__&#41;)

[//]: # ()
[//]: # (@app.route&#40;'/api/data', methods=['GET']&#41;)

[//]: # (def get_data&#40;&#41;:)

[//]: # (    data = {'message': 'Hello from 5001'})

[//]: # (    return jsonify&#40;data&#41;)

[//]: # ()
[//]: # (if __name__ == '__main__':)

[//]: # (    app.run&#40;port=5001&#41;)

[//]: # ()
[//]: # (````)

[//]: # ()
[//]: # (### Ejemplo código servidor 2)

[//]: # (````py)

[//]: # (from flask import Flask, jsonify)

[//]: # (import requests)

[//]: # ()
[//]: # (app = Flask&#40;__name__&#41;)

[//]: # ()
[//]: # (@app.route&#40;'/api/fetch', methods=['GET']&#41;)

[//]: # (def fetch_data&#40;&#41;:)

[//]: # (    response = requests.get&#40;'http://localhost:5001/api/data'&#41;)

[//]: # (    if response.status_code == 200:)

[//]: # (        data = response.json&#40;&#41;)

[//]: # (        return jsonify&#40;{'received': data}&#41;)

[//]: # (    else:)

[//]: # (        return jsonify&#40;{'error': 'Failed to fetch data'}&#41;, response.status_code)

[//]: # ()
[//]: # (if __name__ == '__main__':)

[//]: # (    app.run&#40;port=5002&#41;)

[//]: # (````)

[//]: # ()
[//]: # (:::warning)

[//]: # (No te olvides de usar los certificados en uno de los servidores, y de usar https para llamar)

[//]: # (a cualquier `enpoint` de ese servidor.)

[//]: # (:::)

[//]: # ()





[//]: # (## Cambiar y ajustar init_window)

[//]: # ()
[//]: # (Crear en el paquete `utils` de la app de escritorio la siguiente clase:)

[//]: # (````java)

[//]: # (public class SSLUtil {)

[//]: # (    public static void disableCertificateValidation&#40;&#41; {)

[//]: # (        try {)

[//]: # (            // Crea un TrustManager que acepta todos los certificados)

[//]: # (            TrustManager[] trustAllCertificates = new TrustManager[]{)

[//]: # (                    new X509TrustManager&#40;&#41; {)

[//]: # (                        public X509Certificate[] getAcceptedIssuers&#40;&#41; {)

[//]: # (                            return null;)

[//]: # (                        })

[//]: # (                        public void checkClientTrusted&#40;X509Certificate[] certs, String authType&#41; {)

[//]: # (                        })

[//]: # (                        public void checkServerTrusted&#40;X509Certificate[] certs, String authType&#41; {)

[//]: # (                        })

[//]: # (                    })

[//]: # (            };)

[//]: # ()
[//]: # (            // Configura un contexto SSL con el TrustManager)

[//]: # (            SSLContext sc = SSLContext.getInstance&#40;"TLS"&#41;;)

[//]: # (            sc.init&#40;null, trustAllCertificates, new java.security.SecureRandom&#40;&#41;&#41;;)

[//]: # (            HttpsURLConnection.setDefaultSSLSocketFactory&#40;sc.getSocketFactory&#40;&#41;&#41;;)

[//]: # ()
[//]: # (            // Configura el HostnameVerifier para que acepte todos los hostnames)

[//]: # (            HostnameVerifier allHostsValid = &#40;hostname, session&#41; -> true;)

[//]: # (            HttpsURLConnection.setDefaultHostnameVerifier&#40;allHostsValid&#41;;)

[//]: # (        } catch &#40;NoSuchAlgorithmException | KeyManagementException e&#41; {)

[//]: # (            e.printStackTrace&#40;&#41;;)

[//]: # (        })

[//]: # (    })

[//]: # (})

[//]: # ()
[//]: # (````)

[//]: # ()
[//]: # (````java)

[//]: # (public void initWindow&#40;&#41; {)

[//]: # (        setContentPane&#40;mainPanel&#41;;)

[//]: # (        JFXPanel fxPanel = new JFXPanel&#40;&#41;;)

[//]: # (        add&#40;fxPanel, BorderLayout.CENTER&#41;;)

[//]: # (        setSize&#40;400, 500&#41;;)

[//]: # ()
[//]: # (        disableCertificateValidation&#40;&#41;;)

[//]: # ()
[//]: # (        // Ejecutar la carga del WebView en el hilo de JavaFX)

[//]: # (        Platform.runLater&#40;&#40;&#41; -> {)

[//]: # (            // Crear un WebView y WebEngine)

[//]: # (            WebView webView = new WebView&#40;&#41;;)

[//]: # (            WebEngine webEngine = webView.getEngine&#40;&#41;;)

[//]: # ()
[//]: # (            try {)

[//]: # (                // Leer contenido de la URL usando BufferedReader)

[//]: # (                URL url = new URL&#40;"https://127.0.0.1:5000/login"&#41;;)

[//]: # (                HttpsURLConnection connection = &#40;HttpsURLConnection&#41; url.openConnection&#40;&#41;;)

[//]: # (                connection.setRequestMethod&#40;"GET"&#41;;)

[//]: # ()
[//]: # (                BufferedReader in = new BufferedReader&#40;new InputStreamReader&#40;connection.getInputStream&#40;&#41;&#41;&#41;;)

[//]: # (                StringBuilder content = new StringBuilder&#40;&#41;;)

[//]: # (                String inputLine;)

[//]: # (                while &#40;&#40;inputLine = in.readLine&#40;&#41;&#41; != null&#41; {)

[//]: # (                    content.append&#40;inputLine&#41;.append&#40;"\n"&#41;;)

[//]: # (                })

[//]: # (                in.close&#40;&#41;;)

[//]: # ()
[//]: # (                // Cargar el contenido en el WebView &#40;como HTML&#41;)

[//]: # (                String htmlContent = content.toString&#40;&#41;;)

[//]: # ()
[//]: # (                // Asegurarte de que el HTML tenga la referencia al CSS en la etiqueta <head>)

[//]: # (                if &#40;!htmlContent.contains&#40;"<link rel=\"stylesheet\" href=\"/static/css/styles.css\">"&#41;&#41; {)

[//]: # (                    htmlContent = htmlContent.replace&#40;"<head>", "<head><link rel=\"stylesheet\" href=\"https://127.0.0.1:5000/static/css/styles.css\">"&#41;;)

[//]: # (                })

[//]: # ()
[//]: # (                webEngine.loadContent&#40;htmlContent&#41;;)

[//]: # ()
[//]: # (            } catch &#40;Exception e&#41; {)

[//]: # (                e.printStackTrace&#40;&#41;;)

[//]: # (            })

[//]: # ()
[//]: # (            // Establecer la escena en el fxPanel)

[//]: # (            fxPanel.setScene&#40;new Scene&#40;webView&#41;&#41;;)

[//]: # (        }&#41;;)

[//]: # ()
[//]: # (        pack&#40;&#41;;)

[//]: # (    })

[//]: # (````)

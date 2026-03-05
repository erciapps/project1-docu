---
sidebar_position: 4
---

# INCORPORAR LOGIN A APP
En este apartado veremos como añadir un navegador web a nuestra aplicación Swing desarrollada en java, con el propósito
de mostrar nuestro sistema de Login centralizado.   

Nuestro objetivo es conseguir realizar un Login de usuario correcto, para obtener un token de acceso. Este token lo 
usaremos para realizar las peticiones a las **funciones y procedimiento almacenados** en nuestra base de datos.

## Dependencias en Swing
Añade las siguientes dependencias en el proyecto para poder visualizar el navegador web en el programa.
````xml
<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-swing</artifactId>
    <version>22</version>
</dependency>

<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-controls</artifactId>
    <version>22.0.2</version>
</dependency>

<dependency>
    <groupId>org.openjfx</groupId>
    <artifactId>javafx-web</artifactId>
    <version>22.0.2</version>
</dependency>
````

## Método para mostrar navegador web
:::warning
Antes de continuar asegúrate de disponer de un `JDialog` en tu aplicación, de tamaño mínimo 400x500, 
únicamente con `mainPanel` con el layout establecido a `CardLayout`
:::
````java
@Override
public void initWindow() {
    // Establece el panel principal como contenido de la ventana
    setContentPane(mainPanel);

    // Crea un panel JFXPanel, que permite integrar JavaFX en Swing
    JFXPanel fxPanel = new JFXPanel();
    // Añade el fxPanel al centro de la ventana (en el contenedor BorderLayout.CENTER)
    add(fxPanel, BorderLayout.CENTER);

    // Establece el tamaño de la ventana
    setSize(400, 500);

    // Ejecuta el siguiente bloque de código en el hilo de la interfaz de usuario de JavaFX
    Platform.runLater(() -> {
        // Crea un componente WebView, que permite mostrar contenido web
        WebView webView = new WebView();
        // Obtiene el motor que maneja el contenido de la WebView
        WebEngine webEngine = webView.getEngine();

        // Configura un listener que detecta cuando se carga la página en el WebEngine
        webEngine.getLoadWorker().stateProperty().addListener((observable, oldState, newState) -> {
            // Verifica si la carga de la página fue exitosa
            if (newState == javafx.concurrent.Worker.State.SUCCEEDED) {
                // Obtiene la URL actual de la página cargada
                String currentUrl = webEngine.getLocation();

                // Verifica si la URL contiene "login_ok", indicando que el login fue exitoso
                if (currentUrl.contains("login_ok")) {
                    // Obtiene las cookies del navegador mediante JavaScript
                    String cookies = (String) webEngine.executeScript("document.cookie");

                    // Llama a un método para procesar las cookies obtenidas
                    getCookies(cookies);

                    // Muestra un mensaje de éxito del login
                    showLoginSuccessMessage();
                }
            }
        });

        // Carga la página de login en el WebView
        webEngine.load("http://127.0.0.1:5000/form_login");

        // Establece la escena del fxPanel con el WebView para mostrar la página cargada
        fxPanel.setScene(new Scene(webView));
    });

    // Ajusta el tamaño de la ventana según el contenido (si es necesario)
    pack();
}
````

## Método para obtener las Cookies

````java
private void getCookies(String cookies) {
    // Imprime las cookies obtenidas para depuración
    System.out.println("Cookies: " + cookies);

    // Separa las cookies por el delimitador "; " (espacio y punto y coma) para obtener cada cookie individualmente
    String[] cookieArray = cookies.split("; ");

    // Inicializa la variable que almacenará el token
    String token = null;
    // Itera sobre el array de cookies para buscar la cookie que empieza con "token="
    for (String cookie : cookieArray) {
        if (cookie.startsWith("token=")) {
            // Si encuentra el "token", extrae el valor después del "="
            token = cookie.split("=")[1];
            break;  // Sale del bucle después de encontrar el token
        }
    }

    // Inicializa la variable que almacenará el login del usuario
    String userlogin = null;
    // Itera sobre el array de cookies para buscar la cookie que empieza con "userlogin="
    for (String cookie : cookieArray) {
        if (cookie.startsWith("userlogin=")) {
            // Si encuentra el "userlogin", extrae el valor después del "="
            userlogin = cookie.split("=")[1];
            break;  // Sale del bucle después de encontrar el userlogin
        }
    }

    // Establece el nombre de usuario en la sesión usando la clase Session
    Session.setUsername(userlogin);
    // Establece el token en la sesión usando la clase Session
    Session.setToken(token);
}

````

## Método para mostrar Login correcto
````java
private void showLoginSuccessMessage() {
    JOptionPane.showMessageDialog(this, "Login exitoso", "Éxito", JOptionPane.INFORMATION_MESSAGE);
    this.dispose();
}
````

## Clase para almacenar usuario y token

````java
public class Session {
    // Variables estáticas para almacenar el usuario y el token
    private static String username;
    private static String token;
    
    public static void setUsername(String username) {
        Session.username = username;
    }

    public static void setToken(String token) {
        Session.token = token;
    }

    public static String getUsername() {
        return username;
    }

    public static String getToken() {
        return token;
    }

    // Método para verificar si el usuario está autenticado
    public static boolean isAuthenticated() {
        return username != null && token != null;
    }
}
````
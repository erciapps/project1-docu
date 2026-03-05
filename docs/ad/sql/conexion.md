---
sidebar_position: 1
---

# Conexion SQL Java

## Dependencia para la conexión con POSTGRESQL

```xml
<dependency>
      <groupId>org.postgresql</groupId>
      <artifactId>postgresql</artifactId>
      <version>42.7.3</version>
</dependency>
```

## Conexión a base de datos LOCAL

```java title="SQLDatabaseManager.java"
import javax.swing.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLDatabaseManager {

    private static final String DB_HOST = "127.0.0.1";
    private static final int DB_PORT = 5432;
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "admin";
    private static final String DB_NAME = "postgres";
    /**
     * Establece una conexión a la base de datos PostgreSQL
     *
     * @return Una referencia a la conexión a la base de datos.
     * @throws SQLException Si ocurre un error durante la conexión.
     */
    public static Connection connect() throws SQLException {


        try {
            // Establecer la conexión a la base de datos PostgreSQL
            String jdbcUrl = "jdbc:postgresql://localhost:" + DB_PORT + "/" + DB_NAME;
            Connection connection = DriverManager.getConnection(jdbcUrl, DB_USER, DB_PASSWORD);

            if (connection == null) {
                System.out.println("No se pudo conectar a la base de datos PostgreSQL. Asegúrate de que la URL y las credenciales sean correctas.");
            }
            return connection;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Error al conectar con la base de datos PostgreSQL.");
        }
    }

    /**
     * Cierra la conexión a la base de datos PostgreSQL y la sesión SSH.
     *
     * @param connection La conexión que se debe cerrar.
     * @throws SQLException Si ocurre un error durante la desconexión.
     */
    public static void disconnect(Connection connection) throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }

    // Método para comprobar la conexión
    public static boolean checkConnection() {
        boolean connectedOK = false;
        Connection connection = null;

        while (!connectedOK) {
            try {
                connection = connect(); // Conectar a la base de datos
                if (connection != null && !connection.isClosed()) {
                    connectedOK = true;  // Si la conexión es exitosa
                }
            } catch (SQLException e) {
                int result = JOptionPane.showConfirmDialog(null,
                        "No se pudo conectar, ¿Reintentar conexión?",
                        "Error conexión", JOptionPane.YES_NO_OPTION);
                if (result != JOptionPane.YES_OPTION) {
                    break; // Salir si el usuario no quiere reintentar
                }
            } finally {
                if (connectedOK && connection != null) {
                    disconnect(connection); // Cerrar la conexión solo si fue exitosa
                }
            }
        }
        return connectedOK;
    }

}


```


## Conexión a base de datos REMOTO

### Dependencia para la conexión SSH

```xml
<dependency>
    <groupId>com.github.mwiede</groupId>
    <artifactId>jsch</artifactId>
    <version>0.2.19</version>
</dependency>
```

````java
public class SQLDatabaseManager {
    private static final String SSH_HOST = "mvs.sytes.net";
    private static final int SSH_PORT = "PUERTO_SSH";
    private static final String SSH_USER = "USUARIO_SSH";
    private static final String SSH_PASSWD = "PASS SSH";
    private static final String SSH_PRIVATE_KEY = "RUTA AL ID_RSA";
    
    private static final String DB_HOST = "127.0.0.1";
    private static final int DB_PORT = 5432;
    private static final String DB_USER = "postgres";
    private static final String DB_PASSWORD = "1234";
    private static final String DB_NAME = "NOMBRE DE LA BASE DE DATOS";

    private static int localPort; // Puerto local asignado dinámicamente para el reenvío de puertos
    private static Session sshSession; // Sesión SSH para manejar el túnel

    /**
     * Establece una conexión a la base de datos PostgreSQL a través de un túnel SSH.
     *
     * @return Una referencia a la conexión a la base de datos.
     * @throws SQLException Si ocurre un error durante la conexión.
     */
    public static Connection connect() throws SQLException {
        JSch jsch = new JSch();

        try {
            // Agregar clave privada
            jsch.addIdentity(SSH_PRIVATE_KEY);

            // Configuración de la sesión SSH
            sshSession = jsch.getSession(SSH_USER,SSH_HOST, SSH_PORT);
            sshSession.setPassword(SSH_PASSWD);
            Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            //config.put("PreferredAuthentications", "password");
            sshSession.setConfig(config);
            sshSession.connect();

            // Configurar el reenvío de puertos
            localPort = sshSession.setPortForwardingL(0, DB_HOST, DB_PORT);

            // Establecer la conexión a la base de datos PostgreSQL
            String jdbcUrl = "jdbc:postgresql://localhost:" + localPort + "/" + DB_NAME;
            Connection connection = DriverManager.getConnection(jdbcUrl, DB_USER, DB_PASSWORD);

            if (connection == null) {
                System.out.println("No se pudo conectar a la base de datos PostgreSQL. Asegúrate de que la URL y las credenciales sean correctas.");
            }
            return connection;
        } catch (Exception e) {
            e.printStackTrace();
            throw new SQLException("Error al conectar con la base de datos PostgreSQL a través de SSH.");
        }
    }

    /**
     * Cierra la conexión a la base de datos PostgreSQL y la sesión SSH.
     *
     * @param connection La conexión que se debe cerrar.
     * @throws SQLException Si ocurre un error durante la desconexión.
     */
    public static void disconnect(Connection connection) throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
        if (sshSession != null && sshSession.isConnected()) {
            sshSession.disconnect();
        }
    }

    // Método para comprobar la conexión
    public static boolean checkConnection() {
        boolean connectedOK = false;

        while (!connectedOK) {
            try {
                Connection connection = connect();
                if (connection != null && !connection.isClosed()) {
                    connectedOK = true;
                    disconnect(connection);
                }
            } catch (SQLException e) {
                int result = JOptionPane.showConfirmDialog(null,
                        "No se pudo conectar, ¿Reintentar conexión?",
                        "Error conexión", JOptionPane.YES_NO_OPTION);
                if (result != JOptionPane.YES_OPTION) {
                    break;
                }
            }
        }
        return connectedOK;
    }
}
````
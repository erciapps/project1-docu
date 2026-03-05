---
sidebar_position: 2
---

# DAO
El **DAO (Data Access Object)** debe ser inyectado en el controlador de la vista para mantener una separación clara entre 
la lógica de acceso a los datos y la lógica de la interfaz de usuario. Esto sigue el patrón de diseño 
**MVC (Modelo-Vista-Controlador)**, que organiza el código en capas separadas, facilitando el mantenimiento y la escalabilidad de la aplicación.

**Explicación:**   
En un proyecto MVC, el controlador es responsable de manejar la lógica que conecta la vista (lo que ve el usuario) 
y el modelo (que gestiona los datos). Sin embargo, el controlador no debería manejar directamente las operaciones 
con la base de datos. Aquí es donde entra el DAO, que encapsula el acceso a los datos.   

**¿Por qué inyectar el DAO en el controlador?**
1. **Separación de responsabilidades:** El DAO se encarga exclusivamente de la gestión de la base de datos, mientras 
que el controlador gestiona la interacción entre la vista y el modelo.

2. **Reusabilidad:** Al inyectar el DAO en el controlador, no solo se sigue el principio de separación de capas, 
sino que también se hace más fácil reutilizar el DAO en otros controladores, si es necesario.

3. **Facilita las pruebas unitarias:** Al tener el DAO como dependencia del controlador, es posible usar 
técnicas como la inyección de dependencias para cambiar el DAO por una versión simulada (mock) durante las pruebas, 
lo que facilita la validación del comportamiento del controlador sin acceder a una base de datos real.

## Métodos para la conexión

```java title="DinoDAO.java"
public class DinoDAO {
    private Connection connection;
    private boolean initDBConnection(){
        try {
            connection = SQLDatabaseManager.connect();
            return true;
        } catch (SQLException e) {
            System.err.println("Error al conectar con la base de datos");
        }
        return false;
    }

    private boolean closeDBConnection(){
        try {
            SQLDatabaseManager.disconnect(connection);
            return true;
        } catch (SQLException e) {
            System.err.println("Error al desconectar con la base de datos");
        }
        return false;
    }
    
}
```

## Método para Insertar Datos en una Base de Datos
El propósito de este método es agregar un nuevo registro en una tabla de la base de datos. A continuación se explica 
su funcionamiento paso a paso:

1. **Conexión a la base de datos:** El primer paso es asegurarse de que la aplicación esté conectada correctamente a 
la base de datos. Esto se realiza con un método auxiliar que establece la conexión. Si la conexión falla, 
se lanza una excepción que indica el problema.

2. **Preparación de la consulta SQL:** Si la conexión es exitosa, se prepara una consulta SQL para insertar los datos. 
La consulta tiene parámetros ?, que luego se reemplazan con los valores que queremos insertar.

3. **Asignación de valores a la consulta:** A través de un objeto `PreparedStatement`, se rellenan los valores de la 
consulta con los datos proporcionados (como nombre, tipo, valor numérico, etc.). Esto protege contra inyecciones SQL, 
ya que los valores son tratados de forma segura.

4. **Ejecución de la consulta:** Una vez que la consulta está preparada, se ejecuta con el método executeUpdate(). 
Este método devuelve el número de filas afectadas por la consulta. Si se inserta al menos una fila, el método devuelve 
true, lo que indica que la operación fue exitosa.

5. **Manejo de errores:** Si ocurre un error durante la ejecución, el bloque `catch` captura la excepción. 
En particular, si el error se debe a una violación de restricción (como intentar insertar un valor que ya existe 
y debe ser único), se maneja de forma específica.

6. **Cierre de la conexión:** Finalmente, en el bloque `finally`, se cierra la conexión a la base de datos para liberar los recursos.

Vamos a explicar este método para insertar datos en una base de datos con una tabla llamada "estudiantes", y usamos un modelo 
StudentModel con tres atributos: nombre, edad, y fechaIngreso. La lógica del método es similar a la de tu ejemplo anterior, 
pero aplicada a esta situación.

```java
public boolean createStudent(StudentModel student) throws SQLException {
    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        // Intentar insertar el nuevo estudiante
        String insertQuery = "INSERT INTO estudiantes (nombre, edad, fecha_ingreso) VALUES (?, ?, ?)";
        PreparedStatement insertStatement = connection.prepareStatement(insertQuery);

        // Establecemos los valores de cada atributo en la sentencia SQL
        insertStatement.setString(1, student.getNombre());
        insertStatement.setInt(2, student.getEdad());
        insertStatement.setDate(3, java.sql.Date.valueOf(student.getFechaIngreso()));

        // Ejecutamos la inserción y verificamos cuántas filas se han insertado
        int rowsInserted = insertStatement.executeUpdate();
        return rowsInserted > 0; // Retorna true si se insertó al menos una fila

    } catch (SQLException e) {
        throw new SQLException("Error al crear el estudiante", e);
    } finally {
        // Cerramos la conexión a la base de datos
        closeDBConnection();
    }
}

```



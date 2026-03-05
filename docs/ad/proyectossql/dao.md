---
sidebar_position: 1
---

# EVENTOS
### BASE DE DATOS CON DATOS DE EJEMPLO: 
**[⏬⏬ Descargar archivo SQL ⏬⏬](/2025/ad/sql/eventos.sql)**


### ENLACE A GITHUB
**[🔗 Proyecto eventos](https://github.com/profe-dam2/eventsApp.git)**


<figure>
  <img src="/2025/ad/img/eventos.png" alt="proyectos database" width="600" />
</figure>

## INSERTS
### INSERTAR 1
Registrar un usuario en un evento (tabla registro)

<details>
<summary>Haz clic para ver la solución</summary>

Necesitamos recibir 2 parámetros: `id_evento` e `id_usuario`

```java
public boolean createRegistro(int id_evento, int id_usuario) throws SQLException {
     if(!initDBConnection()){
          throw new SQLException("Error al conectar con la bse de datos");
     }
     try{
          String insertQuery = "INSERT INTO registro (id_evento," +
                  "id_usuario, fecha_registro, hora_registro)\n" +
                  "VALUES (?,?,?,?);";
          PreparedStatement insertStatement =
                  connection.prepareStatement(insertQuery);
          insertStatement.setInt(1, id_evento);
          insertStatement.setInt(2, id_usuario);
          insertStatement.setDate(3, Date.valueOf(LocalDate.now()));
          insertStatement.setTime(4, Time.valueOf(LocalTime.now()));
          int rowsAffected = insertStatement.executeUpdate();
          return rowsAffected > 0;

     }catch (PSQLException e){
          throw new SQLException("Error al crear el registro");

     }finally{
          closeDBConnection();
     }
}
```
</details>


### INSERTAR 2
Añadir varios artistas a un evento.

<details>
<summary>Haz clic para ver la solución</summary>

Necesitamos recibir 2 parámetros: `id_evento` e `ArrayList<Integer>`, es decir
una lista con las ids de los artistas que van a participar.

```java
public boolean addArtistsToEvent(int id_evento, ArrayList<Integer> id_artista_list) throws SQLException {
     if(!initDBConnection()){
          throw new SQLException("Error al conectar con la bse de datos");
     }

     try{
          for(int i = 0; i < id_artista_list.size(); i++){
               String insertQuery = "INSERT INTO eventoartista (id_evento, id_artista)\n" +
                       "VALUES (?,?);";
               PreparedStatement insertStatement =
                       connection.prepareStatement(insertQuery);

               int id_artista = id_artista_list.get(i); // Obtener el id_artista
               insertStatement.setInt(1,id_evento);
               insertStatement.setInt(2,id_artista);
               int rowsAffected = insertStatement.executeUpdate();
          }
          return true;

     }catch (PSQLException e){
          throw new SQLException("Error al crear el evento");

     }finally{
          closeDBConnection();
     }
}
```
</details>


### INSERTAR 3
Crear un evento, junto con una lista de artistas en la misma transacción.
Condiciones:
-	Añadir un botón que ejecute el insert.
-	No se debe de crear un evento si la ID del artista no existe.

:::note Obtener última ID
````java
     // Consulta para insertar en Tabla1
     query1 = "INSERT INTO Tabla1 (columnaA, columnaB) VALUES (?, ?)";
     // Preparar la consulta para obtener las claves generadas
     statement1 = connection.prepareStatement(query1, RETURN_GENERATED_KEYS);
     // Establecer los valores para la inserción
     statement1.setValor(1, valorA);
     statement1.setValor(2, valorB);
     
     // Ejecutar la inserción
     statement1.executeUpdate();
     
     // Obtener la clave generada (por ejemplo, el ID)
     resultSet = statement1.getGeneratedKeys();
     if resultSet.next() then
        idGenerado = resultSet.getInt(1);  // Obtener el ID generado en Tabla1

````
:::

:::note Deshacer cambios en caso de fallo.
````java
try {
    // Desactivar auto-commit para que las operaciones no se guarden automáticamente
    connection.setAutoCommit(false);

    // Primer operación: por ejemplo, insertar datos en una tabla
    PreparedStatement statement1 = connection.prepareStatement("INSERT INTO tabla1 (columna) VALUES (?)");
    statement1.setValor(param1);
    statement1.executeUpdate();

    // Segunda operación: actualizar datos en otra tabla
    PreparedStatement statement2 = connection.prepareStatement("UPDATE tabla2 SET columna = ? WHERE id = ?");
    statement2.setValor(param2);
    statement2.executeUpdate();

    // Confirmar la transacción: todas las operaciones se guardan de forma permanente
    connection.commit();
    
} catch (SQLException e) {
    // Si hay un error, deshacer todas las operaciones
    connection.rollback();
    System.err.println("Error: transacción revertida");

} finally {
    // Cerrar la conexión
    cerrarConexion();
}

````
:::

:::tip
Pasar un `ArrayList<Integer>` con la lista de las id de los usuarios (las que quieras)
:::

<details>
<summary>Haz clic para ver la solución</summary>

````java
public boolean createEventWithArtists(String nombreEvento, String descripcion, int idUbicacion, int capacidad, double precio, Date fechaEvento, ArrayList<Integer> idArtistaList) throws SQLException {
    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    String insertEventQuery = "INSERT INTO evento (nombre_evento, descripcion, id_ubicacion, capacidad, estado, precio, fecha_evento) VALUES (?, ?, ?, ?, TRUE, ?, ?)";
    String insertArtistEventQuery = "INSERT INTO eventoartista (id_evento, id_artista) VALUES (?, ?)";

    try {
        // Desactivar autocommit
        connection.setAutoCommit(false);

        // Insertar evento
        PreparedStatement eventStatement = connection.prepareStatement(insertEventQuery, Statement.RETURN_GENERATED_KEYS);
        eventStatement.setString(1, nombreEvento);
        eventStatement.setString(2, descripcion);
        eventStatement.setInt(3, idUbicacion);
        eventStatement.setInt(4, capacidad);
        eventStatement.setDouble(5, precio);
        eventStatement.setDate(6, new java.sql.Date(fechaEvento.getTime()));
        
        int rowsAffected = eventStatement.executeUpdate();

        // Obtener el ID del evento recién creado
        ResultSet generatedKeys = eventStatement.getGeneratedKeys();
        if (generatedKeys.next()) {
            int idEvento = generatedKeys.getInt(1);

            // Insertar artistas en la tabla eventoartista
            for (int idArtista : idArtistaList) {
                PreparedStatement artistStatement = connection.prepareStatement(insertArtistEventQuery);
                artistStatement.setInt(1, idEvento);
                artistStatement.setInt(2, idArtista);
                artistStatement.executeUpdate();
            }

            // Confirmar la transacción
            connection.commit();
            return true;
        } else {
            // Si no se pudo obtener el ID del evento
            throw new SQLException("No se pudo obtener el ID del evento.");
        }
    } catch (SQLException e) {
        // Rollback si algo falla
        connection.rollback();
        throw new SQLException("Error al crear el evento y artistas: " + e.getMessage());
    } finally {
        closeDBConnection();
    }
    return false;
}

````

</details>

## CONSULTAS
### CONSULTA 1
Cargar tabla de los eventos a los que asistió un usuario, mostrando:
-	ID usuario
-	Nombre evento
-	Descripción
-	Fecha

**Funcionamiento:**
-	Capturar la ID del usuario en un JTextField.
-	Un botón que ejecute la consulta

<details>
<summary>Haz clic para ver la solución</summary>

Necesitamos recibir 1 parámetro: `id` del usuario que queremos localizar

```java
public ArrayList<String[]> getEventsByUserID(int id) throws SQLException {
     ArrayList<String[]> eventList = new ArrayList<>();

     if(!initDBConnection()){
          throw new SQLException("Error al conectar con la bse de datos");
     }

     try {
          String query = "SELECT r.id_usuario, e.nombre_evento, e.descripcion, e.fecha_evento \n" +
                  "FROM registro r\n" +
                  "INNER JOIN evento e\n" +
                  "ON r.id_evento = e.id_evento\n" +
                  "WHERE r.id_usuario = ?;";

          PreparedStatement preparedStatement = connection.prepareStatement(query);
          preparedStatement.setInt(1, id);
          ResultSet resultSet = preparedStatement.executeQuery();
          while(resultSet.next()){
               String[] event = new String[]{String.valueOf(resultSet.getInt("id_usuario")),
                       resultSet.getString("nombre_evento"),
                       resultSet.getString("descripcion"),
                       String.valueOf(resultSet.getDate("fecha_evento"))};

               eventList.add(event);
          }

     }catch (Exception e){
          throw new SQLException("Error al consultar los datos");
     }finally {
          closeDBConnection();
     }

     return eventList;
}
```
</details>



### CONSULTA 2
Capturar en un `JTextField` la ID de un artista, y cargar una tabla de los eventos a los que fue.
**Mostrar:**
-	Nombre artista
-	Nombre evento
-	Fecha evento
-	Nombre del lugar del evento

**Funcionamiento:**
-	Capturar la ID del artista en un JTextField.
-	Un botón que ejecute la consulta


<details>
<summary>Haz clic para ver la solución</summary>

Necesitamos recibir 1 parámetro: `id` del artista al que queremos localizar

```java
public ArrayList<String[]> getArtistEvents(int id_artista) throws SQLException {
     ArrayList<String[]> eventList = new ArrayList<>();

     if(!initDBConnection()){
          throw new SQLException("Error al conectar con la bse de datos");
     }

     try {
          String query = "SELECT a.nombre_artista, e.nombre_evento, e.fecha_evento, u.nombre_lugar\n" +
                  "FROM artista a\n" +
                  "INNER JOIN eventoartista ea\n" +
                  "ON ea.id_artista = a.id_artista\n" +
                  "INNER JOIN evento e\n" +
                  "ON ea.id_evento = e.id_evento\n" +
                  "INNER JOIN ubicacion u\n" +
                  "ON e.id_ubicacion = u.id_ubicacion\n" +
                  "WHERE a.id_artista = ?;";

          PreparedStatement preparedStatement = connection.prepareStatement(query);
          preparedStatement.setInt(1, id_artista);
          ResultSet resultSet = preparedStatement.executeQuery();
          while(resultSet.next()){
               String[] event = new String[]{resultSet.getString("nombre_artista"),
                       resultSet.getString("nombre_evento"),
                       String.valueOf(resultSet.getDate("fecha_evento")),
                       resultSet.getString("nombre_lugar")};

               eventList.add(event);
          }

     }catch (Exception e){
          throw new SQLException("Error al consultar los datos");
     }finally {
          closeDBConnection();
     }

     return eventList;
}
```
</details>


### CONSULTA 3
A partir del género seleccionado en el combo de géneros de artista (Rock latino, Salsa, Pop), carga la tabla indicando:
-	Nombre artista
-	Nombre evento
-	Fecha evento
-	Nombre del lugar del evento

**Funcionamiento:**
- Al cambiar de elemento en el combo, cargar directamente la tabla con los resultados de la consulta.

<details>
<summary>Haz clic para ver la solución</summary>

````java
public ArrayList<String[]> getEventsByArtistGenreId(int idGenero) throws SQLException {
    ArrayList<String[]> eventList = new ArrayList<>();

    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        String query = "SELECT a.nombre_artista, e.nombre_evento, e.fecha_evento, u.nombre_lugar " +
                       "FROM artista a " +
                       "INNER JOIN eventoartista ea ON ea.id_artista = a.id_artista " +
                       "INNER JOIN evento e ON ea.id_evento = e.id_evento " +
                       "INNER JOIN ubicacion u ON e.id_ubicacion = u.id_ubicacion " +
                       "WHERE a.genero_id = ?;"; // Cambia 'genero_id' por el nombre correcto de la columna

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        preparedStatement.setInt(1, idGenero);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        while (resultSet.next()) {
            String[] event = new String[]{
                resultSet.getString("nombre_artista"),
                resultSet.getString("nombre_evento"),
                String.valueOf(resultSet.getDate("fecha_evento")),
                resultSet.getString("nombre_lugar")
            };

            eventList.add(event);
        }

    } catch (Exception e) {
        throw new SQLException("Error al consultar los datos: " + e.getMessage());
    } finally {
        closeDBConnection();
    }

    return eventList;
}
````

</details>

### CONSULTA 4
Carga la tabla indicando:
-	Nombre del evento
-	Fecha evento
-	Organizadores del evento (separados por una ,)
-	Nombre del lugar del evento
     
**Funcionamiento:**
- Crear un botón para cargar directamente la tabla con los resultados de la consulta.

<details>
<summary>Haz clic para ver la solución</summary>

````java
public ArrayList<String[]> getEventDetails() throws SQLException {
    ArrayList<String[]> eventList = new ArrayList<>();

    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        String query = "SELECT e.nombre_evento, e.fecha_evento, " +
                       "string_agg(o.nombre_organizador, ', ') AS organizadores, " +
                       "u.nombre_lugar " +
                       "FROM evento e " +
                       "INNER JOIN organiza oz ON e.id_evento = oz.id_evento " +
                       "INNER JOIN organizador o ON oz.id_organizador = o.id_organizador " +
                       "INNER JOIN ubicacion u ON e.id_ubicacion = u.id_ubicacion " +
                       "GROUP BY e.id_evento, u.nombre_lugar;";

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        while (resultSet.next()) {
            String[] event = new String[]{
                resultSet.getString("nombre_evento"),
                String.valueOf(resultSet.getDate("fecha_evento")),
                resultSet.getString("organizadores"),
                resultSet.getString("nombre_lugar")
            };

            eventList.add(event);
        }

    } catch (Exception e) {
        throw new SQLException("Error al consultar los datos: " + e.getMessage());
    } finally {
        closeDBConnection();
    }

    return eventList;
}
````
</details>

### CONSULTA 5
Carga la tabla indicando:
- Nombre evento
- Tipo de evento (separado por comas)
- Fecha evento
- Lista de artistas (separados por comas)
- Ubicación
- Organizadores (separados por comas)

**Funcionamiento:**
- Crear un botón para cargar directamente la tabla con los resultados de la consulta.

<details>
<summary>Haz clic para ver la solución</summary>

````java
public ArrayList<String[]> getEventFullDetails() throws SQLException {
    ArrayList<String[]> eventList = new ArrayList<>();

    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        String query = "SELECT e.nombre_evento, " +
                       "string_agg(te.descripcion, ', ') AS tipo_evento, " +
                       "e.fecha_evento, " +
                       "string_agg(a.nombre_artista, ', ') AS artistas, " +
                       "u.nombre_lugar, " +
                       "string_agg(o.nombre_organizador, ', ') AS organizadores " +
                       "FROM evento e " +
                       "INNER JOIN eventoTipo et ON e.id_evento = et.id_evento " + 
                       "INNER JOIN tipoEvento te ON et.id_tipo_evento = te.id_tipo_evento " + 
                       "INNER JOIN eventoartista ea ON e.id_evento = ea.id_evento " + 
                       "INNER JOIN artista a ON ea.id_artista = a.id_artista " + 
                       "INNER JOIN ubicacion u ON e.id_ubicacion = u.id_ubicacion " + 
                       "INNER JOIN organiza oz ON e.id_evento = oz.id_evento " +  
                       "INNER JOIN organizador o ON oz.id_organizador = o.id_organizador " + 
                       "GROUP BY e.id_evento, u.nombre_lugar;";

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        while (resultSet.next()) {
            String[] event = new String[]{
                resultSet.getString("nombre_evento"),
                resultSet.getString("tipo_evento"),
                String.valueOf(resultSet.getDate("fecha_evento")),
                resultSet.getString("artistas"),
                resultSet.getString("nombre_lugar"),
                resultSet.getString("organizadores")
            };

            eventList.add(event);
        }

    } catch (Exception e) {
        throw new SQLException("Error al consultar los datos: " + e.getMessage());
    } finally {
        closeDBConnection();
    }

    return eventList;
}
````

</details>

### CONSULTA 6

Aquí dispones de comentarios con palabras malsonantes:
<details>
<summary>Haz clic para ver los inserts</summary>

````sql
INSERT INTO Comentarios (id_evento, id_usuario, comentario)
VALUES
(1, 1, 'Este evento estuvo genial, me encantó!'),
(2, 2, 'No me gustó mucho, el lugar estaba lleno y la organización fue una mierda'),
(3, 3, 'Buen evento, aunque esperaba más artistas'),
(4, 4, 'Un evento muy malo, cabrón el que lo organizó'),
(5, 5, 'La música fue espectacular, me lo pasé muy bien'),
(6, 6, 'La comida fue mala, se quedaron sin opciones vegetarianas, qué put vergüenza'),
(7, 7, 'El lugar era bonito pero el evento fue aburrido'),
(8, 8, 'El organizador fue un BastarDo, todo salió mal'),
(9, 9, 'Todo estuvo excelente, sin duda asistiría de nuevo'),
(10, 10, 'Qué evento tan guarro, todo estaba sucio y mal organizado'),
(11, 11, 'El evento estuvo bien, aunque faltó algo de variedad en la música'),
(12, 12, 'Me encantó el ambiente, muy buena organización'),
(13, 13, 'Un evento decepcionante, no volveré'),
(14, 14, 'El sonido fue pésimo, no escuchaba bien a los artistas'),
(15, 15, 'Excelente evento, muy buena atención y organización'),
(16, 16, 'La comida estuvo rica, pero la música estuvo muy alta'),
(17, 17, 'No sé quién organizó esto, pero qué mierda de evento'),
(18, 18, 'Me lo pasé bien, aunque el lugar estaba muy lleno'),
(19, 19, 'Muy buen evento, todo salió perfecto'),
(20, 20, 'El organizador es un cabrón, no volveré a asistir a sus eventos'),
(21, 1, 'Buen evento, me gustó la música'),
(22, 2, 'No estuvo mal, aunque esperaba más interacción con los artistas'),
(23, 3, 'El evento fue una decepción total, qué puta vergüenza'),
(24, 4, 'Me gustó el evento, pero faltó organización'),
(25, 5, 'El sonido fue malo, apenas escuchaba algo'),
(26, 6, 'Todo estuvo bien organizado, me gustó'),
(27, 7, 'No me lo pasé bien, el ambiente fue malo'),
(28, 8, 'La comida estuvo fatal, un desastre total'),
(29, 9, 'El evento fue muy bueno, todo estuvo excelente'),
(30, 10, 'Organización horrible, qué zorra de evento'),
(31, 11, 'Buena experiencia en general, aunque mejoraría la atención en la entrada'),
(32, 12, 'El lugar estaba muy lleno, pero la música fue excelente'),
(33, 13, 'El organizador no tuvo ni idea, qué Mierda de evento'),
(34, 14, 'Me lo pasé genial, espero que haya más eventos así'),
(35, 15, 'Todo estuvo bien, pero la comida fue una puta mierda'),
(36, 16, 'El evento fue increíble, disfruté de todo el tiempo que estuve ahí'),
(37, 17, 'La música fue muy buena, pero la organización fue horrible'),
(38, 18, 'Qué desastre, todo estuvo mal organizado y la gente era muy grosera'),
(39, 19, 'El evento estuvo regular, no fue lo que esperaba'),
(40, 20, 'Un buen evento, aunque me quedé con ganas de más actividades'),
(41, 1, 'Me encantó la temática del evento, muy original'),
(42, 2, 'No volveré, qué cabrón de organizador, todo estuvo mal hecho'),
(43, 3, 'Excelente ambiente, buena música y la gente estuvo genial'),
(44, 4, 'Muy mal evento, todo estuvo desorganizado y fue un desastre'),
(45, 5, 'Gran evento, la comida estuvo espectacular y la música fue de otro nivel'),
(46, 6, 'La entrada fue muy lenta, pero el evento en sí estuvo bien'),
(47, 7, 'Fue un desastre total, no puedo creer lo mal que salió todo'),
(48, 8, 'La comida estuvo bien, pero la organización del evento fue una puta vergüenza'),
(49, 9, 'Muy buen evento, la atención fue excelente y el lugar estuvo muy bien decorado'),
(50, 10, 'Nunca había asistido a un evento tan mal organizado, qué mierd de organización'),
(51, 11, 'La música fue decente, pero la atención al público dejó mucho que desear'),
(52, 12, 'Todo salió perfecto, espero que haya más eventos como este en el futuro'),
(53, 13, 'No estuvo mal, aunque la organización debería mejorar bastante'),
(54, 14, 'Qué mierda de evento, todo estuvo desorganizado y la gente no paraba de empujar'),
(55, 15, 'Un evento increíble, me lo pasé muy bien y conocí a mucha gente nueva'),
(56, 16, 'El evento fue decepcionante, esperaba mucho más'),
(57, 17, 'Todo estuvo bien, aunque me hubiera gustado que hubiera más comida disponible'),
(58, 18, 'Qué cabrón de organizador, no sabía ni lo que estaba haciendo'),
(59, 19, 'El lugar estuvo genial, pero el evento en sí fue bastante aburrido'),
(60, 20, 'Me encantó la música, los artistas hicieron un gran trabajo'),
(61, 1, 'El evento estuvo bien organizado, aunque faltó algo de ambiente'),
(62, 2, 'Fue un evento guarro, todo estuvo desordenado y la comida fue pésima'),
(63, 3, 'La atención fue muy buena, me lo pasé muy bien'),
(64, 4, 'No fue lo que esperaba, pero la música estuvo bien'),
(65, 5, 'El evento fue un desastre, la organización fue una puta vergüenza'),
(66, 6, 'Un buen evento en general, aunque faltó un poco de dinamismo'),
(67, 7, 'Muy buen evento, la gente fue muy amable y la comida estuvo deliciosa'),
(68, 8, 'Todo estuvo mal, desde el lugar hasta la organización, qué mierda'),
(69, 9, 'Me gustó mucho, la música y la comida estuvieron muy bien'),
(70, 10, 'Nunca más iré a un evento organizado por estos cabrones'),
(71, 11, 'El lugar estuvo bien, pero el evento fue bastante aburrido'),
(72, 12, 'El ambiente fue muy agradable, me encantó la decoración del lugar'),
(73, 13, 'No estuvo mal, pero la organización podría haber sido mejor'),
(74, 14, 'Un evento para olvidar, qué puta vergüenza de organización'),
(75, 15, 'Muy buen evento, la comida y la música estuvieron excelentes'),
(76, 16, 'El evento fue desorganizado, no volveré a asistir'),
(77, 17, 'Todo salió perfecto, la atención fue muy buena y la música espectacular'),
(78, 18, 'Qué cabrON el organizador, no sabía ni lo que hacía'),
(79, 19, 'El evento fue bueno, aunque faltaron algunas actividades'),
(80, 20, 'Finalizando con un evento bien organizado, muy satisfecho.');
````
</details>

Esta es la lista de insultos: `mierda|puta|zorra|bastardo|cabrón|guarra|guarro`

Muestra en una tabla los comentarios malsonantes independientemente de mayúsculas/minúsculas o si falta alguna letra al final (1 o 2):
- ID usuario
- Nombre usuario
- Fecha comentario
- Comentario
- Nombre evento

**Funcionamiento**
- Crear un botón que cargue la tabla.

<details>
<summary>Haz clic para ver la solución con SQL</summary>

````java
public ArrayList<String[]> getOffensiveComments() throws SQLException {
    ArrayList<String[]> offensiveCommentsList = new ArrayList<>();

    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        String query = "SELECT c.id_usuario, " +
                       "u.nombre AS nombre_usuario, " +
                       "c.fecha_comentario, " +
                       "c.comentario, " +
                       "e.nombre_evento " +
                       "FROM Comentarios c " +
                       "INNER JOIN Usuario u ON c.id_usuario = u.id_usuario " +
                       "INNER JOIN Evento e ON c.id_evento = e.id_evento " +
                       "WHERE LOWER(c.comentario) ~ '(mierda|mierd|mier|puta|put|zorra|zorr|bastardo|bastard|cabrón|cabr|guarra|guarr|guarro|guarr)'"; // Uso de expresión regular

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        while (resultSet.next()) {
            String[] comment = new String[]{
                String.valueOf(resultSet.getInt("id_usuario")),
                resultSet.getString("nombre_usuario"),
                String.valueOf(resultSet.getDate("fecha_comentario")),
                resultSet.getString("comentario"),
                resultSet.getString("nombre_evento")
            };

            offensiveCommentsList.add(comment);
        }

    } catch (Exception e) {
        throw new SQLException("Error al consultar los comentarios: " + e.getMessage());
    } finally {
        closeDBConnection();
    }

    return offensiveCommentsList;
}

````

</details>

<details>
<summary>Haz clic para ver la solución con JAVA</summary>

````java
public ArrayList<String[]> getOffensiveComments() throws SQLException {
    ArrayList<String[]> offensiveCommentsList = new ArrayList<>();

    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        String query = "SELECT c.id_usuario, " +
                       "u.nombre AS nombre_usuario, " +
                       "c.fecha_comentario, " +
                       "c.comentario, " +
                       "e.nombre_evento " +
                       "FROM Comentarios c " +
                       "INNER JOIN Usuario u ON c.id_usuario = u.id_usuario " +
                       "INNER JOIN Evento e ON c.id_evento = e.id_evento";

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        while (resultSet.next()) {
            String comentario = resultSet.getString("comentario");
            if (checkWord(comentario)) {
                String[] comment = new String[]{
                    String.valueOf(resultSet.getInt("id_usuario")),
                    resultSet.getString("nombre_usuario"),
                    String.valueOf(resultSet.getDate("fecha_comentario")),
                    comentario,
                    resultSet.getString("nombre_evento")
                };

                offensiveCommentsList.add(comment);
            }
        }

    } catch (Exception e) {
        throw new SQLException("Error al consultar los comentarios: " + e.getMessage());
    } finally {
        closeDBConnection();
    }

    return offensiveCommentsList;
}

// Método para verificar si el comentario contiene palabras malsonantes
private boolean checkWord(String comentario) {
    // Expresión regular que captura las palabras malsonantes y permite letras faltantes
    String pattern = "(mierda|mierd|mier|puta|put|zorra|zorr|bastardo|bastard|cabrón|cabr|guarra|guarr|guarro|guarr)";

    return comentario.toLowerCase().matches(".*" + pattern + ".*");
}


````

</details>

### CONSULTA 6*

Aquí dispones de comentarios con palabras bonitas:
<details>
<summary>Haz clic para ver los inserts</summary>

````sql
INSERT INTO Comentarios (id_evento, id_usuario, comentario)
VALUES
    (1, 1, 'Este evento estuvo genial, me encantó!'),
    (2, 2, 'No me gustó tanto, el lugar estaba lleno y la organización fue terrible'),
    (3, 3, 'Buen evento, aunque esperaba más artIstas'),
    (4, 4, 'Un evento malo, me lo esperaba mejor'),
    (5, 5, 'La música fue magnífica, me lo pasé muy bien'),
    (6, 6, 'La comida no fue buena, faltaron opciones vegetarianas'),
    (7, 7, 'El lugar era bonito, pero el evento fue algo aburrido'),
    (8, 8, 'El organizador fue agradable, aunque pudo mejorar algunas cosas'),
    (9, 9, 'Todo estuvo excelente, asistiría otra vez sin duda'),
    (10, 10, 'Qué evento tan guarro, todo mal organizado'),
    (11, 11, 'El evento estuvo bien, pero faltó algo de variedad en la música'),
    (12, 12, 'Me encantó el ambiente, muy bien organizado'),
    (13, 13, 'Un evento decepcionante, no volveré'),
    (14, 14, 'El sonido fue malo, apenas escuchaba bien a los artistas'),
    (15, 15, 'Excelente evento, muy buena atención y organización'),
    (16, 16, 'La comida estuvo rica, pero la música estuvo muy alta'),
    (17, 17, 'No fue el mejor evento, pero lo pasé bien'),
    (18, 18, 'Me lo pasé bien, aunque el lugar estaba lleno'),
    (19, 19, 'Muy buen evento, todo salió perfecto'),
    (20, 20, 'El organizador fue un caballero, volvería sin pensarlo'),
    (21, 1, 'Buen evento, la música fue bastante buena'),
    (22, 2, 'No estuvo mal, aunque esperaba más interacción con los artistas'),
    (23, 3, 'Un evento decente, esperaba más de la organización'),
    (24, 4, 'Me gustó el evento, pero faltó organización en la entrada'),
    (25, 5, 'El sonido fue malo, apenas escuchaba algo'),
    (26, 6, 'Todo estuvo bien organizado, me gustó'),
    (27, 7, 'No me lo pasé bien, el ambiente fue soso'),
    (28, 8, 'La comida no me gustó, fue un desastre total'),
    (29, 9, 'El evento fue bueno, disfruté mucho'),
    (30, 10, 'Organización mejorable, fue un evento regular'),
    (31, 11, 'Buena experiencia en general, aunque mejoraría la atención en la entrada'),
    (32, 12, 'El lugar estaba muy lleno, pero la música fue excelente'),
    (33, 13, 'El evento fue entretenido, pero la organización no fue buena'),
(34, 14, 'Me lo pasé genial, espero que haya más eventos así'),
(35, 15, 'Todo estuvo bien, pero la comida podría haber sido mejor'),
(36, 16, 'El evento fue excelente, disfruté cada minuto'),
(37, 17, 'La música fue buena, pero la organización falló en algunos detalles'),
(38, 18, 'Qué desastre, todo salió mal desde el principio'),
(39, 19, 'El evento estuvo regular, no fue lo que esperaba'),
(40, 20, 'Un evento bien hecho, aunque faltaron algunas actividades'),
(41, 1, 'Me encantó la temática del evento, fue original y único'),
(42, 2, 'No volveré, la organización no estuvo a la altura'),
(43, 3, 'Excelente ambiente, buena música y gente agradable'),
(44, 4, 'El evento fue desorganizado, no cumplió mis expectativas'),
(45, 5, 'Gran evento, la música y la comida fueron excelentes'),
(46, 6, 'La entrada fue lenta, pero lo demás estuvo bien'),
(47, 7, 'El evento no fue lo mejor, la organización dejó mucho que desear'),
(48, 8, 'La comida estuvo bien, pero esperaba más'),
(49, 9, 'Muy buen evento, la atención fue excelente y el lugar hermoso'),
(50, 10, 'El evento estuvo mal organizado, no volveré'),
(51, 11, 'La música fue decente, aunque la atención pudo ser mejor'),
(52, 12, 'Todo salió perfecto, espero asistir a más eventos así'),
(53, 13, 'No estuvo mal, pero la organización debería mejorar'),
(54, 14, 'Un evento para olvidar, no volveré'),
(55, 15, 'Un evento increíble, me lo pasé muy bien y conocí gente nueva'),
(56, 16, 'El evento fue decente, aunque esperaba mucho más'),
(57, 17, 'Todo estuvo bien, pero esperaba más opciones de comida'),
(58, 18, 'El organizador fue muy atento, aunque no salió todo bien'),
(59, 19, 'El lugar estuvo bien, pero el evento fue algo aburrido'),
(60, 20, 'Me encantó la música, los artistas fueron geniales');
````
</details>

Esta es la lista de palabras bonitas: `espectacular|increíble|espléndido|excelente|perfecto|único|agradable`

Muestra en una tabla los comentarios bonitos independientemente de mayúsculas/minúsculas o si falta alguna letra al final (1 o 2):
- ID usuario
- Nombre usuario
- Fecha comentario
- Comentario
- Nombre evento

**Funcionamiento**
- Crear un botón que cargue la tabla.

<details>

<summary>Haz clic para ver la solución con JAVA</summary>

````java
public ArrayList<String[]> getNiceComments() throws SQLException {
    ArrayList<String[]> niceCommentsList = new ArrayList<>();

    if (!initDBConnection()) {
        throw new SQLException("Error al conectar con la base de datos");
    }

    try {
        String query = "SELECT c.id_usuario, " +
                       "u.nombre AS nombre_usuario, " +
                       "c.fecha_comentario, " +
                       "c.comentario, " +
                       "e.nombre_evento " +
                       "FROM Comentarios c " +
                       "INNER JOIN Usuario u ON c.id_usuario = u.id_usuario " +
                       "INNER JOIN Evento e ON c.id_evento = e.id_evento";

        PreparedStatement preparedStatement = connection.prepareStatement(query);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        while (resultSet.next()) {
            String comentario = resultSet.getString("comentario");
            if (checkNiceWord(comentario)) {
                String[] comment = new String[]{
                    String.valueOf(resultSet.getInt("id_usuario")),
                    resultSet.getString("nombre_usuario"),
                    String.valueOf(resultSet.getDate("fecha_comentario")),
                    comentario,
                    resultSet.getString("nombre_evento")
                };

                niceCommentsList.add(comment);
            }
        }

    } catch (Exception e) {
        throw new SQLException("Error al consultar los comentarios: " + e.getMessage());
    } finally {
        closeDBConnection();
    }

    return niceCommentsList;
}

// Método para verificar si el comentario contiene palabras bonitas
private boolean checkNiceWord(String comentario) {
    // Expresión regular que captura las palabras bonitas y permite letras faltantes
    String pattern = "(espectacular|espectacula|increíble|increibl|espléndido|espléndid|excelente|excelent|perfecto|perfect|único|únic|agradable|agradabl)";
    
    return comentario.toLowerCase().matches(".*" + pattern + ".*");
}


````

</details>

## UPDATES

### UPDATE 1
Actualiza el estado activado / desactivado de un usuario 

**Funcionamiento:**
- Crea un `JTextField` para capturar la id de usuario
- Crea un botón con el texto "CAMBIAR ESTADO", que al ser pulsado:
  - Si el estado está a `true` cambie a `false`.
  - Si el estado está a `false` cambie a `true`.
- Una vez realizada la operación muestra en un `JOptionPane`: (`id_usuario`, `username`, `activo`, `premios`)

<details>

<summary>Haz clic para ver la solución con JAVA</summary>

````java
public ArrayList<String[]> cambiarEstadoUsuario(int idUsuario) throws SQLException {
  ArrayList<String[]> listaUsuarios = new ArrayList<>();

  // Iniciar la conexión a la base de datos
  if (!initDBConnection()) {
    throw new SQLException("Error al conectar con la base de datos");
  }

  try {
    // Obtener el estado actual del usuario
    String selectQuery = "SELECT username, activo FROM Usuario WHERE id_usuario = ?";
    PreparedStatement selectStatement = connection.prepareStatement(selectQuery);
    selectStatement.setInt(1, idUsuario);
    ResultSet resultSet = selectStatement.executeQuery();

    if (resultSet.next()) {
      // Cambiar el estado
      boolean nuevoEstado = !resultSet.getBoolean("activo");

      // Actualizar el estado en la base de datos
      String updateQuery = "UPDATE Usuario SET activo = ? WHERE id_usuario = ?";
      PreparedStatement updateStatement = connection.prepareStatement(updateQuery);
      updateStatement.setBoolean(1, nuevoEstado);
      updateStatement.setInt(2, idUsuario);
      updateStatement.executeUpdate();
    }

    // Obtener la lista actualizada de usuarios
    String listQuery = "SELECT id_usuario, username, activo FROM Usuario";
    PreparedStatement listStatement = connection.prepareStatement(listQuery);
    ResultSet listResultSet = listStatement.executeQuery();

    while (listResultSet.next()) {
      String[] usuarioData = new String[]{
              String.valueOf(listResultSet.getInt("id_usuario")),
              listResultSet.getString("username"),
              String.valueOf(listResultSet.getBoolean("activo"))
      };
      listaUsuarios.add(usuarioData);
    }
  } catch (SQLException e) {
    throw new SQLException("Error al cambiar el estado del usuario: " + e.getMessage());
  } finally {
    closeDBConnection();
  }

  return listaUsuarios; // Retorna la lista de usuarios actualizada
}
````

</details>

### UPDATE 2
A partir de la consulta 6, haz que la palabra malsonante del comentario sea censurada con asteriscos. 
Por ejemplo: "Esto es una mierd" por "Esto es una m***" (3 asteriscos) 

**Funcionamiento:**
- El mismo botón de la consulta 6, realiza la actualización y muestra el resultado en la tabla.


<details>

<summary>Haz clic para ver la solución con JAVA</summary>

````java
private String censurarComentario(String comentario){
  String[] listaInsultos = new String[]{"mierda","mierd","mier","puta","put",
          "zorra","zorr","bastardo", "bastard","cabrón","cabr","guarra",
          "guarr","guarro","guarr"};

  for(String insulto : listaInsultos){
    if(comentario.toLowerCase().matches(".*"+ insulto + ".*")){
      String palabraCensurada = insulto.substring(0, 1) + "***";
      comentario = comentario.toLowerCase().replace(insulto, palabraCensurada);
      break;
    }
  }
  return comentario;
}

public ArrayList<String[]> censurarComentarios() throws SQLException {

  ArrayList<String[]> listaComentarios = new ArrayList<>();

  if(!initDBConnection()){
    throw new SQLException("Error al conectar con la base de datos");
  }

  try{
    String query = "SELECT c.id_comentario, c.comentario\n" +
            "FROM Comentarios c\n" +
            "WHERE LOWER(c.comentario) ~ '(mierda|mierd|mier|puta|put|zorra|zorr|bastardo|bastard|cabrón|cabr|guarra|guarr|guarro|guarr)';";
    PreparedStatement preparedStatement = connection.prepareStatement(query);
    ResultSet resultSet = preparedStatement.executeQuery();
    while(resultSet.next()){
      String comentario = resultSet.getString("comentario");
      int id_comentario = resultSet.getInt("id_comentario");
      String comentarioCensurado = censurarComentario(comentario);
      System.out.println(comentarioCensurado);
      String actualizarComentarioQuery = "UPDATE Comentarios SET comentario = ? WHERE id_comentario = ?";
      PreparedStatement actualizarPreparedStatement = connection.prepareStatement(actualizarComentarioQuery);
      actualizarPreparedStatement.setString(1, comentarioCensurado);
      actualizarPreparedStatement.setInt(2, id_comentario);
      actualizarPreparedStatement.executeUpdate();
    }
    // Obtener los comentarios con el nombre la fecha y el contenido del comentario
    String obtenerComentariosQuery = "SELECT c.comentario, c.fecha_comentario, u.nombre\n" +
            "FROM comentarios c\n" +
            "INNER JOIN usuario u\n" +
            "ON c.id_usuario = u.id_usuario;";
    PreparedStatement obtenerPreparedStatement = connection.prepareStatement(obtenerComentariosQuery);
    ResultSet obtenerResultSet = obtenerPreparedStatement.executeQuery();
    while(obtenerResultSet.next()){
      String[] comentarioArray = new String[]{obtenerResultSet.getString("comentario"),
              String.valueOf(obtenerResultSet.getDate("fecha_comentario")),
              obtenerResultSet.getString("nombre")};
      listaComentarios.add(comentarioArray);
    }

  }catch (Exception e){
    throw new SQLException("Error al censurar los comentarios");

  }finally {
    closeDBConnection();
  }
  return listaComentarios;

}

````

</details>

### UPDATE 3
Añade una nueva columna con el nombre `premios` de tipo caracter, en la tabla usuario
````sql
ALTER TABLE Usuario
ADD COLUMN premios VARCHAR(255);
````
1. A partir de la consulta 6, haz que los usuarios que han puesto **malos comentarios**, reciban el premio ***Mal usuario***
2. A partir de la consulta 6*, haz que los usuarios que han puesto **buenos comentarios**, reciban el premio ***Buen usuario***

**Funcionamiento:**
- Crea un botón que ejecute la actualización, y muestre los datos de usuario en la tabla (`id_usuario`, `username`, `activo`, `premios`)

<details>

<summary>Haz clic para ver la solución MAL USUARIO</summary>

```` java
public ArrayList<String[]> establecerPremioMalComentario() throws SQLException {
      if(!initDBConnection()){
          throw new SQLException("Error al conectar con la base de datos");
      }
      try{
          String obtenerComentarioMalos = "SELECT c.id_usuario, c.comentario\n" +
                  "FROM comentarios c\n" +
                  "INNER JOIN usuario u\n" +
                  "ON c.id_usuario = u.id_usuario\n" +
                  "WHERE comentario LIKE CONCAT('%','***','%');\n";
          PreparedStatement preparedStatement = connection.prepareStatement(obtenerComentarioMalos);
          ResultSet resultSet = preparedStatement.executeQuery();
          while (resultSet.next()){
              String establecerPremioMalComentarioQuery = "UPDATE usuario SET premios = ? WHERE id_usuario = ?";
              int id_usuario = resultSet.getInt("id_usuario");
              PreparedStatement actualizarPreparedStatement = connection.prepareStatement(establecerPremioMalComentarioQuery);
              actualizarPreparedStatement.setString(1, "Mal usuario");
              actualizarPreparedStatement.setInt(2, id_usuario);
              actualizarPreparedStatement.executeUpdate();
          }

      } catch (Exception e) {
          throw new SQLException("Error al establecer mal premio");
      }finally{
          closeDBConnection();
      }
      return getUsuarios();
  }
````

</details>

<details>
<summary>Haz clic para ver la solución BUEN USUARIO</summary>

```` java
  // Método para verificar si el comentario contiene palabras bonitas
  private boolean checkNiceWord(String comentario) {
      String pattern = "(espectacular|espectacula|increíble|increibl|espléndido|espléndid|excelente|excelent|perfecto|perfect|único|únic|agradable|agradabl)";
      return comentario.toLowerCase().matches(".*" + pattern + ".*");
  }
  
public ArrayList<String[]> establecerPremioBuenComentario() throws SQLException {
      if(!initDBConnection()){
          throw new SQLException("Error al conectar con la base de datos");
      }

      try{
          String obtenerBuenosComentariosquery = "SELECT c.id_usuario, c.comentario " +
                                                 "FROM Comentarios c " +
                                                 "INNER JOIN Usuario u ON c.id_usuario = u.id_usuario " +
                                                 "WHERE LOWER(c.comentario) ~ '(espectacular|espectacula|increíble|increibl|espléndido|espléndid|excelente|excelent|perfecto|perfect|único|únic|agradable|agradabl)';";
          PreparedStatement preparedStatement = connection.prepareStatement(obtenerBuenosComentariosquery);
          ResultSet resultSet = preparedStatement.executeQuery();
          while (resultSet.next()){
              String establecerPremioBuenComentarioQuery = "UPDATE usuario SET premios = ? WHERE id_usuario = ?";
              int id_usuario = resultSet.getInt("id_usuario");
              PreparedStatement actualizarPreparedStatement = connection.prepareStatement(establecerPremioBuenComentarioQuery);
              actualizarPreparedStatement.setString(1, "Buen usuario");
              actualizarPreparedStatement.setInt(2, id_usuario);
              actualizarPreparedStatement.executeUpdate();
          }

      } catch (Exception e) {
          throw new SQLException("Error al establecer mal premio");
      }finally{
          closeDBConnection();
      }
      return getUsuarios();
  }
````

</details>


### UPDATE 4
Deshabilita a un usuario en caso de no haber escrito un comentario en 2 meses, excepto si es un buen usuario.

**Funcionamiento:**
- Crea un botón que ejecute la actualización, y muestre los datos de usuario en la tabla (`id_usuario`, `username`, `activo`, `premios`)

<details>
<summary>Haz clic para ver la solución en JAVA</summary>

````java
public ArrayList<String[]> deshabilitarUsuariosInactivos() throws SQLException {
    if (!initDBConnection()) {
      throw new SQLException("Error al conectar con la base de datos");
    }
    
    // Calcular la fecha de corte (2 meses atrás)
    LocalDate cutOffDate = LocalDate.now().minusMonths(2);
    
    String updateQuery = "UPDATE Usuario u " +
            "SET activo = FALSE " +
            "WHERE u.activo = TRUE AND u.id_usuario NOT IN (" +
            "    SELECT DISTINCT c.id_usuario " +
            "    FROM Comentarios c " +
            "    WHERE c.fecha_comentario >= ? " +
            ") AND u.premios <> 'Buen usuario'";
    
    try (PreparedStatement preparedStatement = connection.prepareStatement(updateQuery)) {
      preparedStatement.setDate(1, Date.valueOf(cutOffDate)); // Establecer la fecha de corte
      int rowsUpdated = preparedStatement.executeUpdate();
      System.out.println(rowsUpdated + " usuarios deshabilitados por inactividad.");
    } catch (Exception e) {
      throw new SQLException("Error al deshabilitar usuarios inactivos: " + e.getMessage());
    } finally {
      closeDBConnection();
    }
    return getUsuarios();
}
````


</details>


### UPDATE 4*
- Implementa un método en Java que **DESHABILITE** a los usuarios que no han realizado comentarios desde una fecha
  indicada y **HABILITE** a aquellos que sí lo han hecho, indiferentemente de tener premio.
- Añade un selector de fechas (`DatePicker`).
- Añade un `JCheckBox` que si está marcado, deshabilite/habilite a los usuarios independientemente de sus premios.

**Funcionamiento**
- Añade un nuevo botón con el nombre `UPDATE4_E` para ejecutar la operación.
- Retorna los usuarios para mostrarlos en la tabla.

<details>
<summary>Haz clic para ver la solución</summary>

````java
public ArrayList<String[]> deshabilitarYHabilitarUsuarios(LocalDate fecha, boolean ignorePremio) throws SQLException {
  if (!initDBConnection()) {
    throw new SQLException("Error al conectar con la base de datos");
  }

  String deshabilitarQuery = "UPDATE Usuario u " +
          "SET activo = FALSE " +
          "WHERE u.id_usuario NOT IN (" +
          "    SELECT DISTINCT c.id_usuario " +
          "    FROM Comentarios c " +
          "    WHERE c.fecha_comentario >= ? " +
          ") AND u.premios <> 'Buen usuario';";

  String habilitarQuery = "UPDATE Usuario u " +
          "SET activo = TRUE " +
          "WHERE u.id_usuario IN (" +
          "    SELECT DISTINCT c.id_usuario " +
          "    FROM Comentarios c " +
          "    WHERE c.fecha_comentario >= ? " +
          ") AND u.premios <> 'Buen usuario';";

  if(ignorePremio){
    deshabilitarQuery = "UPDATE Usuario u " +
            "SET activo = FALSE " +
            "WHERE u.id_usuario NOT IN (" +
            "    SELECT DISTINCT c.id_usuario " +
            "    FROM Comentarios c " +
            "    WHERE c.fecha_comentario >= ? );";

    habilitarQuery = "UPDATE Usuario u " +
            "SET activo = TRUE " +
            "WHERE u.id_usuario IN (" +
            "    SELECT DISTINCT c.id_usuario " +
            "    FROM Comentarios c " +
            "    WHERE c.fecha_comentario >= ? );";
  }

  try{
    PreparedStatement habilitarStmt = connection.prepareStatement(habilitarQuery)
    PreparedStatement deshabilitarStmt = connection.prepareStatement(deshabilitarQuery);
    // Asignar la fecha para ambas consultas
    deshabilitarStmt.setDate(1, Date.valueOf(fecha));
    habilitarStmt.setDate(1, Date.valueOf(fecha));

    // Ejecutar la consulta para deshabilitar
    int deshabilitados = deshabilitarStmt.executeUpdate();
    System.out.println(deshabilitados + " usuarios deshabilitados por inactividad.");

    // Ejecutar la consulta para habilitar
    int habilitados = habilitarStmt.executeUpdate();
    System.out.println(habilitados + " usuarios habilitados por actividad.");

  } catch (SQLException e) {
    throw new SQLException("Error al deshabilitar/habilitar usuarios: " + e.getMessage());
  } finally {
    closeDBConnection();
  }

  return getUsuarios();  // Devuelve la lista de usuarios tras las actualizaciones
}
````

</details>


## ELIMINAR

### DELETE 1 
**Eliminar un Comentario**
* Crea una función que elimine un comentario de la tabla `Comentarios` dado su ID. 
Si el comentario no existe, debe devolver un mensaje que indique que no se encontró el comentario.

**Instrucciones:**
1. El procedimiento debe recibir como parámetro el `id_comentario`.
2. Eliminar el comentario de la tabla.
3. Si el comentario no existe, devolver un mensaje informando de ello.
4. Si la operación se ejecuta correctamente, devolver un mensaje informando de ello.

**Funcionamiento:**
- Crea un botón que ejecute la operación.
- Captura la id de un `JTextField`.

<details>

<summary>Haz clic para ver la solución en JAVA</summary>


````java

public boolean eliminarComentario(int idComentario) throws SQLException {

  if (!initDBConnection()) {

    throw new SQLException("Error al conectar con la base de datos");

  }

  try {

    String query = "DELETE FROM Comentarios WHERE id_comentario = ?";

    PreparedStatement preparedStatement = connection.prepareStatement(query);

    preparedStatement.setInt(1, idComentario);

    int rowsAffected = preparedStatement.executeUpdate();


    if (rowsAffected > 0) {

      System.out.println("Comentario eliminado exitosamente.");
      return true;

    } else {

      System.out.println("No se encontró el comentario con ID: " + idComentario);
      return false;
    }

  } catch (Exception e) {

    throw new SQLException("Error al eliminar el comentario: " + e.getMessage());

  } finally {

    closeDBConnection();

  }

}


````


</details>

### DELETE 2
**Eliminar una Ubicación**
* Desarrolla una función que permita eliminar una ubicación de la tabla `Ubicacion` siempre y cuando no esté asociada a ningún evento. 
* Si hay eventos asociados, debe notificar al usuario y no realizar la eliminación.

**Instrucciones:**
1. El procedimiento debe recibir como parámetro `id_ubicacion`.
2. Comprobar si existen eventos asociados a la ubicación.
3. Si no hay eventos, eliminar la ubicación; de lo contrario, devolver un mensaje que indique que la ubicación no puede ser eliminada.
4. Si la operación se ejecuta correctamente, devolver un mensaje informando de ello.


**Funcionamiento:**
- Crea un botón que ejecute la operación.

[//]: # (<details>)

[//]: # (<summary>Haz clic para ver la solución en JAVA</summary>)

[//]: # ()
[//]: # (````java)

[//]: # (public void eliminarUbicacion&#40;int idUbicacion&#41; throws SQLException {)

[//]: # (    if &#40;!initDBConnection&#40;&#41;&#41; {)

[//]: # (        throw new SQLException&#40;"Error al conectar con la base de datos"&#41;;)

[//]: # (    })

[//]: # ()
[//]: # (    try {)

[//]: # (        // Comprobar si hay eventos asociados a la ubicación)

[//]: # (        String checkQuery = "SELECT COUNT&#40;*&#41; FROM Evento WHERE id_ubicacion = ?";)

[//]: # (        PreparedStatement checkStatement = connection.prepareStatement&#40;checkQuery&#41;;)

[//]: # (        checkStatement.setInt&#40;1, idUbicacion&#41;;)

[//]: # (        ResultSet checkResultSet = checkStatement.executeQuery&#40;&#41;;)

[//]: # (        checkResultSet.next&#40;&#41;;)

[//]: # (        int count = checkResultSet.getInt&#40;1&#41;;)

[//]: # ()
[//]: # (        if &#40;count > 0&#41; {)

[//]: # (            System.out.println&#40;"No se puede eliminar la ubicación, ya que está asociada a eventos."&#41;;)

[//]: # (        } else {)

[//]: # (            // Eliminar la ubicación)

[//]: # (            String deleteQuery = "DELETE FROM Ubicacion WHERE id_ubicacion = ?";)

[//]: # (            PreparedStatement deleteStatement = connection.prepareStatement&#40;deleteQuery&#41;;)

[//]: # (            deleteStatement.setInt&#40;1, idUbicacion&#41;;)

[//]: # (            deleteStatement.executeUpdate&#40;&#41;;)

[//]: # (            System.out.println&#40;"Ubicación eliminada exitosamente."&#41;;)

[//]: # (        })

[//]: # (    } catch &#40;Exception e&#41; {)

[//]: # (        throw new SQLException&#40;"Error al eliminar la ubicación: " + e.getMessage&#40;&#41;&#41;;)

[//]: # (    } finally {)

[//]: # (        closeDBConnection&#40;&#41;;)

[//]: # (    })

[//]: # (})

[//]: # ()
[//]: # (````)

[//]: # (</details>)

### DELETE 3
**Eliminar un Artista**
* Crea un método que elimine un artista de la tabla `Artista` 
siempre y cuando no haya asistido a ningún evento. Si el artista ha estado en un evento, 
se debe actualizar un campo `disponible` en lugar de eliminarlo, estableciéndolo en `FALSE`.

**Instrucciones:**
1. El procedimiento debe recibir como parámetro el `id_artista`.
2. Verificar si el artista ha asistido a algún evento.
3. Si no ha asistido a ningún evento, eliminarlo de la tabla; si ha asistido, actualizar el campo `disponible` a `FALSE` 
y devolver un mensaje indicando que el artista ha sido deshabilitado.
4. Si la operación se ejecuta correctamente, devolver un mensaje informando de ello.


**Funcionamiento:**
- Crea un botón que ejecute la operación.

[//]: # (<details>)

[//]: # (<summary>Haz clic para ver la solución en JAVA</summary>)

[//]: # ()
[//]: # (````java)

[//]: # (public void eliminarArtista&#40;int idArtista&#41; throws SQLException {)

[//]: # (    if &#40;!initDBConnection&#40;&#41;&#41; {)

[//]: # (        throw new SQLException&#40;"Error al conectar con la base de datos"&#41;;)

[//]: # (    })

[//]: # ()
[//]: # (    try {)

[//]: # (        // Verificar si el artista ha asistido a algún evento)

[//]: # (        String checkQuery = "SELECT COUNT&#40;*&#41; FROM EventoArtista WHERE id_artista = ?";)

[//]: # (        PreparedStatement checkStatement = connection.prepareStatement&#40;checkQuery&#41;;)

[//]: # (        checkStatement.setInt&#40;1, idArtista&#41;;)

[//]: # (        ResultSet checkResultSet = checkStatement.executeQuery&#40;&#41;;)

[//]: # (        checkResultSet.next&#40;&#41;;)

[//]: # (        int count = checkResultSet.getInt&#40;1&#41;;)

[//]: # ()
[//]: # (        if &#40;count > 0&#41; {)

[//]: # (            // Actualizar el campo disponible a FALSE)

[//]: # (            String updateQuery = "UPDATE Artista SET disponible = FALSE WHERE id_artista = ?";)

[//]: # (            PreparedStatement updateStatement = connection.prepareStatement&#40;updateQuery&#41;;)

[//]: # (            updateStatement.setInt&#40;1, idArtista&#41;;)

[//]: # (            updateStatement.executeUpdate&#40;&#41;;)

[//]: # (            System.out.println&#40;"Artista deshabilitado exitosamente."&#41;;)

[//]: # (        } else {)

[//]: # (            // Eliminar el artista)

[//]: # (            String deleteQuery = "DELETE FROM Artista WHERE id_artista = ?";)

[//]: # (            PreparedStatement deleteStatement = connection.prepareStatement&#40;deleteQuery&#41;;)

[//]: # (            deleteStatement.setInt&#40;1, idArtista&#41;;)

[//]: # (            deleteStatement.executeUpdate&#40;&#41;;)

[//]: # (            System.out.println&#40;"Artista eliminado exitosamente."&#41;;)

[//]: # (        })

[//]: # (    } catch &#40;Exception e&#41; {)

[//]: # (        throw new SQLException&#40;"Error al eliminar el artista: " + e.getMessage&#40;&#41;&#41;;)

[//]: # (    } finally {)

[//]: # (        closeDBConnection&#40;&#41;;)

[//]: # (    })

[//]: # (})

[//]: # ()
[//]: # ()
[//]: # (````)

[//]: # (</details>)
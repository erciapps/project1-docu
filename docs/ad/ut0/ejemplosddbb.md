---
sidebar_position: 2
---

# EJEMPLOS SQL

## Tema: Gestión de Libros y Autores
### Enunciado: Diseña un sistema para gestionar libros y autores. El sistema debe permitir almacenar información sobre:
* **Autores** que tienen un `id_autor` único y un `nombre`.
* **Libros** que tienen un `id_libro` único y un `titulo`.
* Los libros pueden clasificarse en **categorías**, que tienen un `id_categoria` único y un `nombre_categoria`.
* Se debe establecer una relación que indique qué libros pertenecen a qué categorías.

## Tema: Gestión de Cursos y Estudiantes
### Enunciado: Diseña un sistema para gestionar cursos y estudiantes. El sistema debe permitir almacenar información sobre:

* **Estudiantes** que tienen un `id_estudiante` único y un `nombre`.
* **Cursos** que tienen un `id_curso único` y un `nombre_curso`.
* **Profesores** que tienen un `id_profesor` único y un `nombre_profesor`.
* Los estudiantes pueden inscribirse en varios cursos, y cada curso puede tener varios estudiantes. Se debe establecer una relación de inscripción.
* Los profesores pueden enseñar varios cursos, y cada curso puede ser impartido por varios profesores. Se debe establecer una relación de enseñanza.


## Tema: Gestión de Proyectos y Tareas
### Enunciado: Diseña un sistema para gestionar proyectos y tareas. El sistema debe permitir almacenar información sobre:
* **Proyectos** que tienen un `id_proyecto` único y un `nombre_proyecto`.
* **Empleados** que tienen un `id_empleado` único y un `nombre_empleado`.
* **Tareas** que tienen un `id_tarea único` y una `descripcion`.
* Los empleados pueden ser asignados a varias tareas, y cada tarea puede ser realizada por varios empleados. Se debe establecer una relación de asignación.
* Cada tarea pertenece a un proyecto. Se debe establecer una relación que vincule las tareas con los proyectos.
* Los proyectos pueden tener una **prioridad** que tiene un `id_prioridad` único y un `nivel`.


## Tema: Gestión de Ventas
### Enunciado: Diseña un sistema para gestionar ventas en una tienda. El sistema debe permitir almacenar información sobre:
* **Clientes** que tienen un `id_cliente` único y un `nombre`.
* **Productos** que tienen un `id_producto` único y un `nombre_producto`.
* **Ventas** que tienen un `id_venta` único y una `fecha`.
* Cada venta puede contener varios productos, y cada producto puede estar en varias ventas. Se debe establecer una relación que indique qué productos están en cada venta.
* Los productos pueden pertenecer a **categorías**, que tienen un `id_categoria` único y un `nombre_categoria`. Se debe establecer una relación que vincule los productos con sus categorías.
* También se debe permitir gestionar diferentes **formas de pago** para cada venta, donde cada forma de pago tiene un `id_forma_pago` único y un `tipo_pago`.



## Tema: Gestión de Eventos

### Enunciado: Diseña un sistema para gestionar eventos y asistentes. El sistema debe permitir almacenar información sobre:

* **Eventos** que tienen un `id_evento` único y un n`ombre_evento`.
* **Asistentes** que tienen un `id_asistente` único y un `nombre_asistente`.
* **Ubicaciones** que tienen un `id_ubicacion` único y una `direccion`.
* Cada evento puede tener varios asistentes, y cada asistente puede registrarse en varios eventos. Se debe establecer una relación de registro.
* Cada evento debe tener un tipo, que se describe en una tabla de **Tipos de Eventos** que tiene un `id_tipo_evento` único y una `descripcion`.
* **Organizadores** que tienen un `id_organizador` único y un `nombre_organizador`. Se debe establecer una relación que indique qué organizadores están a cargo de qué eventos.
* Se debe establecer una relación que vincule los eventos con sus tipos.
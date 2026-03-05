---
sidebar_position: 1
---

# Entidad relación

Sistema de Gestión para una Asociación de Adopción de Animales

La asociación "Huellas Felices" necesita un sistema para gestionar el proceso de rescate, cuidado y adopción de animales.
El sistema debe almacenar toda la información relevante sobre:

* Los animales disponibles o adoptados
* Las personas adoptantes
* Los voluntarios
* Las adopciones
* Las visitas y revisiones
* Donaciones
* Tratamientos veterinarios

1. Animales
De cada animal se desea almacenar:
- Identificador (único)
- Nombre
- Especie (perro, gato, conejo…)
- Raza
- Fecha de nacimiento (si se conoce)
- Sexo
- Fecha de ingreso en la asociación
- Estado (en adopción, reservado, adoptado, tratamiento)
- Fotos (atributo multivaluado: varios URLs o varias imágenes)
- Notas médicas

* Un animal puede tener varios tratamientos veterinarios y varios voluntarios responsables.

2. Voluntarios
La asociación cuenta con voluntarios que ayudan con los animales. Se guarda:
- Identificador
- Nombre y apellidos
- Teléfono
- Email
- Disponibilidad
- Habilidades (p.ej. adiestramiento, cuidados especiales) ← atributo multivaluado

* Un voluntario puede ser responsable de ningún, uno o varios animales.
* Un animal puede tener varios voluntarios asignados.
* (Relación N:M)

3. Personas adoptantes
De cada persona interesada en adoptar un animal se guarda:
- Identificador
- Nombre
- DNI
- Email
- Teléfono
- Dirección completa
- Fecha de registro

* Una persona puede haber adoptado 0, 1 o varios animales.

4. Adopciones
Cuando una persona adopta un animal, se registra:
- Identificador de la adopción
- Fecha de la adopción
- Cuota donada opcionalmente
- Firma digital o documento
- Estado (finalizada, en seguimiento, cancelada)

* Una adopción siempre relaciona a una persona y a un solo animal.
* Un animal no puede tener más de una adopción activa.
* (Relación 1:1 con restricción, pero los alumnos deben decidir si es 1:1 o 1:N con constraint)

5. Visitas y revisiones posteriores
Tras la adopción, se realizan visitas de seguimiento. Cada visita contiene:
- Identificador
- Fecha
- Voluntario que la realiza
- Observaciones
- Resultado (apto, necesita mejora, riesgo)

* Una adopción puede tener varias visitas, pero cada visita se asocia a un voluntario.
* (Relación 1:N con adopción)

6. Tratamientos veterinarios
Los animales pueden recibir diversos tratamientos. De cada tratamiento:
- Identificador
- Tipo (vacuna, operación, revisión)
- Fecha
- Veterinario externo (nombre)
- Resultado
- Coste

* Un animal puede tener muchos tratamientos, pero un tratamiento pertenece a un único animal.
* (Relación 1:N)

7. Donaciones

Las personas pueden hacer donaciones independientes de las adopciones. Se registra:

- Identificador
- Persona donante
- Fecha
- Cantidad
- Método de pago
- Comentario opcional

* Una persona puede hacer 0, 1 o muchas donaciones.
* (Relación 1:N)
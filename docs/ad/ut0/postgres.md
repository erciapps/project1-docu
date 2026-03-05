---
sidebar_position: 2
---
# Postgres

## Instalación PostgresSQL en Linux 🌐 ↔️

Instalaremos nuestra base de datos en el equipo **damx-database**. A continuación se muestran los pasos básicos de
instalación.   
Como es lógico, la contraseña `1234` **NUNCA** debe establecerse bajo ninguna circunstancia en un entrono de producción.
Nosotros la usaremos por simplificar la práctica.
:::danger
Antes de empezar asegúrate de realizar las operaciones con el usuario `root`
:::

##### Actualiza la lista de paquetes disponibles en los repositorios de software. Esto asegura que tengas la información más reciente sobre los paquetes disponibles para instalar.

```sh
sudo apt update
```

##### Instala últimos paquetes disponibles.

```sh
sudo apt upgrade
```

##### Instala PostgreSQL y el paquete adicional `postgresql-contrib`. El paquete contrib contiene extensiones y contribuciones adicionales para PostgreSQL.

```sh
sudo apt install postgresql postgresql-contrib
```

##### Cambia al usuario `postgres` con privilegios elevados.

```sh
sudo -i -u postgres
```

##### Inicia la interfaz de línea de comandos de PostgreSQL. Esto te permite interactuar directamente con la base de datos utilizando comandos SQL.

```sh
psql
```

##### Cambia la contraseña del usuario PostgreSQL llamado `postgres` a '1234'

```sh
ALTER USER postgres PASSWORD '1234';
```
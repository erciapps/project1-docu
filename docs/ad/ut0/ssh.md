---
sidebar_position: 3
---


# SSH

## Antes de empezar
**⚠️ES NECESARIO TENER ACCESO AL ESCRITORIO REMOTO DEL SERVIDOR⚠️**   
La url del hipervisor proxmox es https://192.168.88.99:8006. Accede a ella para realizar las prácticas.
- **Usuario:** tu identifiador dam
- **Contraseña:** tu DNI letras mayúsculas y todo junto
- **Realm:** Proxmox VE authentication server

## DESCRIPCIÓN
**SSH (Secure Shell)** es un protocolo de red que permite a los usuarios comunicarse de forma segura con otros dispositivos 
a través de una conexión cifrada. Es ampliamente utilizado en entornos de administración de sistemas para acceder de 
manera remota a servidores y dispositivos de red. Su importancia radica en la capacidad de proporcionar un canal 
seguro para la transferencia de datos sensibles, como contraseñas, comandos y archivos, 
a través de una red no segura, como Internet.
<figure>
  <img src="/2024/redes/img/ssh.jpg" alt="yad" width="450" />
</figure>

## OBJETIVOS
* Comprender el funcionamiento de SSH y su importancia en la seguridad de las comunicaciones.
* Configurar un servidor SSH en tu máquina local.
* Permitir el acceso remoto a tu máquina a través de SSH.
* Establecer una conexión SSH desde otra máquina.

<figure>
  <img src="/2024/redes/img/autenticacionssh.png" alt="autenticacionssh" width="520" />
</figure>

## Máquina SERVIDOR
La máquina identificada como *****server1***** será la destinada a recibir las conexiones, es decir, dispondrá del servidor SSH.

## Máquina CLIENTE
*****server2***** será nuestro cliente, es decir, nos conectaremos al servidor SSH desde esta máquina.

## PAUTAS SERVIDOR
Realiza estas operaciones en el servidor (*****server1*****)
### 1. Instalación de OpenSSH Server.
Utiliza el gestor de paquetes de tu sistema operativo para instalar el servidor OpenSSH.
```bash
sudo apt-get install openssh-server
```

### 2. Configuración del servidor SSH.
Edita el archivo de configuración de SSH para ajustar los parámetros según tus necesidades.
```bash
sudo nano /etc/ssh/sshd_config
```
* **`Port:`** El puerto por defecto para SSH es el **`22`**, puedes cambiarlo si lo deseas.
* **`PermitRootLogin:`** Asegúrate de que esté configurado como **`no`** para deshabilitar el acceso directo como root.
* **`PasswordAuthentication:`** Debería estar configurado como **`no`** para requerir autenticación mediante claves SSH.
* **`PubkeyAuthentication:`** Asegúrate de que esté configurado como **`yes`** para permitir la autenticación mediante claves SSH públicas.   
En resumen, deberás verificar que: `PasswordAuthentication no`
<figure>
  <img src="/2024/redes/img/sshconfig.png" alt="sshconfig" width="320" />
</figure>
Reiniciar el servicio para que los cambios surgan efecto:
```bash
sudo systemctl restart ssh
```

### 3. Configuración del cortafuegos (firewall).
Abrir el puerto de SSH para permitir conexiones entrantes.
Si estás utilizando el firewall `ufw`, puedes abrir el puerto SSH (por defecto, el puerto 22) con el siguiente comando:
```bash
sudo ufw allow ssh
```

### 4. Crear usuario para la conexión.
Crear un usuario específico para la conexión SSH es una práctica fundamental, ya limitas el acceso al sistema solo 
a aquellos que necesitan utilizarlo. Creamos al usuario `sshuser` con la contraseña `1234` (solo pruebas).
```bash
sudo adduser sshuser
```

### 5. Generación de claves SSH.

Cambia al usuario `sshuser`
```bash
su sshuser
```
Ejecuta el siguiente comando para generar las claves:
```bash
cd ~
mkdir .ssh
cd ~/.ssh
ssh-keygen -t rsa
```
* **`ssh-keygen:`** Este es el comando principal que se utiliza para generar, administrar y manipular claves SSH en 
sistemas Unix y Linux.
* **`-t rsa:`** Este es un indicador de tipo que se utiliza para especificar qué algoritmo de cifrado utilizar 
para generar la clave. En este caso, -t rsa especifica que se utilizará el algoritmo de cifrado RSA 
(Rivest-Shamir-Adleman) para generar el par de claves SSH.
El resultado de este comando será la creación de dos archivos en tu sistema: **clave pública y clave privada**.   
Estas claves las debe disponer tanto el servidor, como el cliente el cual se quiere conectar.   

Además, este comando nos pedirá un nombre para las claves. Usaremos `id_rsa` (pulsar enter).
También nos pedirá una frase o palabra que solo nosotros conocemos, y nos servirá de medida extra de seguridad al
realizar la conexión.   

<figure>
  <img src="/2024/redes/img/sshconfig2.png" alt="sshconfig2" width="450" />
</figure>

Finalmente, veremos algo como esto:

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/sshuser/.ssh/id_rsa):
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in sshuser_rsa
Your public key has been saved in sshuser_rsa.pub
The key fingerprint is:
SHA256:H4xFGyxAyFPTn/2345i4Psq8W7QJkny7H86gudwi1K sshuser@damxserver1
The key's randomart image is:
+---[RSA 3072]----+
|     . +=o o+    |
|      +  oo..o   |
|       .  +o..   |
|      . .o .o    |
|      E=So..     |
|     .  B + .   .|
|    . .o.B . o + |
|     ..+=.= + * .|
|      .oo**O.o . |
+----[SHA256]-----+
```
Si entramos en el directorio `~/.ssh` veremos los archivos generados:
```shell
cd ~/.ssh
ls -la
```
El resultado será algo como esto:
```
drwx------ 2 sshuser sshuser 4096 Mar 20 10:44 .
drwxr-x--- 3 sshuser sshuser 4096 Mar 20 10:43 ..
-rw------- 1 sshuser sshuser 2655 Mar 20 10:44 id_rsa
-rw-r--r-- 1 sshuser sshuser  573 Mar 20 10:44 id_rsa.pub
````

### 6. Autorización de usuarios.
Configura el acceso SSH para permitir la autenticación de usuarios específicos.
Para permitir el acceso SSH a nuestro usuario `sshuser`, añade su clave pública al archivo `~/.ssh/authorized_keys` 
del servidor SSH. Para ello ejecuta el siguiente comando con el usuario `sshuser` seleccionado:

```bash
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```
Este comando toma la clave pública recién generada (`sshuser_rsa.pub`) y la añade al archivo authorized_keys, 
permitiendo así que el usuario `sshuser` se autentique con esa clave.

Asegúrate de que el directorio `~/.ssh` tenga los permisos adecuados (700 para el directorio `.ssh` y 600 para 
el archivo `~/.ssh/authorized_keys` ) 
para garantizar la seguridad de las claves.

```shell
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
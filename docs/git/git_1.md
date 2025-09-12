---
sidebar_position: 1
---

# Guía práctica de Git

## ¿Qué nos permite hacer git?

**Git nos va a permitir:**

- **Guardar el historial del proyecto:** ver qué cambió y cuándo, como un “deshacer” mucho más potente.
- **Trabajar en equipo sin pisarnos:** cada uno aporta sus cambios y luego se juntan ordenadamente.
- **Tener varias líneas de trabajo (ramas):** por ejemplo, una para pruebas y otra para la versión estable.
- **Probar ideas sin miedo:** si algo sale mal, vuelves atrás a una versión que funcionaba.
- **Trabajar incluso sin Internet:** puedes avanzar y más tarde sincronizarlo todo.
- **Marcar hitos:** poner etiquetas tipo `v1.0` para señalar versiones importantes.
- **Saber quién hizo qué:** cada cambio lleva autor y mensaje, útil para recordar decisiones.
- **Tener copia de seguridad:** guardar el proyecto en un servidor (GitHub, etc.) por si tu equipo falla.



---

## Términos clave

| Término                | Definición simple                                   | Ejemplo / Comando típico              |
| ---------------------- | --------------------------------------------------- | ------------------------------------- |
| **Proyecto**           | Carpeta con tu código y archivos.                   | —                                     |
| **Repositorio**        | Proyecto con historial controlado por Git.          | `git init`                            |
| **Repositorio local**  | El repo en tu ordenador.                            | —                                     |
| **Repositorio remoto** | Copia del repo en un servidor (GitHub, GitLab…).    | `git remote add origin <url>`         |
| **Git**                | Herramienta de control de versiones.                | —                                     |
| **GitHub**             | Servicio para alojar repos y colaborar.             | —                                     |
| **Versión (commit)**   | “Foto” del estado del proyecto.                     | `git commit -m "mensaje"`             |
| **Cambios**            | Modificaciones realizadas en archivos.              | `git status`                          |
| **Área de trabajo**    | Archivos tal cual en tu carpeta.                    | —                                     |
| **Staging / Índice**   | Zona para preparar lo que se guardará en un commit. | `git add archivo`                     |
| **Commit**             | Guardado de lo preparado con un mensaje.            | `git commit -m "mensaje"`             |
| **Mensaje de commit**  | Resumen corto y claro de lo hecho.                  | `"Corrige login"`                     |
| **Historial (log)**    | Lista de commits del repo.                          | `git log --oneline`                   |
| **Rama (branch)**      | Línea de trabajo paralela e independiente.          | `git switch -c feature/x`             |
| **Principal / main**   | Rama principal del proyecto.                        | `git switch main`                     |
| **Merge**              | Unir cambios de una rama a otra.                    | `git merge feature/x`                 |
| **Conflicto**          | Git no sabe mezclar cambios automáticamente.        | Editar, `git add`, luego `git commit` |
| **Push**               | Enviar tus commits al remoto.                       | `git push origin main`                |
| **Pull**               | Traer y mezclar cambios del remoto.                 | `git pull`                            |
| **Fetch**              | Traer cambios del remoto **sin** mezclar.           | `git fetch`                           |
| **Clone**              | Copiar un repo remoto a tu máquina.                 | `git clone <url>`                     |
| **Fork**               | Copia de un repo en tu cuenta (GitHub).             | Botón **Fork** en GitHub              |
| **Pull Request (PR)**  | Propuesta para mezclar tu rama en otra.             | En GitHub/GitLab                      |
| **Tag / Etiqueta**     | Marca una versión importante.                       | `git tag v1.0`                        |
| **.gitignore**         | Archivos/carpetas que Git debe ignorar.             | `node_modules/`                       |
| **HEAD**               | Puntero a tu commit/rama actual.                    | `git show HEAD`                       |
| **Checkout / Switch**  | Cambiar de rama o versión.                          | `git switch rama`                     |
| **Reset**              | Mover HEAD / deshacer cambios (con cuidado).        | `git reset --hard HEAD~1`             |
| **Stash**              | Guardado temporal de cambios sin commitear.         | `git stash`, `git stash pop`          |
| **Diff**               | Ver diferencias entre archivos/commits.             | `git diff`                            |

---


## Instalación

### MacOS
```bash
brew install git
```

### Linux
```bash
sudo apt update
sudo apt install git
```

### Windows
[Descargar instalador](https://github.com/git-for-windows/git/releases/download/v2.51.0.windows.1/Git-2.51.0-64-bit.exe)

---



## Configuración inicial

```bash
git config --global user.name "NombreUsuario"
git config --global user.email "CorreoUsuario"
git config --global credential.helper store
```

**Nota:** `--global` indica que esta configuración se aplica a nivel de todo el sistema.

Ejemplo:
```bash
git config --global user.name "JuanPerez"
git config --global user.email "juanperez@example.com"
```

---

## Iniciar Git en un proyecto

Desde el directorio raíz que queremos sincronizar con Git:

```bash
git init
```

Esto crea la carpeta oculta `.git`, lo que indica que el directorio ya trabaja con control de versiones.

### Añadir y confirmar cambios iniciales

```bash
git add .
git commit -m "Crear repositorio"
```

---

## Ramas (Branches)

- **Listar ramas**
```bash
git branch
```

- **Cambiar nombre a la rama**
```bash
git branch -m main
```

- **Crear nueva rama**
```bash
git branch NombreNuevaRama
```

- **Cambiar de rama**
```bash
git checkout NombreRama
# o con la sintaxis moderna
git switch NombreRama
```

- **Restaurar archivo al último commit**
```bash
git checkout NombreArchivo
```

- **Resetear cambios**
```bash
git reset
```

Ejemplo:
```bash
git branch feature-login
git switch feature-login
```

---

## Estados del repositorio

- **Ver estado actual**
```bash
git status
```

- **Historial de commits**
```bash
git log
git log --graph --pretty=oneline
```

- **Historial de referencias**
```bash
git reflog
```

Ejemplo:
```bash
git log --oneline
```

---

## Archivo `.gitignore`

Se usa para indicar archivos o directorios que no queremos incluir en el control de versiones.  
Debe estar en la raíz del repositorio.

1. Crear archivo:
```bash
touch .gitignore
```

2. Editar y añadir los elementos a ignorar:
```gitignore
node_modules/
*.log
*.tmp
```

Ejemplo: ignorar todos los archivos `.env`:
```gitignore
*.env
```

---

## Comparar cambios

Ver diferencias respecto al último commit:

```bash
git diff
```

Ejemplo:
```bash
git diff index.html
```

---

## Desplazamiento entre commits y tags

- **Moverse a un commit específico (por ID)**
```bash
git checkout id_commit
```

- **Moverse a un tag**
```bash
git checkout tag/nombre_tag
```

Ejemplo:
```bash
git checkout 3f5a2c1
git checkout v1.0.0
```

---

## Tags

- **Crear un tag**
```bash
git tag nombre_tag
```

- **Listar tags**
```bash
git tag
```

Ejemplo:
```bash
git tag v1.0.0
git tag
```

---

## Resumen

Con esta guía puedes instalar, configurar, crear repositorios, trabajar con ramas, gestionar estados, ignorar archivos, comparar cambios y usar tags en Git.

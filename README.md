Docker, Terraform y Ansible: Guía completa para la implementación de una aplicación web
Objetivo:

Esta guía describe paso a paso el proceso de implementación de una aplicación web para votar por Bolívar y The Strongest, utilizando Docker, Terraform y Ansible. La aplicación está escrita en PHP y Redis y se despliega en un servidor creado con Terraform. Ansible se utiliza para instalar Docker y otras utilidades en el servidor, y Docker Swarm Mode se utiliza para administrar la aplicación en un entorno de alta disponibilidad.

Requisitos:

Docker:

Docker 1.12 o superior
docker-compose 1.8 o superior
Terraform:

Terraform 0.8.x o superior
Ansible:

Ansible 2.2.x o superior
Aplicación:

La aplicación web para votar por Bolívar y The Strongest, escrita en PHP y Redis, lista para ser desplegada
Pasos:

1. Despliegue de la aplicación con Docker Compose
Desplazarse al directorio de la aplicación:
Bash
cd votacion
Use code with caution.
content_copy
Iniciar la aplicación con Docker Compose:
Bash
docker-compose up -d
Use code with caution.
content_copy
Guardar la aplicación en Docker Hub (para producción):
Perl
docker-compose push
Use code with caution.
content_copy
2. Creación de la infraestructura con Terraform
Generar una clave SSH:
Mathematica
ssh-keygen -t rsa -b 4096 -C "dockernights1"
Use code with caution.
content_copy
Ingresar al directorio de Terraform y ejecutar plan:
Shell
cd terraform
terraform plan -out dockernights1
Use code with caution.
content_copy
Completar las variables con las keys y el correo electrónico:
Edita el archivo terraform.tfvars y proporciona los valores para las variables ssh_private_key y email.

Crear la instancia:
Ruby
terraform apply dockernights1
Use code with caution.
content_copy
Terraform se encargará de:

Subir la clave SSH
Crear el servidor
Añadir el registro con la IP al dominio web.tusitio.com
3. Instalación de Docker y utilidades con Ansible
Obtener la IP del servidor generado con Terraform:
Shell
cd terraform
terraform show
# Buscar el parámetro ipv4_address
Use code with caution.
content_copy
Editar el archivo hosts en la carpeta ansible:
C#
[la_ip_de_tu_servidor]
Use code with caution.
content_copy
Ejecutar el playbook para instalar Docker y otras utilidades:
Shell
cd ansible
ansible-playbook -i hosts install-docker.yml
Use code with caution.
content_copy
Ansible se encargará de:

Añadir la llave GPG y el repositorio oficial de Docker
Instalar Docker y las dependencias necesarias
4. Implementación de Docker Swarm Mode
Acceder al servidor vía SSH y cambiar a modo Swarm:
Ruby
# En la carpeta raíz del repositorio
ssh -i dockernights1 root@<ip_publica>
docker swarm init --advertise-addr <ip_publica>
Use code with caution.
content_copy
Ejecutar el visualizador de Swarm:
Shell
docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer
Use code with caution.
content_copy
Crear una red de tipo overlay en Docker:
SQL
docker network create -d overlay votacion
Use code with caution.
content_copy
Crear el servicio redis:
CSS
docker service create --name redis --replicas 1 --network votacion redis:3.0-alpine
Use code with caution.
content_copy
Crear el servicio app:
CSS
docker service create --name app -p 80:3000 --network votacion dockerlapaz/votacion:1.0.0
Use code with caution.
content_copy
Escalar el servicio app a 5 réplicas:
Bash
docker service scale app=5
Use code with caution.
content_copy
Obtener la versión de la aplicación:
Bash
while true; do curl http://ip_publica/version.php; sleep 1; done
Use code with caution.
content_copy
5. Envío de logs a Papertrail con Logspout
Crear una cuenta en Papertrail:
Ir a https://www.papertrail.com/ y crear una cuenta gratuita. Obtener la dirección

Sources
info
blog.axway.com/product-insights/amplify-platform/api-builder/running-api-builder-on-raspberry-pi-cluster-using-docker-swarm-part-1
nemerosa.ghost.io/2016/11/11/creating-a-docker-swarm-at-digitalocean-using-terraform/



share


more_vert

Las partes que son codifgo no me las des en el cuadro donde dice que tipo de codigo es por favor ponmelo como lo demas
edit
Show drafts
volume_up


1

2
Docker, Terraform y Ansible: Guía completa para la implementación de una aplicación web
Objetivo:

Esta guía describe paso a paso el proceso de implementación de una aplicación web para votar por Bolívar y The Strongest, utilizando Docker, Terraform y Ansible. La aplicación está escrita en PHP y Redis y se despliega en un servidor creado con Terraform. Ansible se utiliza para instalar Docker y otras utilidades en el servidor, y Docker Swarm Mode se utiliza para administrar la aplicación en un entorno de alta disponibilidad.

Requisitos:

Docker:

Docker 1.12 o superior
docker-compose 1.8 o superior
Terraform:

Terraform 0.8.x o superior
Ansible:

Ansible 2.2.x o superior
Aplicación:

La aplicación web para votar por Bolívar y The Strongest, escrita en PHP y Redis, lista para ser desplegada
Pasos:

1. Despliegue de la aplicación con Docker Compose
Desplazarse al directorio de la aplicación:
cd votacion
Iniciar la aplicación con Docker Compose:
docker-compose up -d
Guardar la aplicación en Docker Hub (para producción):
docker-compose push
2. Creación de la infraestructura con Terraform
Generar una clave SSH:
ssh-keygen -t rsa -b 4096 -C "dockernights1"
Ingresar al directorio de Terraform y ejecutar plan:
cd terraform
terraform plan -out dockernights1
Completar las variables con las keys y el correo electrónico:
Edita el archivo terraform.tfvars y proporciona los valores para las variables ssh_private_key y email.

Crear la instancia:
terraform apply dockernights1
Terraform se encargará de:

Subir la clave SSH
Crear el servidor
Añadir el registro con la IP al dominio web.tusitio.com
3. Instalación de Docker y utilidades con Ansible
Obtener la IP del servidor generado con Terraform:
cd terraform
terraform show
# Buscar el parámetro ipv4_address
Editar el archivo hosts en la carpeta ansible:
[la_ip_de_tu_servidor]
Ejecutar el playbook para instalar Docker y otras utilidades:
cd ansible
ansible-playbook -i hosts install-docker.yml
Ansible se encargará de:

Añadir la llave GPG y el repositorio oficial de Docker
Instalar Docker y las dependencias necesarias

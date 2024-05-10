Docker, Terraform, Ansible 
Requisitos:
Docker 1.12 o superior
docker-compose 1.8 o superior
Una aplicación para votar por Bolívar y The Strongest, escrita en PHP y Redis, está lista para ser desplegada:

shell
Copy code
$ cd votacion
$ docker-compose up -d
Una vez lista para producción, la aplicación se guarda en Docker Hub:

perl
Copy code
$ docker-compose push
Terraform
Requisitos:
Terraform 0.8.x o superior
Genera una llave SSH en la raíz del proyecto, llamándola dockernights1:

mathematica
Copy code
$ ssh-keygen -t rsa -b 4096 -C "dockernights1"
Ingresa a la carpeta terraform, ejecuta plan y completa las variables con los keys y tu email:

shell
Copy code
$ cd terraform
$ terraform plan -out dockernights1

Ejecuta la creación de la instancia:

ruby
Copy code
$ terraform apply dockernights1

Terraform se encarga de subir la llave SSH, crear el servidor y añadir el registro con la IP al dominio web.tusitio.com.

Ansible
Requisitos:
Ansible 2.2.x o superior

Toma nota de la IP del servidor generada con terraform:

shell
Copy code
$ cd terraform
$ terraform show
# Busca el parámetro ipv4_address

Edita el archivo hosts de la carpeta ansible:

csharp
Copy code
[la_ip_de_tu_servidor]

Ejecuta el playbook para instalar Docker y otras utilidades:

shell
Copy code
$ cd ansible
$ ansible-playbook -i hosts install-docker.yml

Ansible agrega la llave GPG y el repositorio oficial de Docker, instalando todas las dependencias.

Docker Swarm Mode
Requisitos
Docker 1.12

Ingresa a tu servidor vía SSH y cambia a modo Swarm usando tu IP pública:

ruby
Copy code
# en la carpeta raíz de este repositorio
$ ssh -i dockernights1 root@<ip_publica>
$ docker swarm init --advertise-addr <ip_publica>
Corre el visualizador de Swarm:

shell
Copy code
$ docker service create \
  --name=viz \
  --publish=8080:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer
Crea una red de tipo overlay en Docker:

sql
Copy code
$ docker network create -d overlay votacion
Crea el servicio redis adjuntándolo a la red votacion:

css
Copy code
docker service create --name redis --replicas 1 --network votacion redis:3.0-alpine
El servicio app corre con la imagen de la aplicación web:

css
Copy code
docker service create --name app -p 80:3000 --network votacion dockerlapaz/votacion:1.0.0
Escala el servicio app a 5 replicas:

Copy code
docker service scale app=5
Obtén la versión de la aplicación:

bash
Copy code
while true; do curl http://ip_publica/version.php; sleep 1; done
Logspout
Logspout captura los logs de la aplicación web y los envía a Papertrail.

Crea una cuenta en Papertrail y obtén la dirección de envío de logs (logs#.papertrailapp.com:PORT).

Dentro del servidor principal, crea el siguiente servicio reemplazando la dirección de logs al final del comando:

bash
Copy code
docker service create --name logspout --mode global --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock gliderlabs/logspout syslog://logs#.papertrailapp.com:PORT
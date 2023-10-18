#!/bin/bash

#Mostramos los comandos que ejecutamos
set -x

#Actualizamos los paquetes
dnf update -y

#Instalamos el servidor web Apache
dnf install httpd -y

#Iniciamos el servicio de Apache
systemctl start httpd

#Activamos el inicio automático de Apache en cada encendido del sistema
systemctl enable httpd

#Instalamos MySQL server
dnf install mysql-server -y

#Iniciamos el servicio de mysql server
systemctl start mysqld

#Programamos para que se inicie automáticamente en encendido
systemctl enable httpd

#Instalamos php
dnf install php -y

#Instalamos la extensión de PHP para MySQL
dnf install php-mysqlnd -y

#Reiniciamos el servicio de Apache
systemctl restart httpd

#Copiamos el archivo info.php en /var/www/html
cp ../php/info.php /var/www/html

#Cambiamos el propietario y el grupo del directorio /var/www/html
chown -R apache:apache /var/www/html
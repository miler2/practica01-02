#!/bin/bash

#Configuración habitual
set -x

#Importamos las variables del archivo .env
source .env

#Updateamos los repositorios
dnf update -y

#Instalamos los módulos de php necesarios para phpMyAdmin
sudo dnf install php-mbstring php-zip php-json php-gd php-gd php-fpm php-xml -y

#Reiniciamos el servicio Apache
systemctl restart httpd

#Instalamos la utilidad wget para poder descargar cosas mediante enlaces
dnf install wget -y

#Eliminamos descargas previas de phpMyAdmin
rm -rf /tmp/phpMyAdmin-5.2.1-all-languages.zip
rm -rf /var/www/html/phpMyAdmin

#Descargamos el código fuente de phpMyAdmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip -P /tmp #-P es para decir dónde queremos que se realice esta instalación

#Instalamos la utilidad unzip
dnf install unzip -y

#Descomprimimos el código fuente de phpMyAdmin en /var/www/html
unzip /tmp/phpMyAdmin-5.2.1-all-languages.zip -d /var/www/html

#Renombramos el archivo
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpMyAdmin

#Actualizamos los permisos del directorio /var/www/html
chown -R apache:apache /var/www/html

#Creamos el archivo de configuración a partir del archivo de ejemplo
cp /var/www/html/phpMyAdmin/config.sample.inc.php /var/www/html/phpMyAdmin/config.inc.php

#Configuramos la variable blowfish_secret

#Generamos un valor aleatorio de 32 caracteres 
RANDOM_VALUE=`openssl rand -hex 16`

#Eliminamos si existe alguna base de datos previa de phpMyAdmin
mysql -u root <<< "DROP DATABASE IF EXISTS phpmyadmin"

#Importamos el script de creación de base de datos de phpMyAdmin
mysql -u root < /var/www/html/phpMyAdmin/sql/create_tables.sql

#Creamos el usuario para la base de datos y le asignamos privilegios
sudo mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'%'"
sudo mysql -u root <<< "CREATE USER $PMA_USER@'%' IDENTIFIED BY '$PMA_PASS'"
sudo mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'%'"
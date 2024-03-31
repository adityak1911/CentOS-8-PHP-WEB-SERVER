#!/bin/bash
sudo -y dnf update
sudo -y dnf install php php-fpm php-mysqlnd php-common php-curl php-json php-mbstring php-xml php-zip

# Install Apache
sudo yum -y install httpd

# Start Apache
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Install MariaDB
sudo yum install mariadb-server

# Start MariaDB
sudo systemctl start mariadb

# Enable MariaDB to start on boot
sudo systemctl enable mariadb

# MySQL installation (secure installation)
#sudo mysql_secure_installation

# Install PHP
sudo yum -y install php php-mysqlnd

# Restart Apache
sudo systemctl restart httpd

# Change ownership of the web directory
sudo chown -R apache.apache /var/www/html/

# Create a PHP info file
sudo vi /var/www/html/info.php


# Update package lists
sudo dnf -y update

# Install PHP and required modules
sudo dnf -y install php php-mysqlnd php-opcache php-gd php-curl php-json php-zip php-mbstring php-xml



sudo dnf -y install epel-release
sudo dnf -y install certbot python3-certbot-apache mod_ssl





#giving permission to write all files to apache

sudo chown -R :apache /var/www/
sudo chmod -R 775 /var/www/

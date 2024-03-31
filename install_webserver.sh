#!/bin/bash


# centos update reference
#https://stackoverflow.com/questions/70963985/error-failed-to-download-metadata-for-repo-appstream-cannot-prepare-internal
# Update package lists

if sudo dnf -y update 2>&1 | grep -q "Failed to download metadata for repo 'AppStream': Cannot prepare internal mirrorlist: No URLs in mirrorlist"; then
    echo "Failed to update using AppStream repository. Trying with a different repository."

    cd /etc/yum.repos.d/
    sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
    sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
    sudo yum update -y
    
    wget 'http://mirror.centos.org/centos/8-stream/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-3.el8.noarch.rpm'
    sudo rpm -i 'centos-gpg-keys-8-3.el8.noarch.rpm'
    dnf --disablerepo '*' --enablerepo=extras swap centos-linux-repos centos-stream-repos
    
    sudo dnf -y distro-sync
    
    rm -f centos-gpg-keys-8-3.el8.noarch.rpm
    
else
    echo "Package lists updated successfully."

fi


cd /


sudo -y dnf install php php-fpm php-mysqlnd php-common php-curl php-json php-mbstring php-xml php-zip

# Install Apache
sudo yum -y install httpd

# Start Apache
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Install MariaDB
sudo yum -y install mariadb-server

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
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php >/dev/null


# Update package lists
sudo dnf -y update

# Install PHP and required modules
sudo dnf -y install php php-mysqlnd php-opcache php-gd php-curl php-json php-zip php-mbstring php-xml



sudo dnf -y install epel-release
sudo dnf -y install certbot python3-certbot-apache mod_ssl


#giving permission to write all files to apache

sudo chown -R :apache /var/www/
sudo chmod -R 775 /var/www/

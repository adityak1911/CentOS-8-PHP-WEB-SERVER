#!/bin/bash


# centos update reference
#https://stackoverflow.com/questions/70963985/error-failed-to-download-metadata-for-repo-appstream-cannot-prepare-internal
# Update package lists

# centos stream 10 update reference
# Fix for "Failed to download metadata for repo 'appstream'"
# Updated for CentOS Stream 10 mirrors

if sudo dnf -y update 2>&1 | grep -q "Failed to download metadata for repo"; then
    echo "Mirrorlist issue detected. Switching to static Stream 10 Base URLs..."

    # 1. Enter the repo directory
    cd /etc/yum.repos.d/

    # 2. Comment out mirrorlist and swap baseurl to the official Stream 10 mirror
    # Note: Stream 10 repo files are usually named centos.repo or centos-addons.repo
    sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/centos*.repo
    sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=https://mirror.stream.centos.org|g' /etc/yum.repos.d/centos*.repo

    # 3. Specifically target the 10-stream path
    # This ensures the baseurl points to the correct version directory
    sudo sed -i 's|baseurl=https://mirror.stream.centos.org/centos/\$releasever|baseurl=https://mirror.stream.centos.org/10-stream|g' /etc/yum.repos.d/centos*.repo

    # 4. Clean and update
    sudo dnf clean all
    sudo dnf -y update

    # 5. Handle GPG Keys if necessary 
    # (Stream 10 keys are usually bundled, but this fetches the official release key if missing)
    wget https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official
    sudo rpm --import RPM-GPG-KEY-CentOS-Official
    
    sudo dnf -y distro-sync
    
    rm -f RPM-GPG-KEY-CentOS-Official
    
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

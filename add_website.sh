#!/bin/bash

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

# Prompt for domain name
read -p "Enter domain name (e.g., example.com): " domain_name

# Check if domain name is provided
if [ -z "$domain_name" ]; then
    echo "Domain name cannot be empty"
    exit 1
fi

# Create Apache configuration file
conf_file="/etc/httpd/conf.d/${domain_name}.conf"
if [ -f "$conf_file" ]; then
    echo "Configuration file already exists for $domain_name"
    exit 1
fi

cat <<EOF > "$conf_file"
<VirtualHost *:80>
    ServerAdmin webmaster@${domain_name}
    ServerName ${domain_name}
    DocumentRoot /var/www/html/${domain_name}
    ErrorLog /var/log/httpd/${domain_name}_error.log
    CustomLog /var/log/httpd/${domain_name}_access.log combined

    <Directory /var/www/html/${domain_name}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

</VirtualHost>

EOF

# Create document root directory
doc_root="/var/www/html/${domain_name}"
mkdir -p "$doc_root"

# Create a simple index.php file
echo "<?php phpinfo(); ?>" > "${doc_root}/index.php"

# Set ownership and permissions
chown -R apache:apache "$doc_root"
chmod -R 775 "$doc_root"


# Reload Apache to apply changes
systemctl reload httpd

sleep 2

# adding ssl certificate


if sudo certbot certonly --apache -d ${domain_name}; then
    # Execute additional commands here if certbot is successful
    echo "Certificate successfully created."
    
    
sleep 4

cat <<EOF > "$conf_file"
<VirtualHost *:80>
    ServerAdmin webmaster@${domain_name}
    ServerName ${domain_name}
    DocumentRoot /var/www/html/${domain_name}
    ErrorLog /var/log/httpd/${domain_name}_error.log
    CustomLog /var/log/httpd/${domain_name}_access.log combined

    <Directory /var/www/html/${domain_name}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

</VirtualHost>

<IfModule mod_ssl.c>
    <VirtualHost *:443>
        ServerName ${domain_name}
        DocumentRoot /var/www/html/${domain_name}
    
        <Directory /var/www/html/${domain_name}>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>
    
        ErrorLog /var/log/httpd/${domain_name}_error.log
        CustomLog /var/log/httpd/${domain_name}_access.log combined
    
        
        SSLCertificateFile /etc/letsencrypt/live/${domain_name}/fullchain.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/${domain_name}/privkey.pem
        Include /etc/letsencrypt/options-ssl-apache.conf
        
    </VirtualHost>
</IfModule>

EOF
    
else
    # Handle the case where certbot fails
    echo "Failed to create certificate."
fi



# Reload Apache to apply changes
systemctl reload httpd

echo "Apache configuration file created for $domain_name"
echo "Document root: $doc_root"

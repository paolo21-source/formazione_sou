bash 
#!/bin/bash
apt-get update
apt-get install -y apache2 
systemctl start apache2 
mkdir -p /var/www/html
cp -r /vagrant/site/. /var/www/html/
chown -R www-data:www-data /var/www/html
#! /bin/bash
sudo yum update -y
sudo yum install -y httpd php mariadb105-server
sudo yum install -y php-mysqli
sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl enable mariadb
sudo systemctl start mariadb

sudo mysql -e "CREATE DATABASE mydb /*\!40100 DEFAULT CHARACTER SET utf8 */;"
sudo mysql -e "CREATE USER alex@localhost IDENTIFIED BY 'password123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON mydb.* TO 'alex'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

curl -LO https://wordpress.org/latest.zip
sudo mv latest.zip /var/www/html
cd /var/www/html
sudo unzip latest.zip
sudo mv -f wordpress/* ./

sudo cp wp-config-sample.php wp-config.php 
sudo sed -i 's/database_name_here/mydb/' wp-config.php 
sudo sed -i 's/username_here/alex/' wp-config.php 
sudo sed -i 's/password_here/password123/' wp-config.php

sudo service httpd restart
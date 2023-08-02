#! /bin/bash
sudo yum update -y
sudo yum install -y httpd php 
sudo yum install -y php-mysqli
sudo systemctl enable httpd
sudo systemctl start httpd

curl -LO https://wordpress.org/latest.zip
sudo mv latest.zip /var/www/html
cd /var/www/html
sudo unzip latest.zip
sudo mv -f wordpress/* ./

sudo cp wp-config-sample.php wp-config.php 
sudo sed -i "s/database_name_here/${DB}/" wp-config.php
sudo sed -i "s/username_here/${User}/" wp-config.php
sudo sed -i "s/password_here/${PW}/" wp-config.php
sudo sed -i "s/localhost/${host}/" wp-config.php

#wget https://deham6-wordpress.s3.ap-south-1.amazonaws.com/
#sudo mv -f content/* /var/www/html/wp-content

sudo service httpd restart
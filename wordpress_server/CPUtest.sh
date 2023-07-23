#!/bin/bash -ex
yum -y update
yum -y install httpd php
/usr/bin/systemctl enable httpd
/usr/bin/systemctl start httpd
cd /var/www/html
#wget https://aws-tc-largeobjects.s3.amazonaws.com/ILT-TF-100-TUFOUN-1/6-lab-scale-loadbalance/loadtestapp.zip
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RESTRT-1-23732/174-lab-JAWS-scale-load-balance/s3/loadtestapp.zip
unzip loadtestapp.zip -d /var/www/html/
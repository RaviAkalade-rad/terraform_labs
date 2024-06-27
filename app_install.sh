#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
service httpd start  
echo '<h1>Terraform is Awesome..</h1>' | sudo tee /var/www/html/index.html
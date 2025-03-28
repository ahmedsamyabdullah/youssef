#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
sudo echo "<h2> Programmed By Youssef </h2>" > /var/www/html/index.html
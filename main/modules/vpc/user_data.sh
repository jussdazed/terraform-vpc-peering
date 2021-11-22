#!/bin/bash

yum -y update
sudo amazon-linux-extras install nginx1

echo "<h2>My WebServer<h2>" > /var/www/html/index.html

sudo systemctl start nginx
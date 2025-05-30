#!/bin/bash
sudo yum update -y
sudo curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g http-server
mkdir app
cd app
echo "Hello from AWS Auto Scaling!" > index.html
http-server -p 80

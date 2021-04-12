#!/bin/bash

source Components/common.sh
COMPONENT=frontend
Print "Installing Nginx"
 yum install nginx -y &> /tmp/frontend.log
 stat $?
 systemctl enable nginx
 Print "Starting Nginx"
 systemctl start nginx
 stat $?
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
 cd /usr/share/nginx/html
 rm -rf *
 unzip /tmp/frontend.zip &>> /tmp/frontend.log
 mv frontend-main/* .
 mv static/* .
 rm -rf frontend-master README.md
 rm -rf /etc/nginx/default.d/roboshop.conf
 mv localhost.conf /etc/nginx/default.d/roboshop.conf
 systemctl restart nginx
 stat $?
 Print "reStarting Nginx" "Nginx Started"
 Print "You can hit the roboShop now" "Frontend Read "
 stat $?

 sudo yum install git maketext make -y
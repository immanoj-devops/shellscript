#!/bin/bash
source Components/common.sh
COMPONENT=cart

Print "Installing NodeJS" "yum install nodejs make gcc-c++ -y"  "${COMPONENT}"
yum install nodejs make gcc-c++ -y &> /tmp/${COMPONENT}.log
stat $?

Print "Adding Roboshop User" "useradd roboshop"
id roboshop || useradd roboshop

Print "Downloading cart content" "npm install"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
rm -rf /home/roboshop/cart && cd /home/roboshop && unzip /tmp/cart.zip && mv /home/roboshop/cart-main /home/roboshop/cart && cd /home/roboshop/cart
stat $?

Print "Install NOdeJS Dependencies" "npm install"
npm install --unsafe-perm
Stat $?

chown roboshop:roboshop /home/roboshop -R

Print "Updating Redis & Catalogue EndPoint" "update cart service and start cart service "
sed -i -e 's/REDIS_ENDPOINT/redis.manojtestdmn.tk/' -e 's/CATALOGUE_ENDPOINT/catalogue.manojtestdmn.tk/' /home/roboshop/cart/systemd.service
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload && systemctl restart cart && systemctl enable cart
stat $?


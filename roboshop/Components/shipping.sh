#!/bin/bash
set -e
source Components/common.sh
COMPONENT=shipping

Print "yum install maven" "Installing Maven"
yum install maven -y &> /tmp/${COMPONENT}.log
stat $?


Print "Adding roboshop user" "useradd roboshop"
id roboshop || useradd roboshop
stat $?


Print "Download Shipping COde" 'curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"'
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip"
stat $?

cd /home/roboshop
unzip /tmp/shipping.zip &>> /tmp/${COMPONENT}.log
mv shipping-main shipping
cd shipping
stat $?

Print "building the artifacts" "mvn clean package"
mvn clean package  &>> /tmp/${COMPONENT}.log
mv target/shipping-1.0.jar shipping.jar
stat $?

Print "Updating cart and mysql endPoints in the systemd.service" "Updated end points"
sed -i -e "s/CARTENDPOINT/cart.manojtestdmn.tk/" -e "s/DBHOST/mysql.manojtestdmn.tk/" /home/roboshop/shipping/systemd.service
stat $?

chown roboshop:roboshop /home/roboshop -R

Print "Start Shipping Service" "mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service && systemctl daemon-reload && systemctl enable shipping && systemctl restart shipping"
mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service && systemctl daemon-reload && systemctl enable shipping && systemctl restart shipping
stat $?






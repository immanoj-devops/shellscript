#!/bin/bash
s
source Components/common.sh
COMPONENT=payment

Print "Installing python and libs " "yum install python36 gcc python3-devel -y"
yum install python36 gcc python3-devel -y &> /tmp/${COMPONENT}.log
stat $?

Print "Adding roboshop user" "useradd roboshop" ${COMPONENT}""
id roboshop || useradd roboshop
stat $?

Print "Download payment code " "curl -L -s -o /tmp/payment.zip https://github.com/roboshop-devops-project/payment/archive/main.zip"
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip"
rm -rf /home/roboshop/payment && cd /home/roboshop && unzip /tmp/payment.zip && mv payment-main payment
stat $?

Print "Install the dependencies" "pip3 install -r requirements.txt"
cd /home/roboshop/payment
pip3 install -r requirements.txt &>> /tmp/${COMPONENT}.log
stat $?

Print "Update User details in Payment script" 'sed -i -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c gid=${GROUP_ID}" /home/roboshop/payment/payment.ini'
USER_ID=$(id -u roboshop)
GROUP_ID=$(id -g roboshop)
sed -i -e "/^uid/ c uid=${USER_ID}" -e "/^gid/ c gid=${GROUP_ID}" /home/roboshop/payment/payment.ini
stat $?

chown roboshop:roboshop /home/roboshop -R

Print "Update SystemD Script for Payment" 'sed -i -e "s/CARTHOST/cart-ss.devopsb54.tk/" -e "s/USERHOST/user-ss.devopsb54.tk/" -e "s/AMQPHOST/rabbitmq-ss.devopsb54.tk/" /home/roboshop/payment/systemd.service '
sed -i -e "s/CARTHOST/cart.manojtestdmn.tk/" -e "s/USERHOST/user.manojtestdmn.tk/" -e "s/AMQPHOST/rabbitmq.manojtestdmn.tk/" /home/roboshop/payment/systemd.service
stat $?

Print "Start Payment Service" "mv /home/roboshop/payment/systemd.service  /etc/systemd/system/payment.service && systemctl daemon-reload && systemctl enable payment && systemctl start payment"
mv /home/roboshop/payment/systemd.service  /etc/systemd/system/payment.service && systemctl daemon-reload && systemctl enable payment && systemctl start payment
stat $?










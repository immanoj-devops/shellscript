#!/bin/bash

set -e

COMPONENT=user

source Components/common.sh

Print "yum install nodejs make gcc-c++ -y" "Installing nodeJS" "${COMPONENT}"
yum install nodejs make gcc-c++ -y &> /tmp/user.log

Print "Adding roboshop user" "useradd roboshop" ${COMPONENT}""
id roboshop || useradd roboshop
stat $?

Print  "Extract user Component Code" "rm -rf /home/roboshop/user && cd /home/roboshop && unzip /tmp/user.zip && mv /home/roboshop/user-main /home/roboshop/user && cd /home/roboshop/user"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>> /tmp/user.log
rm -rf /home/roboshop/user && cd /home/roboshop && unzip /tmp/user.zip && mv /home/roboshop/user-main /home/roboshop/user && cd /home/roboshop/user
npm install  --unsafe-perm &>> /tmp/user.log
stat $?

chown roboshop:roboshop /home/roboshop -R

Print "Updating REDIS & Mongo Endpoint on userConfig" "systemctl daemon-reload && systemctl start user && systemctl enable user" "${COMPONENT}"
sed -i -e s/REDIS_ENDPOINT/redis.manojtestdmn.tk/ /home/roboshop/user/systemd.service
sed -i -e s/MONGO_ENDPOINT/mongodb.manojtestdmn.tk/ /home/roboshop/user/systemd.service
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service
systemctl daemon-reload && systemctl restart user && systemctl enable user
stat $?
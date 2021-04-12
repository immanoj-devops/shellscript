#!/bin/bash
set -e
echo "Hai Hello Namasthe"
source Components/common.sh
COMPONENT=catalogue
yum install nodejs make gcc-c++ -y &>> /tmp/${COMPONENT}.log

Print "Adding RoboShop Project User" "useradd roboshop"
id roboshop || useradd roboshop
stat $?

Print "Downloading Catalogue" "curl -s -L -o /tmp/catalogue.zip 'https://github.com/roboshop-devops-project/catalogue/archive/main.zip'" "$COMPONENET"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
rm -rf /home/roboshop/catalogue/ && cd /home/roboshop && unzip /tmp/catalogue.zip && mv catalogue-main catalogue && cd /home/roboshop/catalogue/

echo HELLO
stat $?

Print "Installing npm" "npm install" "${COMPONENT}"
npm install --unsafe-perm &>> /tmp/${COMPONENT}.log
echo HAI
stat $?

chown roboshop:roboshop /home/roboshop/ -R
echo doubt
stat $?

echo "Updating the mongodb details in catalogue serviced"
Print  "sed -i -e 's/MONGO_DNSNAME/ssltest.manojtestdmn.tk/' /home/roboshop/catalogue/systemd.service" "mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service" "${COMPONENT}"
sed -i -e "s/MONGO_DNSNAME/mongodb.manojtestdmn.tk/" "/home/roboshop/catalogue/systemd.service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
Print "Catalogue service started" "Good with mongoDB and Catalogue connection "
stat $?
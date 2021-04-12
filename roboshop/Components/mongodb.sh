#!/bin/bash
set -e

COMPONENT=mongodb

source Components/common.sh

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
stat $?

Print "Installing MongoDB" "yum install -y mongodb-org" "${COMPONENT}"
yum install -y mongodb-org  &>> /tmp/${COMPONENT}.log
stat $?

Print "Update Mongo DB Config" "sed"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat $?


systemctl restart mongod
Print "Start MongoDB Service" "systemctl start mongodb" "${COMPONENT}"
systemctl enable mongod && systemctl start mongod
stat $?

#Every Database needs the schema to be loaded for the application to work.
#Download the schema and load it.
Print "Download MongoDB Schema" 'curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"'

Print "Downloading schema" "Injecting Schema" "${COMPONENT}"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"  &> /tmp/frontend.log
cd /tmp
unzip -o mongodb.zip
cd mongodb-main
mongo < catalogue.js
mongo < users.js
stat ${?}

Print "MonogDB Ready now" "cd /tmp && unzip -o mongodb.zip && mongo < catalogue.js && mongo < users.js "
stat $?


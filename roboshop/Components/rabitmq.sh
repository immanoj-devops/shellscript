#!/bin/bash
set -e
source Components/common.sh
COMPONENT=rabbitmq

Print "configuring rabbit repo " "rabbit repo configured"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &> /tmp/${COMPONENT}.log
stat $?

Print "Install rabbit packages" "yum install rabbitmq-server -y "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
yum install rabbitmq-server -y  &>> /tmp/${COMPONENT}.log
stat $?

Print "Enable and Start rabbit MQ" "systemctl enable rabbitmq && systemctl start rabbitmq "
systemctl enable rabbitmq-server  && systemctl start rabbitmq-server
stat $?

Print "Creating rabbit app users" "rabbitmqctl add_user roboshop"
rabbitmqctl add_user roboshop roboshop123 && rabbitmqctl set_user_tags roboshop administrator && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
stat $?







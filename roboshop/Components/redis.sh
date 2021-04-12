#!/bin/bash
set -e
source Components/common.sh
COMPONENT=redis

Print "install epel-release yum-utils -y" "install redis" "yum-config-manager --enable remi"
yum install epel-release yum-utils -y &> /tmp/${COMPONENT}.log
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>> /tmp/${COMPONENT}.log
yum-config-manager --enable remi && yum install redis -y &>> /tmp/${COMPONENT}.log
stat $?

Print "Update Redis Configuration" "sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
stat $?

Print "systemctl enable redis" "systemctl start redis" "${COMPONENT}"
systemctl enable redis && systemctl restart redis
stat $?




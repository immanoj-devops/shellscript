#!/bin/bash
set -e
source Components/common.sh
COMPONENT=mysql

Print "Updating the mySQL repo"  "Repo Updated"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
stat $?

Print "yum install mysql-community-server -y  "  "systemctl enable mysqld && systemctl start mysqld"
yum remove mariadb-libs -y &>> /tmp/mysql.log
yum install mysql-community-server -y   &>> /tmp/mysql.log
systemctl enable mysqld && systemctl start mysqld
stat $?

MYSQLPWD=$(grep 'temporary password' /var/log/mysqld.log |  awk '{print $NF}')
echo ${MYSQLPWD}

echo "show databases;" | mysql -uroot -ppassword;
if [ $? -ne 0 ]; then
    Print "Connecting to MySQL" "Updating the password to password"
    mysql --connect-expired-password -uroot -p"${MYSQLPWD}"  <<EOF
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'DevOps_@123321';
    uninstall plugin validate_password;
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';
EOF
  stat $?
fi

Print "Downloading the Schema"  "Loading the Schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
unzip -o /tmp/mysql.zip
cd mysql-main
mysql -uroot -ppassword <shipping.sql
stat $?

Print "Schema Loaded" "MySQL is ready to use"




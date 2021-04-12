#!/bin/bash

sudo yum install gettext -y &>/dev/null
COMPONENT=$1


if [ -z "${COMPONENT}" ]; then
       echo "Need input of the component name"
       exit 1
fi

STATE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" --query 'Reservations[*].Instances[*].State.Name' --output text)

if [ "${STATE}" != "running" ]; then
    aws ec2 run-instances --launch-template LaunchTemplateId=lt-0717144b48f3f7db5 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" &>/dev/null
    sleep 10
fi

IP_ADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)

export IP_ADDRESS
export COMPONENT

envsubst < record.json > /tmp/${COMPONENT}.json
cat record.json
aws route53 change-resource-record-sets --hosted-zone-id Z0389593AKK6AGHKDTF2 --change-batch file:///tmp/${COMPONENT}.json

cat /tmp/${COMPONENT}.json

#This is to update the roboshop ansible inventory
PUBLIC_IP_ADDRESS=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
echo "${PUBLIC_IP_ADDRESS}  APP=${COMPONENT}" >> ~/inventory 

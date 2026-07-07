#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
SCRIPT_DIR=$PWD
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
MYSQL_HOST=mysql.solohunting.online

if [ $USERID -ne 0 ]; then
  echo "Run the root level"
  exit 1
fi

VALIDATE(){
   if [ $1 -ne 0 ]; then
    echo "$2...FAILED"
   else
     echo "$2...SUCCESS"
    fi 
           
}
cp $SCRIPT_DIR/rabbitmq.service /etc/yum.repos.d/rabbitmq.repo &>>LOGS_FILE
VALIDATE $? "create systemctl rabbitmq..."

dnf install rabbitmq-server -y &>>LOGS_FILE
VALIDATE $? "installing rabbitmq..."

systemctl enable rabbitmq-server &>>LOGS_FILE
systemctl start rabbitmq-server &LOGS_FILE
VALIDATE $? "Enable And Start rabbitMq"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Created user and given permissions"

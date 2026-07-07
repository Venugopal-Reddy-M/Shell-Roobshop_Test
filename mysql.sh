#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf install mysql-server -y &>>LOGS_FILE
systemctl enable mysqld &>>LOGS_FILE
systemctl start mysqld  &>>LOGS_FILE
VALIDATE $? "Install, enable and start mysql..."
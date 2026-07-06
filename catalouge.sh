#!/bin/bash/

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
mkdir -p $LOGS_FOLDER
VALIDATE(){
    if [ $1 -ne 0 ]; then 
       echo "$2....FAILURE" | tee -a $LOGS_FILE
       exit 1
    else
       echo "$2...SUCCESS" | tee -a $LOGS_FILE
   fi
}
dnf module disable nodejs -y &>>$LOGS_FILE
VALIDATE $? "diseable Nodejs ...."

dnf module enable nodejs:20 -y &>>$LOGS_FILE
VALIDATE $? "enable nodejs-20 ....."
# dnf install nodejs -y
# VALIDATE $? "installing Nodejs ...." 
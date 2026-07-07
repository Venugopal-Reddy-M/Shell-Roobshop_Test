#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
if [ $USERID -ne 0 ]; then
  echo "Run the root level"
  exit 1
fi

mkdir -p $LOGS_FOLDER 


VALIDATE(){
   if [ $1 -ne 0 ]; then
    echo "$2...FAILED"
   else
     echo "$2...SUCCESS"
    fi 
           
}

dnf module disable nodejs -y &>>LOGS_FILE
dnf module enable nodejs:20 -y &>>LOGS_FILE
VALIDATE $? "disable AND Enable nodejs...."

dnf install nodejs -y &>>LOGS_FILE
VALIDATE $? "install nodejs"
id roboshop &>>LOGS_FILE
if [ $? -ne 0 ]; then
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system cart" roboshop &>>LOGS_FILE
   VALIDATE $? "ADD robo cart"
else
  echo -e "cart already exit...$Y SKIPPING $N"
fi 

mkdir -p /app &>>LOGS_FILE
VALIDATE $? "Create app directory"

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip &>>LOGS_FILE
VALIDATE $? "Copy cart code"

cd /app  &>>LOGS_FILE
VALIDATE $? "Moving to app Directory..." 

#this command remove exiting code in app dir
rm -rf /app/* &>>LOGS_FILE
VALIDATE $? "Removeing Existing code..."

unzip /tmp/cart.zip &>>LOGS_FILE
VALIDATE $? "unzip cart code" 

npm install &>>LOGS_FILE
VALIDATE $? "Installing Dependencies..."

cp $SCRIPT_DIR/cart.service /etc/systemd/system/cart.service &>>LOGS_FILE
VALIDATE $? "Created systemctl service"

systemctl enable cart &>>LOGS_FILE
systemctl start cart &>>LOGS_FILE
VALIDATE $? "enable and start cart ...."

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

dnf install python3 gcc python3-devel -y &>>LOGS_FILE
VALIDATE $? "installing python"

id roboshop
if [ $? -ne 0 ]; then
   useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
else
    echo -e "Roboshop user already exit...$Y SKIPPING $N"
fi
mkdir -p /app &>>LOGS_FILE
VALIDATE $? "Create app directory..."

curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip &>>LOGS_FILE
VALIDATE $? "download the payment code..."

cd /app &>>LOGS_FILE
VALIDATE $? "Change dir.."

rm -rf /app/* &>>LOGS_FILE
VALIDATE $? "remove exiting code.."

unzip /tmp/payment.zip  &>>LOGS_FILE
VALIDATE $? "unzip shippong code.."

cd /app 
pip3 install -r requirements.txt &>>LOGS_FILE
VALIDATE $? "install dependencies..."

cp $SCRIPT_DIR/payment.service /etc/systemd/system/payment.service &>>LOGS_FILE
VALIDATE $? "createing systemctl service..."

systemctl daemon-reload &>>LOGS_FILE
systemctl enable payment &>>LOGS_FILE
systemctl start payment &>>LOGS_FILE
VALIDATE $? "deamon, enable and start payment..."

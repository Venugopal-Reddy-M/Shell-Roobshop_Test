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

dnf install maven -y &>>LOGS_FILE
VALIDATE $? "installing maven"

id roboshop
   if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>LOGS_FILE
     VALIDATE $? "Add system user..."
   else
     echo -e "Roboshop user already exit...$Y SKIPPING $N"
   fi

mkdir -p /app &>>LOGS_FILE
VALIDATE $? "Create app directory..."

curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip &>>LOGS_FILE
VALIDATE $? "download the shipping code..."

cd /app &>>LOGS_FILE
VALIDATE $? "Change dir.."

rm -rf /app/* &>>LOGS_FILE
VALIDATE $? "remove exiting code.."

unzip /tmp/shipping.zip  &>>LOGS_FILE
VALIDATE $? "unzip shippong code.."

cd /app 
mvn clean package &>>LOGS_FILE
VALIDATE $? "installing and bulding shipping"

mv target/shipping-1.0.jar shipping.jar 
VALIDATE $? "Moving and clean package"

cp $SCRIPT_DIR/shipping.service /etc/systemd/system/shipping.service &>>LOGS_FILE
VALIDATE $? "created systemctl service.."

dnf install mysql -y &>>LOGS_FILE
VALIDATE $? "mysql installing.."

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql 
mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql

systemctl enable shipping
systemctl start shipping
VALIDATE $? "Enable And Start..."

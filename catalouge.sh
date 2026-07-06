#!/bin/bash/

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.solohunting.online"

if [ $USERID -ne 0 ]; then
  echo "Run the root level"
  exit 1
fi
mkdir -p $LOGS_FOLDER &>>LOGS_FILE
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

dnf install nodejs -y &>>$LOGS_FILE
VALIDATE $? "installing Nodejs ...." 

id roboshop &>>LOGS_FILE
   if [ $? -ne 0 ]; then
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOGS_FILE
     VALIDATE $? "Add system user..."
   else
     echo -e "Roboshop user already exit...$Y SKIPPING $N"
   fi
mkdir -p /app &>>$LOGS_FILE
VALIDATE $? "create app directory"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOGS_FILE
VALIDATE $? "Download catalouge code..."

cd /app &>>LOGS_FILE
VALIDATE $? "Moving to app Directory..." 

rm -rf /app/*
VALIDATE $? "Removeing Existing code..."

unzip /tmp/catalogue.zip &>>LOGS_FILE
VALIDATE $? "unzip catalouge the code..."

npm install &>>LOGS_FILE
VALIDATE $? "Installing Dependencies.."

cp $SCRIPT_DIR/catalouge.service /etc/systemd/system/catalogue.service &>>LOGS_FILE
VALIDATE $? "Created systemctl service"

systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue
VALIDATE $? "Start AND Enabling Catalouge.."

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGS_FILE
dnf install mongodb-mongosh -y

mongosh --host $MONGODB_HOST </app/db/master-data.js &>>LOGS_FILE
VALIDATE $? "master data loaded..."

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    VALIDATE $? "LOADING PRODUCTS"
else
  echo "PRODUCTS ALREADY LOADED ..."
fi

systemctl restart catalogue &>>LOGS_FILE
VALIDATE $? "Restart catalogue"
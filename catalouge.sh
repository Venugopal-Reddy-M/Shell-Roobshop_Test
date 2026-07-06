#!/bin/bash/

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
  echo "Run the root level"
  exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]; then 
       echo "$2....FAILURE"
       exit 1
    else
       echo "$2...SUCCESS"
   fi
}
dnf module disable nodejs -y
VALIDATE $? "diseable Nodejs ...."

dnf module enable nodejs:20 -y
VALIDATE $? "enable nodejs-20 ....."
# dnf install nodejs -y
# VALIDATE $? "installing Nodejs ...." 
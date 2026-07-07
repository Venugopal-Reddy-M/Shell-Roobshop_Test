#!/bin/bash/

USERID=$(id -u)

if [ USERID -ne 0 ]; then
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

dnf module disable nodejs -y
VALIDATE $? "disable nodejs..."


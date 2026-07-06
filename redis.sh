#!/bin/bash/

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
 echo "Run root level"
 exit 1
fi
VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2....FAILED"
        exix 1
    else
     echo "$2....Success"
    fi
    }

if [ $? -ne 0 ]; then
   dnf module disable redis -y
   VALIDATE $? "Disable redis..."
else 
 echo "disable redis already"
fi

if [ $? -ne 0 ]; then
  dnf module enable redis:7 -y
  VALIDATE $? "Enable redis..."
else
  echo "Enable redis...alredy"
fi  
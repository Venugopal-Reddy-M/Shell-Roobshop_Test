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

dnf module disable redis -y
VALIDATE $? "Disable redis..."
#!/bin/bash/

USERID=$(id -u)
CONFIC_REDIS=/etc/redis/redis.conf

if [ $USERID -ne 0 ]; then
 echo "Run root level"
 exit 1
fi
VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2....FAILED"
        exit 1
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

   dnf install redis -y 
   VALIDATE $? "Installing redis..."

mkdir -p $CONFIC_REDIS

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
VALIDATE $? "Allowing remote"

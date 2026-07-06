#!/bin/bash/

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
#CONFIC_REDIS=/etc/redis/redis.conf
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
 echo "Run root level"
 exit 1
fi
mkdir -p $LOGS_FOLDER
    if [ $1 -ne 0 ]; then
        echo "$2....FAILED" |tee -a $LOGS_FILE
        exit 1
    else
     echo "$2....Success" | tee -a $LOGS_FILE
    fi
    }

if [ $? -ne 0 ]; then
   dnf module disable redis -y &>>LOGS_FILE
   VALIDATE $? "Disable redis..."
else 
 echo -e "disable redis already....$Y Skiping $N"
fi

if [ $? -ne 0 ]; then
  dnf module enable redis:7 -y &>>LOGS_FILE
  VALIDATE $? "Enable redis..."
else
  echo -e "Enable redis alredy...$Y skiping $N"
fi  

dnf install redis -y &>>LOGS_FILE
VALIDATE $? "Installing redis..." 

#mkdir -p $CONFIC_REDIS

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>LOGS_FILE
VALIDATE $? "Allowing remote..."

systemctl enable redis &>>LOGS_FILE
systemctl start redis &>>LOGS_FILE
VALIDATE $? "enable and start.... "

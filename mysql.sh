#!/bin/bash
USERID=$(id -u)
R="\e[32m"
G="\e[33m"
Y="\e[34m"
N="\e[0m"

LOGS_FOLDER="/var/log/shellscript-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R failuere $N"
        exit 1
    else 
        echo -e "$2.... $G success $N"
    fi
}

CHECK_ROOT(){
if [ $USERID -ne 0 ]
then
   echo "ERROR:: you must have sudo access to execute this script"
   exit 1
fi 
}

echo "script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "insatalling mysql server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "enabling mysql server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "starting mysql server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "setting root password"


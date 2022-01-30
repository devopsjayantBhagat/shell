#!/bin/bash
#Techl It services

#Storing variables for distinguishing backup names according to date.

datetime_var="$(date +"%d-%m-%y_%H_%M")"
month="$(date +"%B")"
year="$(date +"%Y")"
name="$(date +"Date_%d_Time_%H_%M")"

#Database Credentials.
user="root"
pass="#########"

#Auto creation of Directory according to the month and year.
mkdir -p /backup/$year/$month/$name

#Delay for directory Creation.
sleep 1

#Variable for storing the list of existing databases.
dblist=`mysql --user=$user --password=$pass -e "SHOW DATABASES;" | grep -v Database | grep -v information_schema | grep -v performance_schema | grep -v mysql`

#Loop to read the list of databases line by line stored in variable dblist.
for db in $dblist; do
    #Message to be given in the output while dumping is under process.
    echo "dumping database:$db...."

    #Command to create the dump of the databases.
    mysqldump --opt --user=$user --password=$pass --routines $db > /backup/$year/$month/$name/$db.sql

    #Delay for dump creation.
    sleep 2

    #Zipping the dump file.
    gzip /backup/$year/$month/$name/$db.sql
done
#ssh comparesoft@198.1.92.179 "mkdir -p ~/backup/$year/$month/$name/"

cd /backup/$year/$month/$name

cp -rv *gz  /www/vhosts/comparedthin/app/webroot/backup

#This is for remote executing Shell to download gzip file
ssh -p3768 root@123.23.22.22 "cd ~/.jayant; ./bkp.sh;"
rm -rf /www/vhosts/mydomain.com/app/webroot/backup/*
#Display Path where dump has been stored
echo "Please visit the link below to access dump files:-"
echo "/backup/$year/$month/$name/"

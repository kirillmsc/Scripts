#!/bin/bash

echo "Subject for grep?"
read $1
echo "Subject for second grep?"
read $2
echo "Where I shall grep?"
read $3
echo "What date I shall grep?"
read $4
echo "On what e-mail I shall send results of grep?"
read $5
echo "Ok"
date=$(date +%Y%m%d%s)
zgrep $1 /mnt/maillogs/mlogman13/var/logman/$2/$3 |grep $4 > ~/$1_$date.txt
cat $1_$date.txt | mail -s "TASK(!!) $1_$4 " -a ~/$1_$date.txt $5
line=`cat $1_$date.txt | wc -l`
curl -d "text=$1 - Done! Found $line strings. Check E-Mail to see results of the task" http://sms.ru/sms/send\?api_id= ****API_KEY****\&to=****PHONE_NUMBER****
 
 
#$1 - объект грепа
#$2 - место грепа (место указывается после директории /mnt/maillogs/mlogman13/var/logman/ )
#$3 - дата грепа (много архивов с разными датами)
#$4 - второй греп 
#$5 - E-Mail для отправки результатов
## API_KEY можно получить на сайте 
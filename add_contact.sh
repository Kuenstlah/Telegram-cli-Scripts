#!/bin/bash

#1 Nummer
#2 Berechtigung
#3 Name

if [ "$#" -ne 3 ];then
	echo "Usage: $0 NR ACCESSRIGHTS NAME"
	exit 1
fi

#echo /home/pi/tg/bin/telegram-cli -k /home/pi/tg/tg-server.pub -W -e \"add_contact $1 $2 $3\"
echo "add_contact $1 "$2" $3" | nc localhost 54621

if [[ $? == 0 ]];then
	echo "Success"
else
	echo "Error <$?>"
fi

#!/bin/sh

# This script downloads the latest file of a specific FTP diretory and sends it to a TG contact


# Path to TG scripts folder
cfg_path=/home/pi/tg/scripts/
cd $cfg_path
. $cfg_path/latest_ftp_file.config

TG_USER=$1
[ -z $TG_USER ] && echo "Error - No user set <$TG_USER>" && exit
[ -f $TMP_FILE ] && rm -f $TMP_FILE

# Get file from directory; sorted by modification date
#ftp -n $HOST > $TMP_FILE <<fin 
#quote USER $USER
#quote PASS $PASSWD
#cd $DIRECTORY
#ls -1t
#quit
#fin

#FILE=`cat $TMP_FILE|head -n1`
FILE="A16111722490512.jpg"
DIRECTORY="Kamera/20161117/images"
[ -f $TMP_FILE ] && rm -f $TMP_FILE

# Download file
ftp -n $HOST <<fin
	quote USER $USER
	quote PASS $PASSWD
	cd $DIRECTORY
	get $FILE /tmp/$FILE
	quit
fin

if [ -f "/tmp/$FILE" ];then
	$cfg_path/sendmsg.sh $TG_USER "Image from $DATE"
	$cfg_path/sendphoto.sh $TG_USER "/tmp/$FILE"
	#rm -f /tmp/$FILE
else
	echo "Error - Can't get image"
	#$cfg_path/sendmsg.sh $TG_USER "Error - Can't get image"
fi

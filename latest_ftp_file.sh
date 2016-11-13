#!/bin/sh

# This script downloads the latest file of a specific FTP diretory.

cfg_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. $cfg_path/latest_ftp_file.config

TG_USER=$1
[ -z $TG_USER ] && echo "Error - No user set <$TG_USER>" && exit
[ -f $TMP_FILE ] && rm -f $TMP_FILE

# get listing from directory sorted by modification date
ftp -n $HOST > $TMP_FILE <<fin 
quote USER $USER
quote PASS $PASSWD
cd $DIRECTORY
ls -1t
quit
fin

FILE=`cat $TMP_FILE|head -n1`
[ -f $TMP_FILE ] && rm -f $TMP_FILE

# go back and get the file(s)
ftp -n $HOST <<fin 
	quote USER $USER
	quote PASS $PASSWD
	cd $DIRECTORY
	get $FILE
	quit
fin

echo "msg $TG_USER \"Image from $DATE\"" | nc localhost 54621
echo "send_file $TG_USER $cfg_path/$FILE" | nc localhost 54621

[ -f $FILE ] && rm -f $FILE

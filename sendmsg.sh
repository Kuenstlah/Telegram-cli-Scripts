#!/bin/bash
#telegram-cli -k /home/pi/tg/tg-server.pub -W -e "msg $1 $2"
echo "msg $1 "$2"" | nc localhost 54621

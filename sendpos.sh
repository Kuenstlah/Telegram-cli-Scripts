#!/bin/bash
#telegram-cli -k /home/pi/tg/tg-server.pub -W -e "msg $1 $2"
# 1 = empf
# 2 = latitude
# 3 = longitutde
echo "send_location $1 $2 $3" | nc localhost 54621

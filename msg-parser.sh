#!/bin/bash

#######################
# Config
#######################
empf=$2
port=54621
cmd="nc.traditional -w 1 127.0.0.1 $port 2>/dev/null"

function map_status
{
	tmp=`ps aux|grep -v grep |grep runserver.py`
	if [[ $? == 0 ]];then
		echo "msg $empf "### Map is running!"" | $cmd
	else
		echo "msg $empf "### No map is running!"" | $cmd
	fi
}
######################
# Main
######################
# Convert to lower capitals
msg="${1,,}"

level=${empf:0:1}
case $msg in
	ping)
		echo "msg $empf Pong" | $cmd
	;;
	uptime)
		echo "msg $empf "$(uptime)"" | $cmd
	;;
        status)
                echo "msg $empf "Access level: $level \(1 = Admin\)"" | $cmd
        ;;
        s|ps|pgospawn)
		echo "msg $empf "### The classical spawn does not exist anymore! Please use one of the following commands:"" | $cmd
		echo "msg $empf "### [sh] - Pokespawns in H"" | $cmd
		echo "msg $empf "### [sg] - Pokespawns in G"" | $cmd
		echo "msg $empf "### [st] - Pokespawns in Tmp"" | $cmd
        ;;
        sh|psh|pgospawnh)
                echo "msg $empf "### Searching, please wait..."" | $cmd
                `/home/pi/pokemon/pogo/checkdb.pl spawn_h $empf`
                echo "msg $empf "### Done. Good luck!"" | $cmd
        ;;
        sg|psg|pgospawng)
                echo "msg $empf "### Searching, please wait..."" | $cmd
                `/home/pi/pokemon/pogo/checkdb.pl spawn_g $empf &`
                echo "msg $empf "### Done. Good luck!"" | $cmd
        ;;
        st|pst|pgospawnt)
                echo "msg $empf "### Searching, please wait..."" | $cmd
                `/home/pi/pokemon/pogo/checkdb.pl spawn_tmp $empf &`
                echo "msg $empf "### Done. Good luck!"" | $cmd
        ;;
	stats)
		if [[ $level == 1 ]];then
			echo "msg $empf "### Usage of commands:"" | $cmd
			echo "msg $empf "`/home/pi/tg/scripts/stats.sh`"" | $cmd
		else
                        echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
                fi
	;;
 	mapstart)
		if [[ $level == 1 ]];then
				echo "msg $empf "### Starting map, please wait..."" | $cmd
				/home/pi/scripts/pogo/start.sh
				echo "msg $empf "### Done"" | $cmd
		else
			echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
		fi
        ;;
        mapstop)
                if [[ $level == 1 ]];then
                                echo "msg $empf "### Stopping map, please wait..."" | $cmd
                                killall screen
                                echo "msg $empf "### Done"" | $cmd
                else
                        echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
                fi
        ;;
	c|camera|k|kamera|w|webcam)
		if [[ $level == 1 ]];then
			echo "msg $empf "Trying to get latest picture.."" | $cmd
			# Trigger a snapshot via motion from local webcam
			#curl -s -o /dev/null http://localhost:8080/0/action/snapshot
			#sleep 1
			#echo "send_photo $empf /home/pi/webcam/lastsnap.jpg" | $cmd
			/home/pi/tg/scripts/latest_ftp_file.sh $empf
		else
			echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
		fi
	;;
        raspi-reboot)
                if [[ $empf == "1_Kuenstlah" ]];then
			echo "msg $empf "Rebooting now"" | $cmd
	                reboot
		else
			echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
		fi
        ;;

        h|hilfe)
                echo -e "msg $empf "Tell me following [words] or [shortcuts]:"" | $cmd
                echo -e "msg $empf "status - Shows your access level"" | $cmd
                echo -e "msg $empf "uptime - Shows uptime"" | $cmd
                echo -e "msg $empf "stats - Shows usage of commands"" | $cmd
                echo -e "msg $empf "[w]ebcam - Live picture from webcam"" | $cmd
                echo -e "msg $empf "[raspi-reboot] - Restarts the server"" | $cmd
                echo -e "msg $empf "[s]pawn - Show current spawns"" | $cmd
		echo -e "msg $empf "[mapstart/stop] - Start/Stops Map"" | $cmd
#                echo -e "msg $empf "[Map LOCATION]- Restarts the map with desired location."" | $cmd
        ;;
	*)
		echo "msg $empf 'I don't know this command, please write 'h' or 'help''" | $cmd
	;;
esac

echo "`date` ; <$2> <$msg>" >> /var/log/telegram.lua.log

exit 0

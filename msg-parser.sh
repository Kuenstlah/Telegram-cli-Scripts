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
	p|ping)
		echo "msg $empf Pong" | $cmd
	;;
	u|uptime)
		echo "msg $empf "$(uptime)"" | $cmd
	;;
        st|status)
                echo "msg $empf "Access level: $level \(1 = Admin\)"" | $cmd
        ;;
        s|ps|pgospawn)
		echo "msg $empf "### The classical spawn does not exist anymore! Please use one of the following commands:"" | $cmd
		echo "msg $empf "### [sh] - Pokespawns in Hilden"" | $cmd
                echo "msg $empf "### [sa] - Pokespawns in America"" | $cmd
                echo "msg $empf "### [sg] - Pokespawns in Garath"" | $cmd
        ;;
        sh|psh|pgospawnh)
                echo "msg $empf "### Searching in Hilden, please wait..."" | $cmd
                `/home/pi/pokemon/checkdb.pl spawn_hilden $empf &`
                echo "msg $empf "### Done. Good luck!"" | $cmd
        ;;
        sa|psa|pgospawna)
                echo "msg $empf "### Searching in America, please wait..."" | $cmd
                `/home/pi/pokemon/checkdb.pl spawn_america $empf &`
                echo "msg $empf "### Done. Good luck!"" | $cmd
        ;;
        sg|psg|pgospawng)
                echo "msg $empf "### Searching in Garath, please wait..."" | $cmd
                `/home/pi/pokemon/checkdb.pl spawn_garath $empf &`
                echo "msg $empf "### Done. Good luck!"" | $cmd
        ;;
 	map|map*)
		if [[ $level == 1 ]];then
				location=`echo $msg |awk -F ' ' {'print $2'}`
				if [[ $location == "status" ]];then
					map_status
				else
					echo "msg $empf "### Restarting map, please wait..."" | $cmd
					/home/pi/restart_pokemon.sh -l "$location"
					echo "msg $empf "### Done. Set position to $location! Please do not use this function for the next 2 minutes."" | $cmd
					map_status
				fi
		else
			echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
		fi
        ;;
	c|camera|k|kamera|w|webcam)
		if [[ $level == 1 ]];then
			echo "msg $empf "Give me a second to spy.."" | $cmd
			# Trigger a snapshot via motion from local webcam
			curl -s -o /dev/null http://localhost:8080/0/action/snapshot
			sleep 1
			echo "send_photo $empf /home/pi/webcam/lastsnap.jpg" | $cmd
		else
			echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
		fi
	;;
        pir|raspi-reboot)
                if [[ $empf == "1_Kuenstlah" ]];then
			echo "msg $empf "Rebooting now"" | $cmd
	                reboot
		else
			echo "msg $empf "Sorry, your accesslevel \($level\) is too low."" | $cmd
		fi
        ;;

        h|hilfe)
                echo -e "msg $empf "Tell me following [words] or [shortcuts]:"" | $cmd
                echo -e "msg $empf "[st]atus - Shows your access level"" | $cmd
                echo -e "msg $empf "[w]ebcam - Live picture from webcam"" | $cmd
                echo -e "msg $empf "ras[pi]-[r]eboot - Restarts the server"" | $cmd
                echo -e "msg $empf "[s]pawn - Show currently spawned Pokemons"" | $cmd
                echo -e "msg $empf "[Map LOCATION]- Restarts the map with desired location."" | $cmd
        ;;
	*)
		echo "msg $empf 'I don't know this command, please write 'h' or 'help''" | $cmd
	;;
esac

echo "`date` ; <$2> <$1>" >> /var/log/telegram.lua.log

exit 0

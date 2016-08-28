#!/bin/bash

#######################
# Config
#######################
empf=$2
port=54621
cmd="nc.traditional -w 1 127.0.0.1 $port 2>/dev/null"

######################
# Main
######################
# Convert to lower capitals
msg="${1,,}"


if [ "$1" == "spawn" ] && [ ! -z "$3" ];then
	search_pokemon=$3
fi



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
		echo "msg $empf "### Searching, please wait..."" | $cmd
		`/home/pi/pokemon/checkdb.pl spawn $empf &`
		echo "msg $empf "### Done. Good luck!"" | $cmd
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
                echo -e "msg $empf "Tell me following [words] or [shortcuts]: [st]atus \| Live picture from [w]ebcam \| ras[pi]-[r]eboot \| Currently spawned Pokemons: [s]pawn"" | $cmd
        ;;
	*)
		echo "msg $empf 'I don't know this command, please write 'h' or 'help''" | $cmd
	;;
esac

exit 0

#/bin/bash
#cat /var/log/telegram.lua.log |egrep '<k>|<sh>|<sg>|<sr>|<sa>'|awk -F ';' '{print $2}'|sort|uniq -c|sort
cat /var/log/telegram.lua.log |egrep '<k>|<sh>|<sg>|<sr>|<sa>'|sed 's/<//g'|sed 's/>//g'|awk -F ';' '{print $2}'|sort|uniq -c|awk -F ' ' {'print $2"-"$3":"$1""'}|awk -F '_' '{print $2}'|sort -k2 -n -t':' -r|tr '\n' ' - '

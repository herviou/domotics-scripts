#!/bin/bash


# permet de faire switcher l'interrupteur de nom "SWITCH_NAME"
# une requete sqlite permet de récupérer l'idx de SWITCH_NAME pour forger la requete
# script:///home/pi/domoticz/scripts/switch_planning.sh disabletimer 

res="/tmp/domoticz-switch-planning-`date -Ins`"
base_url="http://192.168.0.101/"
idx=`echo 'select ID from DeviceStatus where DeviceStatus.Name like ' '"'$2'"' ';' | sqlite3 -noheader /home/pi/domoticz/domoticz.db`

curl -v "${base_url}json.htm?type=timers&idx=$idx" | grep "idx" | cut -f "2" -d ":" | sed -e "s| ||g" | sed -e "s|\"||g" > $res

cat $res

while read line
do
 curl -v "${base_url}json.htm?type=command&param=$1&idx=$line"
done < $res

rm ${res}

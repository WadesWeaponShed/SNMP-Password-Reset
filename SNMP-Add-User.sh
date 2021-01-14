#!/bin/bash
source /opt/CPshrd-R80/tmp/.CPprofile.sh
printf "\nGathering CMA Info\n"
for CMA_NAME in $($MDSVERUTIL AllCMAs);
do
  $MDSVERUTIL CMAIp  -n $CMA_NAME >> CMA-IP.txt
done

printf "\nBuilding SNMP Reset Commands per CMA. Be Patient...\n"
for I in $(cat CMA-IP.txt)
do
  mgmt_cli -d $I -r true show gateways-and-servers details-level full limit 500 --format json |jq -r --arg q "'" --arg w '"' --arg i $I '.objects[] | select(.type == "simple-gateway") | "mgmt_cli -d " + $i + "  -s id.txt run-script script-name SNMP script " + $q + "clish -c " + $w + "add snmp usm user NAME authPriv auth-pass-phrase vpn123456 privacy-pass-phrase vpn123456 privacy-protocol AES256 authentication-protocol SHA256;service snmpd restart" +$w + $q + " targets " + .name' >>$CMA_NAME-update-snmp.txt
  sed -i "1s/^/mgmt_cli -d $DOMAIN -r true login > id.txt\n/" $CMA_NAME-update-snmp.txt
  sed -i '1s/^/echo Deleting objects do not stop script\n/' $CMA_NAME-update-snmp.txt
  echo "mgmt_cli -s id.txt publish" >> $CMA_NAME-update-snmp.txt
  echo "mgmt_cli -s id.txt logout" >> $CMA_NAME-update-snmp.txt
done

rm CMA-IP.txt
printf "\nYou now have reset files starting with the CMA name\n"

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
  mgmt_cli -d $I -r true show gateways-and-servers details-level full limit 500 --format json |jq -r --arg q "'" --arg w '"' --arg i $I '.objects[] | select(.type == "simple-gateway") | "mgmt_cli -d " + $i + "  -r true run-script script-name SNMP script " + $q + "clish -c " + $w + "set snmp usm user sts security-level authPriv auth-pass-phrase vpn123456 privacy-pass-phrase vpn123456 privacy-protocol AES authentication-protocol SHA1" +$w + $q + " targets " + .name' >>$CMA_NAME-update-snmp.txt
done

rm CMA-IP.txt
printf "\nYou now have reset files starting with the CMA name\n"

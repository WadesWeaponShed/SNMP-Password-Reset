This script can be used to change the SNMP password on all of the gateways from the MDS.


## How to Use ##
- cp script over to mgmt station (this script is intended to run directly on the mgmt station)
- The password in the file is set to vpn123456 you will need to modify to whatever your new password will be.
- execute ./SNMP-Pass-Resert.sh
- It will output files per CMA Name with commands for each gateway. You can chmod the files and make them executable if you wish and then execute ./file-name all files are named $CMA_NAME-update-snmp.txt

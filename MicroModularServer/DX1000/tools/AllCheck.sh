#!/bin/bash

if [ $# -ne 1 ]; then
 echo "Error ./AllCheck.sh CMM_Master_IP";
 exit 1;
fi

PING=(`ping -c 1 $1 |grep received |cut -d " " -f4`)
if [ $PING -eq 0 ]; then
 echo "no ping";
 exit 1;
fi

NUM=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 raw 0x30 0x20 |wc -w`)
if [ $NUM -ne 48 ]; then
 echo "Please Input CMM Master IP Address";
 exit 1;
fi

CMMMIP=(`echo $1 |sed "s/\./ /g"`)
NUM0=`echo ${CMMMIP[0]} |wc -m`
NUM1=`echo ${CMMMIP[1]} |wc -m`
NUM2=`echo ${CMMMIP[2]} |wc -m`
NUM3=`echo ${CMMMIP[3]} |wc -m`
NUM=`expr 16 - $NUM0 - $NUM1 - $NUM2 - $NUM3 `
case "$NUM" in
 "0" ) SPACEM=" ";;
 "1" ) SPACEM="  ";;
 "2" ) SPACEM="   ";;
 "3" ) SPACEM="    ";;
 "4" ) SPACEM="     ";;
 "5" ) SPACEM="      ";;
 "6" ) SPACEM="       ";;
 "7" ) SPACEM="        ";;
 "8" ) SPACEM="         ";;
esac

CMMM=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 raw 0x30 0x21 0 0 |tr -d '\n'|sed "s/  */ /g" |cut -d " " -f22-37`)
CMMMMAC1=${CMMM[0]}:${CMMM[1]}:${CMMM[2]}:${CMMM[3]}:${CMMM[4]}:${CMMM[5]}
CMMMMAC2=${CMMM[10]}:${CMMM[11]}:${CMMM[12]}:${CMMM[13]}:${CMMM[14]}:${CMMM[15]}
CMMMFW=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 mc info |grep "Firmware Revision" |sed "s/  */ /g" |cut -d " " -f4`)
CMMMGUID=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 mc guid|grep GUID |sed "s/  */ /g" |cut -d " " -f4`)

CMMSIP=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 raw 0x30 0x21 0xff 0 |tr -d '\n'|sed "s/  */ /g" |cut -d " " -f6-9`)
for j in 0 1 2 3
do
 IP[j]=`printf '%d' 0x${CMMSIP[j]}`
done
CMMSIPAdr=${IP[0]}.${IP[1]}.${IP[2]}.${IP[3]}
CMMS=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 raw 0x30 0x21 0xff 0 |tr -d '\n'|sed "s/  */ /g" |cut -d " " -f22-37`)
CMMSMAC1=${CMMS[0]}:${CMMS[1]}:${CMMS[2]}:${CMMS[3]}:${CMMS[4]}:${CMMS[5]}
CMMSMAC2=${CMMS[10]}:${CMMS[11]}:${CMMS[12]}:${CMMS[13]}:${CMMS[14]}:${CMMS[15]}
PING=(`ping -c 1 $CMMSIPAdr |grep received |cut -d " " -f4`)
if [ $PING -eq 0 ]; then
 CMMSFW="----"
 CMMSGUID="------------------------------------"
else
 if [ ${IP[0]} -ne 0 ]
 then
  CMMSFW=(`ipmitool -I lanplus -U Administrator -P Administrator -H $CMMSIPAdr mc info |grep "Firmware Revision" |sed "s/  */ /g" |cut -d " " -f4`)
  CMMSGUID=(`ipmitool -I lanplus -U Administrator -P Administrator -H $CMMSIPAdr mc guid|grep GUID |sed "s/  */ /g" |cut -d " " -f4`)
 else
  CMMSFW="-----"
  CMMSGUID="------------------------------------"
 fi
fi

NUM0=`echo ${IP[0]} |wc -m`
NUM1=`echo ${IP[1]} |wc -m`
NUM2=`echo ${IP[2]} |wc -m`
NUM3=`echo ${IP[3]} |wc -m`
NUM=`expr 16 - $NUM0 - $NUM1 - $NUM2 - $NUM3 `

case "$NUM" in
 "0" ) SPACE=" ";;
 "1" ) SPACE="  ";;
 "2" ) SPACE="   ";;
 "3" ) SPACE="    ";;
 "4" ) SPACE="     ";;
 "5" ) SPACE="      ";;
 "6" ) SPACE="       ";;
 "7" ) SPACE="        ";;
 "8" ) SPACE="         ";;
esac

echo "SlotNo   IPAddress        [MAC Address]     F/W   BIOS                GUID                     [InternalMAC1]    [InternalMAC2]"
echo "CMM M  $1$SPACEM[$CMMMMAC1]  $CMMMFW  ----  $CMMMGUID  $CMMMMAC2"
echo "CMM S  $CMMSIPAdr$SPACE[$CMMSMAC1]  $CMMSFW  ----  $CMMSGUID  $CMMSMAC2"

SLOT=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 raw 0x30 0x20 |tr "\n" " "|sed "s/  */ /g" |cut -d " " -f3-50`)
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
do
if [ "${SLOT[i]}" = 21 ]
then
 MMC=(`ipmitool -I lanplus -U Administrator -P Administrator -H $1 raw 0x30 0x21 $i 2 |tr -d '\n'|sed "s/  */ /g" |cut -d " " -f6-43`)
 for j in 0 1 2 3
 do
  IP[j]=`printf '%d' 0x${MMC[j]}`
 done
 MAC1=${MMC[16]}:${MMC[17]}:${MMC[18]}:${MMC[19]}:${MMC[20]}:${MMC[21]}
 MAC2=${MMC[26]}:${MMC[27]}:${MMC[28]}:${MMC[29]}:${MMC[30]}:${MMC[31]}
 MAC3=${MMC[32]}:${MMC[33]}:${MMC[34]}:${MMC[35]}:${MMC[36]}:${MMC[37]}

else
 IP=(- - - -)
 MAC1=--:--:--:--:--:--
 MAC2=--:--:--:--:--:--
 MAC3=--:--:--:--:--:--
fi

MMCIP=${IP[0]}.${IP[1]}.${IP[2]}.${IP[3]}

NUM0=`echo ${IP[0]} |wc -m`
NUM1=`echo ${IP[1]} |wc -m`
NUM2=`echo ${IP[2]} |wc -m`
NUM3=`echo ${IP[3]} |wc -m`
NUM=`expr 16 - $NUM0 - $NUM1 - $NUM2 - $NUM3 `

case "$NUM" in
 "0" ) SPACE=" ";;
 "1" ) SPACE="  ";;
 "2" ) SPACE="   ";;
 "3" ) SPACE="    ";;
 "4" ) SPACE="     ";;
 "5" ) SPACE="      ";;
 "6" ) SPACE="       ";;
 "7" ) SPACE="        ";;
 "8" ) SPACE="         ";;
esac

if [ ${IP[0]} = - ] || [ ${IP[0]} -eq 0 ] 
then
 FW=----
 GUID=------------------------------------
 BIOS=----
else
 FW=`ipmitool -I lanplus -U Administrator -P Administrator -H $MMCIP mc info |grep "Firmware Revision" |sed "s/  */ /g" |cut -d " " -f4`
 GUID=`ipmitool -I lanplus -U Administrator -P Administrator -H $MMCIP mc guid|grep GUID |sed "s/  */ /g" |cut -d " " -f4`
 BIOSNUM=(`ipmitool -I lanplus -U Administrator -P Administrator -H $MMCIP raw 0x30 0x08 0x04 0x04|wc -w`)
 if [ $BIOSNUM -ne 5 ]
 then
  BIOS=" NG "
 else
  BIOSORG=(`ipmitool -I lanplus -U Administrator -P Administrator -H $MMCIP raw 0x30 0x08 0x04 0x04|cut -d " " -f3-6`)
  if [ ${BIOSORG[0]} = "ff" ]
  then
   BIOS=" NG "
  else
   BIOS=`expr ${BIOSORG[0]} - 30``expr ${BIOSORG[1]} - 30``expr ${BIOSORG[2]} - 30``expr ${BIOSORG[3]} - 30`
  fi
 fi
fi

if [ $i -lt 10 ]
then
 echo "Slot0$i $MMCIP$SPACE[$MAC1]  $FW  $BIOS  $GUID  $MAC2  $MAC3"
else
 echo "Slot$i $MMCIP$SPACE[$MAC1]  $FW  $BIOS  $GUID  $MAC2  $MAC3"
fi
done

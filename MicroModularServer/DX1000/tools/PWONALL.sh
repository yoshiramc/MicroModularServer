#!/bin/bash
for cmm in mercury1cmm mercury2cmm mercury3cmm
do
grep $cmm /etc/hosts >>/dev/null

if [ $? -ne 0 ]; then
#  echo $cmm
  continue
fi
ip=`grep $cmm /etc/hosts | cut -f 1`
echo $ip
ipmiaw2 $ip raw 0x30 0x40 0xFF 0x01 0x01
#ON:ipmitool -I lanplus -H $cmm -U Administrator -P Administrator raw 0x30 0x40 0xFF 0x01 0x01
done



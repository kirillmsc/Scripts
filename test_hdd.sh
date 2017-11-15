#!/bin/bash

sleep 15;
echo "" > /root/bad;

for sd in /dev/sd*[a-z];
do
	SMART=$(smartctl -a $sd | grep "Serial Number\|Reallocated_Sector\|Reallocated_Event\|Hours\|Pending")
	REALS=$(echo $SMART | awk '{print $13}');		#realoc
	REALE=$(echo $SMART | awk '{print $33}');		#realoc
	HOURS=$(echo $SMART | awk '{print $23}');		#work on Hours
	PENDI=$(echo $SMART | awk '{print $43}');		#pendings
	SERIAL=$(echo $SMART |  awk '{print $3}');
if  [ "$REALS" == 0 ] && [ "$REALE" == 0 ] && [ "$HOURS" -le 50000 ] && [ "$PENDI" == 0 ] && [ "$sd" == "/dev/sda" ];
then
echo "sda" ;
elif [ "$REALS" == 0 ] && [ "$REALE" == 0 ] && [ "$HOURS" -le 50000 ] && [ "$PENDI" == 0 ];
then
echo "$SERIAL: $REALS; $REALE; $HOURS; $PENDI" >> /root/good;
else
echo "BAD - $SERIAL: $REALS; $REALE; $HOURS; $PENDI" >> /root/bad;
dd if=$sd of=/dev/null bs=1M count=2000; #подсветка "плохих" дисков
fi
#файлы good & bad лучше мониторить командой "tail" в двух разных окнах терминала
done

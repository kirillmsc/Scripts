#!/bin/bash

toend=$(tput hpa $(tput cols))$(tput cub 6)
echo "" > bad;
echo "" > good;

for sd in /dev/sd*[a-z];
	do
		SMART=$(smartctl -a $sd | grep "Serial Number\|Reallocated_Sector\|Reallocated_Event\|Hours\|Pending")
		REALS=$(echo $SMART | awk '{print $13}');		#realoc
		REALE=$(echo $SMART | awk '{print $33}');		#realoc
		HOURS=$(echo $SMART | awk '{print $23}');		#work on Hours
		PENDI=$(echo $SMART | awk '{print $43}');		#pendings
		SERIAL=$(echo $SMART |  awk '{print $3}');
	if
			[ "$sd" == "/dev/sda" ];
		then
			continue ;
		elif
			SPEED=$(dd if=$sd of=/dev/null bs=1M count=1000 |& grep "1.0 GB" | awk -F " " '{print $8}');   # speed i/o
			[ "$REALS" == 0 ] && [ "$REALE" == 0 ] && [ "$HOURS" -le 50000 ] && [ "$PENDI" == 0 ] && (( "$SPEED" > "100" ));
		then
			echo "$sd — $SERIAL: reallock: $REALS, $REALE; work — $HOURS; pendings — $PENDI; speed — $SPEED;   ${toend}[GOOD]" >> good;
			dd if=$sd of=/dev/null bs=1M count=1000;
	#		dd if=$sd of=/dev/null bs=1M seek=$(( $(blockdev —getsz $sd) - 1 )) count=1000;
		else
			echo "$sd — $SERIAL: reallock: $REALS, $REALE; work — $HOURS; pendings — $PENDI; speed — $SPEED; ${toend}[BAD]" >> bad;
			dd if=$sd of=/dev/null bs=1M count=2000; #подсветка "плохих" дисков
	fi
		#файлы good & bad лучше мониторить командой "tail -f" в двух разных окнах терминала
	done

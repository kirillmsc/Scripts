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
			[ "$REALS" == 0 ] && [ "$REALE" == 0 ] && [ "$HOURS" -le 50000 ] && [ "$PENDI" == 0 ] && [ "$sd" == "/dev/sda" ];
		then
			echo "sda" ;
		elif
			[ "$REALS" == 0 ] && [ "$REALE" == 0 ] && [ "$HOURS" -le 50000 ] && [ "$PENDI" == 0 ];
		then
			$SUCCESS
			echo "$SERIAL: $REALS; $REALE; $HOURS; $PENDI; ${toend}[GOOD]" >> good;
			$NORMAL
		else
			$FAILURE
			echo "BAD - $SERIAL: $REALS; $REALE; $HOURS; $PENDI; ${toend}[BAD]" >> bad;
			dd if=$sd of=/dev/null bs=1M count=2000; #подсветка "плохих" дисков
			$NORMAL
	fi
		#файлы good & bad лучше мониторить командой "tail -f" в двух разных окнах терминала
	done


# tasks:
# Тестирование на скорость чтения / записи по каждому диску
# Запись каждого теста в общие базы (все диски, хорошие, плохие)
# Переезд скрипта с Bash на Python
# Веб-морда для получения информации по дискам (Jango)

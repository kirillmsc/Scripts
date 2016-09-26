#!/bin/bash


hddlog=hdd_sn_log
echo "/dev/sd* " > hd_ignore
if [ ! -f $hddlog ]
then
	for sd in /dev/sd*[a-z]
	do
		echo -n "$sd " >> hdd_sn_log
		hdparm -I $sd | grep "Serial Number" | awk '{print $3}' >> hdd_sn_log
	done
else
	for sd in /dev/sd*[a-z]
	do
		echo -n "$sd " >> hdd_sn_log_tmp
		hdparm -I $sd | grep "Serial Number" | awk '{print $3}' >> hdd_sn_log_tmp
	done
		BADSN=$(sdiff -x hd_ignore hdd_sn_log hdd_sn_log_tmp | grep ">\|<\||" | awk '{print $1}')
		if [-z BADSN] 						# сравнения с нулевым значением
		then
			cat hdd_sn_log_tmp > hdd_sn_log
		else
			echo $BADSN > bad_sn			#перенаправление значения переменной в файл, для того, чтобы приложить файл к таску
			unset BADSN 					#обнуление переменной
		fi
fi


# hdd_sn_log - список серийников всех дисков в сервере с точкой монтирования
# hdd_sn_log_tmp - временный список всех серийников, для сравнения с "хорошими" серийниками из файла  hdd_sn_log
# bad_sn - файл с плохим серийником
# BADSN - переменная хранящая в себе серийник сбойного диска
# grep ">\|<\||"  грепает сразу три параметра:
## | - разница между строками
## < - отсутствует значение в строке в файле справа
## > - отсутствует значение в строке в файле слева
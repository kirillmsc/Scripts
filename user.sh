#!/bin/bash

echo "Enter USERNAME"
read username
echo "$username"
echo "Enter PASSWORD (if you want to generate password for "$username" press ENTER)"
read password
echo "Enter e-mail (script will send you your password"
read $email
#Проверяем пароль на пустоту, если он пустой генерируем рандомный пароль из 8-ми символов (если нужно больше исправить тут (!!)__-c${1:-8}__(!!) )
#Пароль генерируется из заглавных / строчных букв и цифр.
if [ -z "$password" ];
then
	password=$(cat /dev/urandom | tr -dc _A-Z-a-z-0-9 | head -c${1:-8});
	echo "$username $password"
else
	echo "$username $password"
fi
echo "Ok"
useradd $username -p $password -d /$username
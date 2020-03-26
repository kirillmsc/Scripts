#!/bin/bash

ipAddr=$1
ip=$(ipcalc $1 | grep "Address" | awk '{print $2}')
netMask=$(ipcalc $1 | grep "Netmask" | awk '{print $2}')
hostMin=$(ipcalc $1 | grep "HostMin" | awk '{print $2}')

ipmitool lan set 1 ipaddr $ip
ipmitool lan set 1 netmask $netMask
ipmitool lan set 1 defgw ipaddr $hostMin

sleep 10

killall discover
discover

echo "Done! Check."

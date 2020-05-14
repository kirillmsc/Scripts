# Scripts - the collection of usefull shell-scripts for Unix system.

[`test_hdd`](https://github.com/kirillmsc/Scripts/blob/master/test_hdd.sh) - this script can help you find a good HDD, which has no realloc, pending and have a work under 50k hours
Create two files: bad.txt and good.txt
After script finish his work - in file you'll see serial numbers of HDD
----------
[`setup_ipmi`] (https://github.com/kirillmsc/Scripts/blob/master/bash/setup_ipmi.sh) - this script work with this arguments:
— --reset | rename ipmi user (new name ADMIN)
— $1 | IPMI IP-address or hostname if your DNS can return IP by FQDN
- $2 | (optional) NETMASK IP, if empty - 255.255.255.0
- $3 | (optional) DEFAULT GATEWAY IP, if empty - $1[1].$IP[2].$IP[3].1
#!/bin/bash
ARCH=$(uname -a)
#cpu
CPUS=$(cat /proc/cpuinfo | grep "^cpu cores" | cut -d ':' -f2) 
VCPUS=$(cat /proc/cpuinfo | grep "^processor" | wc -l) 
PERCPU=$(top -bin 1 | grep %Cpu\(s\) | awk '{print $2 + $4}')
#memory
USEDMEM=$(free -m | grep Mem | awk '{print $3}') 
TOTALMEM=$(free -m | grep Mem | awk '{print $2}') 
MEMPER=$(echo "scale=2; $USEDMEM * 100 / $TOTALMEM" | bc -l)
#disk
TOTALDISK=$(df --total -h | grep total | awk '{print $2}')b
USEDDISK=$(df --total -m | grep total | awk '{print $3}')
PERDISK=$(df --total -h | grep total | awk '{print $5}')
#boot time
DATEBOOT=$(who -b | awk '{print $3}')
HOURBOOT=$(who -b | awk '{print $4}')
#lvm
[[ $(lsblk | awk '{print $6}' | grep lvm | wc -l) == "0" ]] && {
    ISLVMUP=no
}
[[ $(lsblk | awk '{print $6}' | grep lvm | wc -l) != "0" ]] && {
    ISLVMUP=yes
}
#networks
TCPCON=$(ss -t | grep ESTAB | wc -l)
IP=$(ip a | grep "inet " | tail -n 1 | awk '{print $2}' | cut -d '/' -f1)
MAC=$(ip a | grep "ether" | awk '{print $2}')
#user log
USERLOG=$(w -h | awk '{print $1}' | uniq | wc -l)
#sudo cmds
SUDOCMDS=$(cat /var/log/sudo/logs | grep COMMAND | wc -l)
wall "	#Architecture: ${ARCH}
	#CPU physical : ${CPUS}
	#vCPU : ${VCPUS}
	#Memory Usage: ${USEDMEM}/${TOTALMEM}MB (${MEMPER}%)
	#Disk Usage: $USEDDISK/$TOTALDISK ($PERDISK)
	#CPU load: $PERCPU%
	#Last boot: $DATEBOOT $HOURBOOT
	#LVM use: $ISLVMUP
	#Connexions TCP : $TCPCON ESTABLISHED
	#User log: $USERLOG
	#Network: IP $IP ($MAC)
	#Sudo : $SUDOCMDS cmd
"

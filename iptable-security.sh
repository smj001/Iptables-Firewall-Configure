#!/bin/bash

iptables-save >> iptables-$(date +%Y-%m-%d-%H-%M)
echo "iptable-save run and store at iptables-$(date +%Y-%m-%d-%H-%M) file"

read -p "Do you want to flush INPUT chain?(y/n)" FLUSH_VERIFY
if [[ $FLUSH_VERIFY == "y" ]]
then
     iptables -F INPUT
fi

for i in $(netstat -ntpl | awk '{ print $4}' | grep -v 18080 | awk -F ":" '{print $NF}' | grep -v "^$" | sort | grep -v [a-z] | uniq)
do
	for j in $(cat ipwhitelist.txt | sed '/^#/d' | sed '/^$/d')
	do
		iptables -A INPUT -p tcp --dport $i -s $j -j ACCEPT
		iptables -A INPUT -p udp --dport $i -s $j -j ACCEPT
	done
    iptables -A INPUT -p tcp --dport $i -j DROP
	iptables -A INPUT -p udp --dport $i -j DROP
done

iptables -A INPUT -s 65.21.13.226 -p ICMP --icmp-type 8 -j ACCEPT
iptables -A INPUT -p ICMP --icmp-type 8 -j DROP

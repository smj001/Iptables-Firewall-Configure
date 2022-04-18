#!/bin/bash

# Backup Form All IPtables rules
iptables-save >> iptables-$(date +%Y-%m-%d-%H-%M)
echo "iptable-save run and store at iptables-$(date +%Y-%m-%d-%H-%M) file"

# Ask for Flush Work Chain or Not, if 'y' iptables in INPUT chain has beeen flush.
read -p "Do you want to flush INPUT chain?(y/n)" FLUSH_VERIFY
if [[ $FLUSH_VERIFY == "y" ]]
then
     iptables -F INPUT
fi

echo "access list:"

# Find all allocated port in system but running netstat -ntpl
for i in $(netstat -ntpl | awk '{ print $4}' | awk -F ":" '{print $NF}' | grep -v "^$" | sort | grep -v [a-z] | uniq)
do
    # export white IPs from ipwhitelist.txt file
	for j in $(cat ipwhitelist.txt | sed '/^#/d' | sed '/^$/d')
	do
        # allow selected ip to access server in port i by tcp connection
		iptables -A INPUT -p tcp --dport $i -s $j -j ACCEPT
        echo "$j --> $i/tcp"
        # allow selected ip to access server in port i by udp connection
		iptables -A INPUT -p udp --dport $i -s $j -j ACCEPT
        echo "$j --> $i/udp"
	done
    # drop all access to server in port i by tcp connection
    iptables -A INPUT -p tcp --dport $i -j DROP
    echo "Drop TCP connections in $i"
    # drop all access to server in port i by udp connection
	iptables -A INPUT -p udp --dport $i -j DROP
    echo "Drop UDP connections in $i"
done

# Drop all ICMP Packets for deny all ping requests.
iptables -A INPUT -p ICMP --icmp-type 8 -j DROP
echo "Drop All ICMP Connections"

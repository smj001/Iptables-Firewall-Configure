# What is this?
It's a bash script that can help you to secure your server by drop all requests by iptables in open ports and open port for ip white list.

# How it works?
## step1:
Clone project on your server

## step2:
Complete `ipwhitelist.txt` from `ipwhitelist.txt.example` file.

## step3:
Run `./iptable-security.sh`


### note:
- This script backup from your iptables-role in file.
- You can use `restore-iptables.service` file for have this script permanently on your server.


ENJOY the world without HAMMALI!

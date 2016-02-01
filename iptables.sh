#!/bin/bash
server="xx.xx.xx.xx"
client="32768:65535" # Ephemeral port range (Windows, Linux) http://www.ncftp.com/ncftpd/doc/misc/ephemeral_ports.html

#vide table fw
	/sbin/iptables -F
	/sbin/iptables -X
	/sbin/iptables -t nat -F
	/sbin/iptables -t nat -X
	/sbin/iptables -t mangle -F
	/sbin/iptables -t mangle -X

#politique fermante
	/sbin/iptables -P INPUT DROP
	/sbin/iptables -P FORWARD DROP
	/sbin/iptables -P OUTPUT DROP

#boucle locale
	/sbin/iptables -A INPUT -i lo -j ACCEPT
	/sbin/iptables -A OUTPUT -o lo -j ACCEPT
	/sbin/iptables -A FORWARD -i lo -j ACCEPT

#requete NTP
	/sbin/iptables -A OUTPUT -o venet0 -p udp -s $server --sport $client -d 0/0 --dport 123 -m state --state NEW,ESTABLISHED -j ACCEPT
	/sbin/iptables -A INPUT -i venet0 -p udp -s 0/0 --sport 123 -d $server --dport $client -m state --state ESTABLISHED -j ACCEPT

#requete cliente dns
	/sbin/iptables -A OUTPUT -o venet0 -p udp -s $server --sport $client -d 0/0 --dport 53 -m state --state NEW,ESTABLISHED -j ACCEPT
	/sbin/iptables -A INPUT -i venet0 -p udp -s 0/0 --sport 53 -d $server --dport $client -m state --state ESTABLISHED -j ACCEPT

#naviguation http/https
	/sbin/iptables -A OUTPUT -o venet0 -p tcp -s $server --sport $client -d 0/0 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
	/sbin/iptables -A INPUT -i venet0 -p tcp -s 0/0 --sport 80 -d $server --dport $client -m state --state ESTABLISHED  -j ACCEPT
	/sbin/iptables -A OUTPUT -o venet0 -p tcp -s $server --sport $client -d 0/0 --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
	/sbin/iptables -A INPUT -i venet0 -p tcp -s 0/0 --sport 443 -d $server --dport $client -m state --state ESTABLISHED  -j ACCEPT

#sshd/proftpd(sftp)
	/sbin/iptables -A INPUT -i venet0 -p tcp -s 0/0 --sport $client -d $server --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
	/sbin/iptables -A OUTPUT -o venet0 -p tcp -s $server --sport 22 -d 0/0 --dport $client -m state --state ESTABLISHED -j ACCEPT

#service web (nginx pour Gitlab)
	/sbin/iptables -A OUTPUT -o venet0 -p tcp -s $server --sport 6112 -d 0/0 --dport $client -m state --state ESTABLISHED -j ACCEPT
	/sbin/iptables -A INPUT -i venet0 -p tcp -s 0/0 --sport $client -d $server --dport 6112 -m state --state NEW,ESTABLISHED -j ACCEPT


#fin fw
	/sbin/iptables -A INPUT -j DROP
	/sbin/iptables -A OUTPUT -j DROP
	/sbin/iptables -A FORWARD -j DROP

exit 0
---
layout: post
title: using nat to route internet traffic through a computer with a working internet connection
date: 2020-03-07
---

Another day, another Linux install where I botch the network configuration and I'm marooned with no internet access to install the drivers. Sometimes it's because I forget `wpa-supplicant`, sometimes it's because I forget to install the WiFi drivers or firmware package. Whatever the case may be, it's useful to be able to route network traffic through my laptop (which has working WiFi) over Ethernet. Ethernet always works, thankfully.

I've done this a few times. Every time, I forget the commands and have to piece together the right ones from a few online sources. Well no more! I'm finally documenting it.

On the laptop (machine A) that will forward internet traffic for the box with the lame network card (machine B):

	WIRELESS_DEV=wlan0
	ETH_DEV=eth0
	sudo ip addr add 192.168.3.1/24 dev $ETH_DEV
	echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward # enable forwarding
	sudo iptables -t nat -A POSTROUTING -o $WIRELESS_DEV -j MASQUERADE
	sudo iptables -A FORWARD -i $ETH_DEV -o $WIRELESS_DEV -j ACCEPT

On machine B set a different IP address for its Ethernet device:

	ip addr add 192.168.3.2/24 dev eth0

... then make sure we can ping machine A from machine B:

	ping 192.168.3.1

Configure default routing for machine B to route internet traffic through machine A:

	sudo route add default gw 192.168.3.1 eth0

... and make sure we can ping stuff on the internet from machine B:

	ping 8.8.8.8 # Google's DNS

Finally, set your DNS server (probably your router, but you can use Google's DNS if you're unsure):

	echo 'nameserver 192.168.88.1' | sudo tee /etc/resolv.conf

Finally, make sure you can ping stuff on the internet:

	ping c.har.li

---

*Man, my titles continue to get more and more boring. I need write something more controversial next time :P*

---
layout: post
title: low lag mouse/keyboard sharing with Synergy and an ethernet cable
date: 2019-03-23
---

[Synergy](https://symless.com/synergy) lets you share a desktop and keyboard over the network, which is quite convenient if you're like me and have two desktop machines (one Mac, one Linux in my case) and don't want to waste desk space with duplicate mice/keyboards.

I've tried to use Synergy in the past with a wireless connection, but I've always been discouraged by the input lag on the client machine. Recently, I realized that since the boxes are physically located close to each other, I could probably connect them directly to each other over ethernet, while still allowing them to use wireless for the regular internet connection.

So I did that.

On Mac, the configuration simply consisted of going to the Network preferences, and configuring the ethernet with a manual IP address (say 192.168.3.1) that didn't conflict with any of the wireless network prefixes (e.g. if your wireless uses 192.168.44.0/24, configure your wired "network" to something like 192.168.3.0/24). I didn't specify a router, since it's just a direct connection between the two machines.

On Linux, the configuration is:

```
# enable ethernet
ip link set eth0 up

# add the address to the route table
ip route add 192.168.3.0/24 dev eth0

# pick an IP address that's different than the other computer
IP=192.168.3.2

# statically set the IP addres for the eth0 device
ip addr add dev eth0 $IP
```

Then, you can just configure Synergy to use the IP address (of the eth0 device) when connecting the client to the server. With this new configuraiton, I don't notice any input latency on the client machine anymore.

I realize that none of these ideas are particularly novel, but I thought it was neat that a very usable configuration could be set up over ethernet. It definitely beats a KVM switch.

### Update
<strike>
I started noticing massive (>= 50%) packet loss after running this for a while. I think the initial autonegotiation worked fine, but after a few suspends, it lost track of the correct configuration. To fix this, you can force half-duplex mode on the Linux box.

My updated `/etc/network/interfaces` looks like this:

```
iface eth0 inet static
	# set up half-duplex using the ethtool command
	pre-up /sbin/ethtool -s eth0 autoneg off duplex half
```

The Mac side picked up the half-duplex configuration once I restarted the networking on the Linux side.
</strike>

### Update 2

Nevermind -- that didn't seem to help at all. Stuff will break if you don't use autonegotation!

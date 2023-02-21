#!/bin/bash
# Lab 3 Graded Portion
# Installing and Configuring an Apache Container
#
# I'd like to show off something I've been learning and using at work
#
# Since lxd is only accessible as a Snap in 22.04 anyway, I'll be using Canonical's Snap management tools
#
# The experiment was a failure.
#
# Reverting back to lxd itself (which is still only available on 22.04 as a Snap)
echo "Deploying a webserver container."

#iface=$(ip route | head -n 1 | awk '{ print $5 }')
#ip=$(ip addr show dev "${iface}" | grep -i "inet " | awk '{ print $2 }')

apt-cache policy curl | grep Installed | grep none > /dev/null
[ $? ] && echo "Curl not installed. Installing Curl now." && sudo apt install curl && echo

# Nope, not falling for THAT again.
#snap list | grep "^juju" > /dev/null
#[ $? ] && echo "Juju not installed. Installing Juju now." && sudo snap install juju --classic && echo

snap list | grep "^lxd" > /dev/null
[ $? ] && echo "lxd not installed. Installing lxd now." && sudo snap install lxd --classic && echo

echo "Initializing lxd container..."

ip link show | grep "lxdbr0" > /dev/null
[ $? ] && echo "Setting up network bridge..." && lxd init --auto

echo
echo "Installing Apache2 container..."
lxc launch ubuntu:20.04 COMP2021-W23
lxc exec COMP2021-W23 -- apt update
lxc exec COMP2021-W23 -- apt install -y apache2
echo "Done."

echo
echo "Gathering information..."
# Some combination of lxc exec and awk is causing issues, process here
# There's probably a more proper way to do it but my brain is fried so here's this mess:

iproute=$(lxc exec COMP2021-W23 -- ip route | head -n 1)
iface=$(echo $iproute | awk '{ print $5 }')
echo "Container network interface name is ${iface}."
ipRaw=$(lxc exec COMP2021-W23 --env iface=${iface} -- bash -c "ip addr show dev ${iface} | grep -i 'inet '")
ip=$(echo $ipRaw | awk '{ print $2 }')
# Trim the subnet prefix
ip=${ip:0:-3}
echo "Container IP is ${ip}."

echo "Entering COMP2101-W23 into VM's hosts file..."
grep "${ip}" /etc/hosts | grep "COMP2101-W23" > /dev/null
if [ $? ]; then echo "${ip} COMP2101-W23" | sudo tee -a /etc/hosts; fi
echo "Done."

echo
echo "Testing webserver..."
curl http://COMP2101-W23 -o /tmp/curlout
curlExitCode=$?
head /tmp/curlout

echo
[ $curlExitCode ] && "Webserver setup successful. Consider exposing it to your local network." || echo "Webserver setup unsuccessful. It worked when I tried it!"

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

# Just to keep it straight in my own head, a grep exit code of 0 means matches were found
# grep exit code of 1 means no matches were found
# For these tests, any number of matches means no action is required.
apt-cache policy curl | grep Installed | grep none > /dev/null
[ $? -eq "0" ] && echo "Curl not installed. Installing Curl now." && sudo apt install curl && echo

# Nope, not falling for THAT again.
#snap list | grep "^juju" > /dev/null
#[ $? ] && echo "Juju not installed. Installing Juju now." && sudo snap install juju --classic && echo

snap list | grep "^lxd" > /dev/null
[ $? -ne "0" ] && echo "lxd not installed. Installing lxd now." && sudo snap install lxd --classic && echo

echo "Initializing lxd container..."

ip link show | grep "lxdbr0" > /dev/null
[ $? -ne "0" ] && echo "Setting up network bridge..." && lxd init --auto

echo
echo "Installing Apache2 container..."
lxc launch ubuntu:20.04 COMP2101-W23
# Lots of failed hits when running apt update too early
echo "Waiting for container network interface to be ready."
sleep 10
echo "Updating package list..."
lxc exec COMP2101-W23 -- apt update &> /dev/null
echo "Installing Apache2..."
lxc exec COMP2101-W23 -- apt install -y apache2 &> /dev/null
echo "Done."

echo
echo "Gathering information..."
# Some combination of lxc exec and awk is causing issues, process here
# There's probably a more proper way to do it but my brain is fried so here's this mess:

iproute=$(lxc exec COMP2101-W23 -- ip route | head -n 1)
iface=$(echo $iproute | awk '{ print $5 }')
echo "Container network interface name is ${iface}."
# Had to look up how to pass variables INTO an lxc. Probably there was a one-line solution for this.
ipRaw=$(lxc exec COMP2101-W23 --env iface=${iface} -- bash -c "ip addr show dev ${iface} | grep -i 'inet '")
ip=$(echo $ipRaw | awk '{ print $2 }')
# Trim the subnet prefix
ip=${ip:0:-3}
echo "Container IP is ${ip}."

echo "Entering COMP2101-W23 into VM's hosts file..."
grep "${ip}" /etc/hosts | grep "COMP2101-W23" > /dev/null
if [ $? -ne "0" ]; then echo "${ip} COMP2101-W23" | sudo tee -a /etc/hosts; fi
echo "Done."

echo
echo "Testing webserver..."
curl http://COMP2101-W23 -o /tmp/curlout
curlExitCode=$?

echo
echo "Webpage output:"
echo
head /tmp/curlout

echo
[ $curlExitCode -eq "0" ] && echo "Webserver setup successful. Consider exposing it to your local network." || echo "Webserver setup unsuccessful. It worked when I tried it!"

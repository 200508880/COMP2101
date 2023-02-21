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
lxc exec COMP2021-W23 -- apt install apache2
echo "Done."

echo
echo "Gathering information..."

iface=$(lxc exec COMP2021-W23 bash -e "ip route | head -n 1 | awk '{ print $5 }")
ip=$(lxc exec COMP2021-W23 bash -e "ip addr show dev ${iface} | grep -i 'inet ' | awk '{ print $2 }')")

grep "${ip}" /etc/hosts | grep "COMP2101-W23"
if [ $? ]; then echo "${ip} COMP2101-W23" | sudo tee -a /etc/hosts; fi

curl http://COMP2101-W23

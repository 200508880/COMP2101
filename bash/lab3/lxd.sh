#!/bin/bash
# Lab 3 Graded Portion
# Installing and Configuring an Apache Container
#
# I'd like to show off something I've been learning and using at work
#
# Since lxd is only accessible as a Snap in 22.04 anyway, I'll be using Canonical's Snap management tools

echo "Deploying a webserver container."

#iface=$(ip route | head -n 1 | awk '{ print $5 }')
#ip=$(ip addr show dev "${iface}" | grep -i "inet " | awk '{ print $2 }')

apt-cache policy curl | grep Installed | grep none > /dev/null
[ $? ] && echo "Curl not installed. Installing Curl now." && sudo apt install curl && echo

snap list | grep "^juju" > /dev/null
[ $? ] && echo "Juju not installed. Installing Juju now." && sudo snap install juju --classic && echo

echo "Initializing Juju Controller..."
juju bootstrap localhost COMP2101-S22

echo
echo "Installing Apache2 container..."
juju deploy apache2
echo "Done."

echo
echo "Checking Juju status..."
juju status

exit

#while true; do
#  apacheStatus=$(juju status apache2 | grep "^0" | awk 'NR==5{ print $2 }')
#  [ $apacheStatus -eq "ready" ] && echo "

iface=$(juju ssh 0 bash -e "ip route | head -n 1 | awk '{ print $5 }")
ip=$(juju ssh 0 bash -e "ip addr show dev ${iface} | grep -i 'inet ' | awk '{ print $2 }')")

grep "${ip}" /etc/hosts | grep "COMP2101-S22"
if [ $? ]; then echo "${ip} COMP2101-S22" | sudo tee -a /etc/hosts; fi

curl http://COMP2101-S22

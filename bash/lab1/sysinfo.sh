#!/bin/bash
echo FQDN: $(hostname)

echo
echo Host information:
hostnamectl

echo
echo IPv4 Address: $(ip addr show dev enp1s0 | grep -i "inet " | awk '{ print $2 }')
echo IPv6 Address: $(ip addr show dev enp1s0 | grep -i "inet6" | awk '{ print $2 }')

echo
echo Root filesystem status:
df -h

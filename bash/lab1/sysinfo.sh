#!/bin/bash
# This is so much easier in Bash
echo FQDN: $(hostname)

# Add a blank space
echo
echo Host information:
hostnamectl

echo
# Now is more environment-agnostic, finds non-loopback interfaces with grep's -v
# Could be more foolproof by only fetching information on connected links
# Should ensure that network-manager is installed
# Grepping for inet with a trailing whitespace excludes ipv6 and ensures a single line
# (at least in this environment)
iface=$(nmcli --terse --field DEVICE device status | grep -v 'lo')
echo IPv4 Address: $(ip addr show dev "${iface}" | grep -i "inet " | awk '{ print $2 }')
# Repeat for ipv6
echo IPv6 Address: $(ip addr show dev "${iface}" | grep -i "inet6" | awk '{ print $2 }')

echo
echo Root filesystem status:
# Use the built-in df tool with -h for pretty size readings
df -h

#!/bin/bash

# Display system information in a pretty format.

# Looks like I'll largely be duplicating what I did last week.

hostname=$(hostname -s)
FQDN=$(hostname)
# Let's do both these things in one line to change things up:
ip=$(ip addr show dev "$(nmcli --terse --field DEVICE device status | grep -v 'lo')" | grep -i "inet " | awk '{ print $2 }')
# Today I learned about Perl-Compatible Regular Expressions.
osver=$(hostnamectl | grep -oP 'Operating System: \K.*')
fsfree=$(df -h / | tail -n +2 | awk '{ print $4 }')

# Yes, shellcheck, I did mean cat instead of echo
cat <<EOF

Report for ${hostname}
===================
FQDN: ${FQDN}
Operating System name and version: ${osver}
IP Address: ${ip}
Root Filesystem Free Space: ${fsfree}
===================

EOF

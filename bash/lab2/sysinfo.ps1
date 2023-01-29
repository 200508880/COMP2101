#!/bin/pwsh

# Display system information in a pretty format, in powershell.

# Pulling from what I leanred today in welcome-example.ps1:
$FQDN = [System.Net.DNS]::GetHostByName('').HostName
# ...and adding substrings
$hostname = $FQDN.SubString(0, $FQDN.IndexOf("."))

# Oh, I wish I'd known about System.Net.DNS last week.
# This returns three addresses, grab only the first and hope that
# IPv4 is always in the top spot

# There doesn't seem to be a quick and easy way to get the subnet prefix in / form
$ip = [System.Net.DNS]::GetHostAddresses('')[0].IPAddressToString

# This seems like cheating, but at least now I know how to make
# Powershell run bash commands
$osver = Invoke-Expression "(lsb_release -ds)"
# Experimentation shows that it is identical, at least in this
# context, to just running lsb_release -ds in pwsh.

$fsfree = [math]::Round((Get-PSDrive /).Free / 1GB, 2)

# I guess I am learning about Powershell here docs today

Write-Host @"

Report for ${hostname}
===================
FQDN: ${FQDN}
Operating System name and version: ${osver}
IP Address: ${ip}
Root Filesystem Free Space: ${fsfree}GB
===================

"@

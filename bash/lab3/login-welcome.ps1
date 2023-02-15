#!/bin/bash

# This script mimics welcome-example.sh but in powershell.

# Tasks: Print "Welcome to planet hostname, title name!" 
# (but dynamically generated, and with a clock, and in the rain, and on a train)

# Variables
#$title=
# I wasn't satisfied with how Get-Host gave a generic ConsoleHost name
$hostname = [System.Net.DNS]::GetHostByName('').HostName
# I'm sure I could pare that right down to just the hostname and not the FQDN but I'm running out of steam

# Looks like "Principal Functionality is not supported on this platform"
# Also $env:USERNAME is blank
# Which leaves us with...
$myname = [Environment]::UserName
$weekday = Get-Date -Format "dddd"

#$dateString = Get-Date -Format "
# nope, don't like that
$dateString = Get-Date -UFormat "%I:%M %p"

# OK, now how does Powershell handle Cases

switch ($weekday) {
  "Sunday" { $title = "Shogun" }
  "Monday" { $title = "Taisho" }
  "Tuesday" { $title = "Chujo" }
  "Wednesday" { $title = "Shosho" }
  "Thursday" { $title = "Taisa" }
  "Friday" { $title = "Shosha" }
  "Saturday" { $title = "Tai-i" }
}

$cowsays = @"
Welcome to planet ${hostname}, ${title} ${myname}!

It is ${weekday} at ${datestring}
"@

/usr/games/cowsay -b "$cowsays"

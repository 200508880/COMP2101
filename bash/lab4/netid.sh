#!/bin/bash
#
# this script displays some host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

# TASK 1: Accept options on the command line for verbose mode and an interface name - must use the while loop and case command as shown in the lesson - getopts not acceptable for this task
#         If the user includes the option -v on the command line, set the variable $verbose to contain the string "yes"
#            e.g. network-config-expanded.sh -v
#         If the user includes one and only one string on the command line without any option letter in front of it, only show information for that interface
#            e.g. network-config-expanded.sh ens34
#         Your script must allow the user to specify both verbose mode and an interface name if they want
# TASK 2: Dynamically identify the list of interface names for the computer running the script, and use a for loop to generate the report for every interface except loopback - do not include loopback network information in your output

################
# Data Gathering
################
# the first part is run once to get information about the host
# grep is used to filter ip command output so we don't have extra junk in our output
# stream editing with sed and awk are used to extract only the data we want displayed

interface="enp1s0"
allInterfaces="no"

while [ $# -gt 0 ]; do
  # I was going to do this as a series of ifs to be different from the powerpoint but cases are just too good
  case "$1" in
    -h | --help )
      echo "Usage: netid.sh [options] [interface name]"
      echo "Options:"
      echo "  -h or --help: show this information"
      echo "  -v or --verbose: print out extra information on execution"
      echo "  -l or --list: list network interfaces by name"
      echo "  -a or --all: gather information on every interface"
      echo "  string: specify a network interface by name to inspect"
      echo
      echo "Example:"
      echo "  netid.sh -v eno1"
      echo
      exit
      ;;
    -l | --list )
      # lot of trial and error here
      # fix the veth @if4 business since that's not real
      # in fact, I hope you don't mind if I nuke virtual ethernet entirely, it causes very headache
      menu=($(ip link show | grep -v "^ " | grep -v "veth" | awk '{ print substr($2,0,length($2)-1) }' | awk -F'@' '{ print $1 }'))
      menuString=""
      #for (( i=0; i<${#menu}; i++ )); do; menuString="$menuString ${!menu[i]} ${menu[i]}"; done
      i=0
      # I feel like iterating through a bash array should work without having to specify the [@]
      for menuItem in ${menu[@]}; do
        menuString="${menuString}$i $menuItem "
        ((i=i+1))
      done
      selected=$(dialog --menu --stdout "Please select a network interface" 14 40 8 ${menuString})
      interface="${menu[$selected]}"
      ;;
    -v | --verbose )
      verbose="yes"
      ;;
    -a | --all )
      allInterfaces="yes"
      ;;
    * )
      # attempting to adhere to the specific wording "if the user includes one and only one string..."
      if [ $# -eq "1" ]; then
        interface="$1"
      else
        # This being after all the actual flags means it should only be reached when there's only supposed to be one thing left anyway
        echo "Please only provide one interface name."
        exit
      fi
      ;;
  esac
  shift
done

#####
# Once per host report
#####
[ "$verbose" = "yes" ] && echo "Gathering host information"
# we use the hostname command to get our system name and main ip address
my_hostname="$(hostname) / $(hostname -I)"

[ "$verbose" = "yes" ] && echo "Identifying default route"
# the default route can be found in the route table normally
# the router name is obtained with getent
default_router_address=$(ip r s default| awk '{print $3}')
default_router_name=$(getent hosts $default_router_address|awk '{print $2}')

[ "$verbose" = "yes" ] && echo "Checking for external IP address and hostname"
# finding external information relies on curl being installed and relies on live internet connection
external_address=$(curl -s icanhazip.com)
external_name=$(getent hosts $external_address | awk '{print $2}')

cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF

#####
# End of Once per host report
#####

# the second part of the output generates a per-interface report
# the task is to change this from something that runs once using a fixed value for the interface name to
#   a dynamic list obtained by parsing the interface names out of a network info command like "ip"
#   and using a loop to run this info gathering section for every interface found

# the default version uses a fixed name and puts it in a variable
#####
# Per-interface report
#####

# define the interface being summarized
# moving up so it can be overwritten by argument or menu option
#interface="enp1s0"

getInterface () {
  [ "$verbose" = "yes" ] && echo "Reporting on all interface(s): $interface"
  [ "$verbose" = "yes" ] && echo "Getting IPV4 address and name for interface $interface"
  # Find an address and hostname for the interface being summarized
  # we are assuming there is only one IPV4 address assigned to this interface
  ipv4_address=$(ip a s $interface|awk -F '[/ ]+' '/inet /{print $3}')
  ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')

  [ "$verbose" = "yes" ] && echo "Getting IPV4 network block info and name for interface $interface"
  # Identify the network number for this interface and its name if it has one
  # Some organizations have enough networks that it makes sense to name them just like how we name hosts
  # To ensure your network numbers have names, add them to your /etc/networks file, one network to a line, as   networkname networknumber
  #   e.g. grep -q mynetworknumber /etc/networks || (echo 'mynetworkname mynetworknumber' |sudo tee -a /etc/networks)
  network_address=$(ip route list dev $interface scope link | grep "${ipv4_address}" | cut -d ' ' -f 1)
  [ "$interface" = "lo" ] && network_address="127.0.0.0"
  network_number=$(cut -d / -f 1 <<<"$network_address")
  network_name=$(getent networks $network_number|awk '{print $1}')

cat <<EOF

Interface $interface:
===============
Address         : $ipv4_address
Name            : $ipv4_hostname
Network Address : $network_address
Network Name    : $network_name

EOF
}


# moving this below function definition:
# turning this into a regular condition so I can make it more complex without getting a headache

if [ "$allInterfaces" = "yes" ]; then
    # I should have just done this once outside of the case so I wouldn't have to duplicate it:
    # ah yes, and now that I have to modify it to string the @if4 business out, I have to fix it in two places
    interfaces=$(ip link show | grep -v "^ " | grep -v "veth" | awk '{ print substr($2,0,length($2)-1) }' | awk -F'@' '{ print $1 }')
    # This seems cheeky... can I do it?
    # seems so
    for interface in $interfaces; do
      getInterface
    done
  else
    echo "Reporting on interface(s): $interface"
    getInterface
  fi

#####
# End of per-interface report
#####

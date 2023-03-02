#!/bin/bash

# This script demonstrates how to trap signals and handle them using functions

# Task: Add traps for the INT and QUIT signals. If the script receives an INT signal,
#       reset the count to the maximum and tell the user they are not allowed to interrupt
#       the count. If the script receives a QUIT signal, tell the user they found the secret
#       to getting out of the script and exit immediately.

#### Variables
programName="$0" # used by error_functions.sh
sleepTime=1 # delay used by sleeptime
numberOfSleeps=10 # how many sleeps to wait for before quitting for inactivity
[ -z "$verbose" ] && verbose="no"
[ -z "$debug" ] && debug="no"

#### Traps

# This trap catches the interrupt signal and calls a function to reset the timer.
trap bad-user SIGINT
trap good-user SIGQUIT

#### Functions

# This function resets the timer and warns the user.

function bad-user {
        [ $verbose = "yes" ] && echo "Interrupt signal detected. Resetting timer."
        if [ $debug = "yes" ]; then
          echo "debug hi what"
          echo "$sleepCount $numberOfSleeps"
          sleep 3
        fi
        timeMessage="Ah ah ah, what's the magic word?"
        sleepCount=$numberOfSleeps
        doCountdown|dialog --gauge "$timeMessage" 7 60
}

# This function congratulates the user and exits the script.

function good-user {
        # Leaving these verbose and debug conditions since I suspect we'll be sourcing these scripts later
        # Glad to learn about THIS little tool...
        stty sane
        [ $verbose = "yes" ] && echo "Quit signal detected. Exiting execution."
        clear
        echo "You win this time, Gadget!"
        exit
}

# This function will send an error message to stderr
# Usage:
#   error-message ["some text to print to stderr"]
#
function error-message {
        local prog=`basename $0`
        echo "${prog}: ${1:-Unknown Error - a moose bit my sister once...}" >&2
}

# This function will send a message to stderr and exit with a failure status
# Usage:
#   error-exit ["some text to print" [exit-status]]
#
function error-exit {
        error-message "$1"
        exit "${2:-1}"
}
function usage {
        cat <<EOF
Usage: ${programName} [-h|--help ] [-w|--waittime waittime] [-n|--waitcount waitcount]
Default waittime is 1, waitcount is 10
EOF
}

# Normally traps catch signals and do something useful or necessary with them


# Produce the numbers for the countdown
function doCountdown {
# Changing to -ge so we get to see 0% and an empty bar
while [ $sleepCount -ge 0 ]; do
    # hm, this didn't work. I guess dialog is taking the value of timeMessage down below.
    [ $sleepCount -eq 0 ] && timeMessage="Wait counter expired, exiting peacefully"
#    echo "$timeMessage 7 60 $((sleepCount * 100 / $numberOfSleeps))"
    echo "$((sleepCount * 100 / $numberOfSleeps))"
    sleepCount=$((sleepCount - 1))
    sleep $sleepTime
done
}

#### Main Program

# Process command line parameters
while [ $# -gt 0 ]; do
    case $1 in
        -w | --waittime )
            shift
            sleepTime="$1"
            ;;
        -n | --waitcount)
            shift
            numberOfSleeps="$1"
            ;;
        -h | --help )
            usage
            exit
            ;;
        * )
            usage
            error-exit "$1 not a recognized option"
    esac
    shift
done

if [ ! $numberOfSleeps -gt 0 ]; then
    error-exit "$numberOfSleeps is not a valid count of sleeps to wait for signals"
fi

if [ ! $sleepTime -gt 0 ]; then
    error-exit "$sleepTime is not a valid time to sleep while waiting for signals"
fi

sleepCount=$numberOfSleeps

timeMessage="Remaining Time"

# bear with me...
# nah, that didn't work. Can't just pass everything in from doCountdown so we can tailor the title.
#doCountdown|dialog --gauge
doCountdown|dialog --gauge "$timeMessage" 7 60
stty sane

echo "Wait counter expired, exiting peacefully"

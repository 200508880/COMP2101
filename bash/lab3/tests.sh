#!/bin/bash
# This is a script to practice doing testing in bash scripts

# This section demonstrates file testing

# Test for the existence of the /etc/resolv.conf file
# TASK 1: Add a test to see if the /etc/resolv.conf file is a regular file
# TASK 2: Add a test to see if the /etc/resolv.conf file is a symbolic link
# TASK 3: Add a test to see if the /etc/resolv.conf file is a directory
# TASK 4: Add a test to see if the /etc/resolv.conf file is readable
# TASK 5: Add a test to see if the /etc/resolv.conf file is writable
# TASK 6: Add a test to see if the /etc/resolv.conf file is executable

# Changing to if/then because additional tests are guaranteed to be false if file does not exist
if [ -e /etc/resolv.conf ]; then
  echo "/etc/resolv.conf exists"
  test -L /etc/resolv.conf && echo "/etc/resolv.conf is a symbolic link" || echo "/etc/resolv.conf is not a symbolic link"
  test -d /etc/resolv.conf && echo "/etc/resolv.conf is a directory" || echo "/etc/resolv.conf is not a directory"
  test -r /etc/resolv.conf && echo "/etc/resolv.conf is readable" || echo "/etc/resolv.conf is not readable"
  test -w /etc/resolv.conf && echo "/etc/resolv.conf is writeable" || echo "/etc/resolv.conf is not writeable"
  test -x /etc/resolv.conf && echo "/etc/resolv.conf is executable" || echo "/etc/resolv.conf is not executable"
else echo "/etc/resolv.conf does not exist"
fi

# Tests if /tmp is a directory
# TASK 4: Add a test to see if the /tmp directory is readable
# TASK 5: Add a test to see if the /tmp directory is writable
# TASK 6: Add a test to see if the /tmp directory can be accessed
if [ -d /tmp ]; then
  echo "/tmp is a directory"
  test -r /tmp && echo "/tmp is readable" || "/tmp is not readable"
  test -w /tmp && echo "/tmp is writeable" || "/tmp is not writeable"
  test -x /tmp && echo "/tmp is accessible" || "/tmp is not accessible"
else echo "/tmp is not a directory"
fi

# Tests if one file is newer than another
# TASK 7: Add testing to print out which file newest, or if they are the same age
[ /etc/hosts -nt /etc/resolv.conf ] && echo "/etc/hosts is newer than /etc/resolv.conf"
[ /etc/hosts -ot /etc/resolv.conf ] && echo "/etc/resolv.conf is newer than /etc/hosts"
[ ! /etc/hosts -nt /etc/resolv.conf -a ! /etc/hosts -ot /etc/resolv.conf ] && echo "/etc/hosts is the same age as /etc/resolv.conf"

# this section demonstrates doing numeric tests in bash

# TASK 1: Improve it by getting the user to give us the numbers to use in our tests
# TASK 2: Improve it by adding a test to tell the user if the numbers are even or odd
# TASK 3: Improve it by adding a test to tell the user is the second number is a multiple of the first number

echo -n "Enter first number: "
read firstNumber
echo -n "Enter second number: "
read secondNumber
#firstNumber=4
#secondNumber=7

[ $firstNumber -eq $secondNumber ] && echo "The two numbers are the same"
[ $firstNumber -ne $secondNumber ] && echo "The two numbers are not the same"
[ $firstNumber -lt $secondNumber ] && echo "The first number is less than the second number"
[ $firstNumber -gt $secondNumber ] && echo "The first number is greater than the second number"

[ $firstNumber -le $secondNumber ] && echo "The first number is less than or equal to the second number"
[ $firstNumber -ge $secondNumber ] && echo "The first number is greater than or equal to the second number"

echo "The first number is $([ $(($firstNumber % 2)) -eq 0 ] && echo 'even' || echo 'Odd') and the second number is $([ $(($secondNumber % 2)) -eq 0 ] && echo 'even' || echo 'odd')."

if [[ $secondNumber -ne 0 ]]; then
  # Weird spacing to get around an accidental double space on negative condition:
  echo "${firstNumber} is $([ $(($firstNumber % $secondNumber)) -eq 0 ] || echo 'not ')a multiple of ${secondNumber}."
else
  echo "The second number is zero, not checking for multiples."
fi

# This section demonstrates testing variables

# Test if the USER variable exists
# TASK 1: Add a command that prints out a labelled description of what is in the USER variable,
  # but only if it is not empty
# TASK 2: Add a command that tells the user if the USER variable exists, but is empty
if [ -v USER ]; then
  if [ -z USER ]; then
    echo "The variable USER is set but is empty. Are you real?"
  else
    echo "The variable USER exists and contains the username of the user logged into this shell."
    echo "The value is ${USER}."
  fi
fi


# Tests for string data
# TASK 3: Modify the command to use the != operator instead of the = operator, without breaking the logic of the command
# TASK 4: Use the read command to ask the user running the script to give us strings to use for the tests
#a=1
#b=01
echo -n "Please enter a string for comparison: "
read a
echo -n "Please enter a second string: "
read b
[ ! $a != $b ] && echo "$a is alphanumerically equal to $b" || echo "$a is not alphanumerically equal to $b"

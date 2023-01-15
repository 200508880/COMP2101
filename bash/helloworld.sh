#!/bin/bash
helloArray=("H" "e" "l" "l" "o" "_" "w" "o" "r" "l" "d")
# Why did I make this an array? This definitely didn't need to be an array.

# Set time to sleep.
# This is used in a few different places and I got 
# bored of changing it everywhere when feeling it out.
sleepLength=0.05

# Loop forever (until interrupted anyway)
while true; do

# Start fresh each loop:
  workingString=""

# First half of the loop, iterate through the array...
  for helloLetter in "${helloArray[@]}"; do
# ...and add the first letter to our working string...
    workingString+=${helloLetter}
# ...print it to the screen...
    echo "${workingString}"
# ...and wait.
    sleep ${sleepLength}
  done

# Now do the reverse. Take letters off the end until
# there's nothing left.
  while [ ${#workingString} -gt 0 ]; do
    newLength=$((${#workingString} - 1))
    if [ ${newLength} -gt 0 ]; then
      workingString=$(echo "${workingString}" | cut -c 1-${newLength})
      echo "${workingString}"
    else
# This is a band-aid fix because it was getting stuck
# printing H forever.
# The proper fix would be to change the condition on the
# while loop, probably.
      echo
# This break will bring us back up to the top where we will
# build the string up from zero again.
      break
    fi
    sleep ${sleepLength}
  done
done

# An artifact from a simpler time: the unreachable exit.
exit

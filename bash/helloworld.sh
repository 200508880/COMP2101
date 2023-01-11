#!/bin/bash
helloArray=("H" "e" "l" "l" "o" "_" "w" "o" "r" "l" "d")
sleepLength=0.05


while true; do
  workingString=""
  for helloLetter in "${helloArray[@]}"; do
    workingString+=${helloLetter}
    echo "${workingString}"
    sleep ${sleepLength}
  done
  while [ ${#workingString} -gt 0 ]; do
    newLength=$((${#workingString} - 1))
    if [ ${newLength} -gt 0 ]; then
      workingString=$(echo "${workingString}" | cut -c 1-${newLength})
      echo "${workingString}"
    else
      echo
      break
    fi
    sleep ${sleepLength}
  done
done

exit

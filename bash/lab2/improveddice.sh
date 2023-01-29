#!/bin/bash
#
# this script rolls a pair of six-sided dice and displays both the rolls
#

# Task 1:
#  put the number of sides in a variable which is used as the range for the random number
#  put the bias, or minimum value for the generated number in another variable
#  roll the dice using the variables for the range and bias i.e. RANDOM % range + bias

# Task 2:
#  generate the sum of the dice
#  generate the average of the dice

#  display a summary of what was rolled, and what the results of your arithmetic were

echo "Improved Dice Roller"

echo "How many dice?"
read dieQuantity
#dieQuantity=10
echo "How many sides per die?"
read dieSides
#dieSides=12

dieBias=1
runningTotal=0
outputString="Rolled "

# Tell the user we have started processing
echo "Rolling ${dieQuantity}d${dieSides}..."
# roll the dice and save the results
# Borrowing seq command
for i in $(seq 1 $dieQuantity); do
  die1=$(( RANDOM % "$dieSides" + "$dieBias" ))

  runningTotal=$(("${runningTotal}" + "${die1}"))

  outputString="${outputString}${die1}"

  # Lots of trial and error on this one.
  # The logic is slightly different than in the ps1.
  if [[ "$i" -ge "$dieQuantity" ]]; then
    outputString="${outputString}."
  else
    outputString="${outputString}, "
  fi

# Tested with dieQuantity=4000 to ensure the range is correct:
#  if [[ "$die1" -lt "1" ]]; then echo "rolled too low: ${die1}"; fi
#  if [[ "$die1" -gt "20" ]]; then echo "rolled too high: ${die1}"; fi

done
#die2=$(( RANDOM % $dieSides + $dieBias ))
# display the results
#echo "Rolled $die1, $die2"
echo "${outputString}"
# Outsource division to bc
dieAverage=$( bc <<< "scale=2; $runningTotal / $dieQuantity" )
echo "The average of these rolls was ${dieAverage}."

# Oh. The average DOES make sense because the rolls don't include 0.
# It SHOULD be roughly halfway between the two median numbers.
# Tested with 2000 rolls of a 3-sided die and got 1.978 (pwsh) and 2.01 (bash)

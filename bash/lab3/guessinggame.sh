#!/bin/bash
#
# This script implements a guessing game
# it will pick a secret number from 1 to 10
# it will then repeatedly ask the user to guess the number
#    until the user gets it right

# Give the user instructions for the game
cat <<EOF
Let's play a game.
I will pick a secret number from 1 to 10 and you have to guess it.
If you get it right, you get a virtual prize.
Here we go!

EOF

# Pick the secret number and save it
secretnumber=$(($RANDOM % 10 +1)) # save our secret number to compare later

# This loop repeatedly asks the user to guess and tells them if they got the right answer
# TASK 1: Test the user input to make sure it is not blank
# TASK 2: Test the user input to make sure it is a number from 1 to 10 inclusive
# TASK 3: Tell the user if their guess is too low, or too high after each incorrect guess

# Moving read into while for consistent logic and deduplication
#read -p "Give me a number from 1 to 10: " userguess # ask for a guess

while true; do # ask repeatedly until they get it right
  read -p "Give me a number from 1 to 10: " userguess # ask for another guess
  # not super fluent in regex, doing 1-9 and 10 matches in separate conditions:
  if [ ! -z $userguess ] && ( [[ $userguess =~ [1-9] ]] || [[ $userguess -eq "10" ]] ) && [ $userguess -gt 0 ] && [ $userguess -le 10 ]; then
    if [ $secretnumber -eq $userguess ]; then break; fi
    [ $userguess -lt $secretnumber ] && echo "Higher!"
    [ $userguess -gt $secretnumber ] && echo "Lower!"
  else echo "That's either not in range or not a number. Try again."
  fi
done
echo "You got it! Have a milkdud."


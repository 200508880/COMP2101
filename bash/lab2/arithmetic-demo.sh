#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second
# number variables. Use one or more read commands to get 3 numbers
# from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

# read --help shows -p is prompt
read -p "Enter a number: " firstnum
read -p "Enter another number: " secondnum
read -p "Enter a third number: " thirdnum
sum=$((firstnum + secondnum + thirdnum))
product=$((firstnum *  secondnum * thirdnum))
#fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")

cat <<EOF
Sum		Product
$sum		$product
EOF
#$firstnum plus $secondnum is $sum
#$firstnum divided by $secondnum is $dividend
#  - More precisely, it is $fpdividend
#EOF

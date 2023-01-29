#!/bin/pwsh
#
# This script replicates arithmeticdemo.sh but in powershell.

# Task 1: Get 3 numbers from user input instead of assigning them
# Taks 2: Only show: the sum and the product, each with a label

# Same as in bash, prompt for three numbers, save them to variables
$firstnum = Read-Host "Enter a number: "
$secondnum = Read-Host "Enter another number: "
$thirdnum = Read-Host "Enter a third number: "

# Do the math
$sum = $firstnum + $secondnum + $thirdnum
$product = $firstnum * $secondnum * $thirdnum

# Surprisingly, Write-Host respects tabs. I expected this to be messier.
Write-Host "Sum		Product"
Write-Host "${firstNum}		${secondNum}"

#!/bin/pwsh
# This script imitates checkMYVAR.sh but in Powershell
# It checks the status of a variable created outside of the script itself.

# The variable is set prior to execution with $Env:MYVAR = "a value"

# This does feel contrary to the spirit of the "execution control" unit but it works.

# Powershell is SUCH A PAIN.
# Setting specifically an environment variable to "" destroys it
# This is not well-documented

if ( $MYVAR -or $MYVAR -eq "" ) {
  Write-Host "The variable MYVAR exists"
# Not quite as elegant as in bash
  if ( $MYVAR.length -gt 0) {
    Write-Host "The variable MYVAR has data in it"
  }
  else {
    Write-Host "The variable MYVAR is empty"
  }
}
else {
  Write-Host "The variable MYVAR does not exist"
}



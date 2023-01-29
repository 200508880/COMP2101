#!/bin/pwsh
# improveddice.ps1 will seek to replicate the output of improveddice.sh but in powershell.

# Using the .sh as a framework:

Write-Host "Imrpoved Dice Roller -- Powershell Version"

# Write-Host "How many dice?"
$dieQuantity = Read-Host "How many dice?"

$dieSides = Read-Host "How many sides per die?"

$dieBias = 1
$runningTotal = 0
$outputString = "Rolled "

# Experiment: Does pwsh respect curlybraced variable names?
Write-Host "Rolling ${dieQuantity}d${dieSides}..."
# It does!

# This looks both familiar and strange...
For ( $i = 0; $i -lt $dieQuantity; $i++ ) {
  # Get-Random does not seem to include the value specified by the -Maximum argument.
  # But that's fine, because we have the dieBias already.
  # Instead of setting -Minimum to $dieBias, set min to 0 and add $dieBias to the total
  $die1 = ( Get-Random -Minimum 0 -Maximum $dieSides ) + $dieBias

  $runningTotal += $die1
  $outputString += $die1
  
  if ( ( $i + 1 ) -eq $dieQuantity ) {
    $outputString += "."
  }
  else {
    $outputString += ", "
  }
}

Write-Host "$outputString"
$dieAverage = $runningTotal / $dieQuantity
Write-Host "The average of these rolls was ${dieAverage}."

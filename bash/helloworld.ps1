# Do Powershell comments work the same as Bash?
# Let's find out!
# (Turns out yes)
# Again, do this forever
While (1) {
# Let's do this a little differently...
# The goal is to change the space at the start...
# so we still get the wave pattern but with motion instead
  $workingString = ''
  For($i=0; $i -le 6; $i++) {
# Thank you Wayne for teaching me about string multiplication
    Write-Host (" " *  $i) 'Hello World'
# The sleep duration seemed to work fine in the Bash script
    Start-Sleep 0.05
  }
  For($i=6; $i -ge 0; $i--) {
   Write-Host (" " * $i) 'Hello World'
   Start-Sleep 0.05
  }
}

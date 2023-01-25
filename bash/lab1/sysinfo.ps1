#!/bin/pwsh
# Surprisingly, /bin/pwsh is there. Symlink that points to /opt.
Write-Host 'Hostname:'
# Can't get rid of the empty space the header created
Get-Host | Select Name | Format-Table -hidetableheaders

Write-Host 'Host information:'
# Explicitly specify Format-List to prevent out-of-order output
Get-Host | Format-List

Write-Host 'Root filesystem status:'
Get-PSDrive / | Format-Table

# ipconfig and Get-NetIPAddress do not exist
# I feel like running the Linux equivalents isn't sporting

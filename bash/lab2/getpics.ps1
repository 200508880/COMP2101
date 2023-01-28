#!/bin/pwsh
# Attempting to recreate getpics.sh in Powershell on Ubuntu

# Remove-Item to delete the folder first (only if it exists)
if (Test-Path -Path ~/public_html/powershellpics) {
  # I ran this and it told me to add "-Recurse"
  Remove-Item -Recurse ~/public_html/powershellpics
}
# New-Item foldername -ItemType Directory to recreate it
# Found the source of the spam. Does this not have a --quiet option?
New-Item ~/public_html/powershellpics -ItemType Directory | Out-Null

if ( -not (Test-Path -Path ~/public_html/powershellpics) ) {
  Write-Host "Failed to make a new powershellpics directory."
  Exit
}

# Mirror the .sh output:
Write-Host "Downloading files..."

# Invoke-WebRequest to download the zip
if ( -not (Test-Path -Path ~/public_html/powershellpics/pics.zip) ) {
  # Invoke-WebRequest does not seem to respect the Out-Null redirect
  # It looks like there's a way to hide powershell "windows" but I might say this is good enough
  # and go find out how powershell handles random numbers in improveddice.ps1
  Invoke-WebRequest -Uri http://zonzorp.net/pics.zip -OutFile ~/public_html/powershellpics/pics.zip
}
if ( -not (Test-Path -Path ~/public_html/powershellpics/pics.tgz) ) {
  Invoke-WebRequest -Uri http://zonzorp.net/pics.tgz -OutFile ~/public_html/powershellpics/pics.tgz
}

# I wanted to try Powershell's OR logic:
if ( -not (Test-Path -Path ~/public_html/powershellpics/pics.zip) -or -not (Test-Path -Path ~/public_html/powershellpics/pics.tgz ) ) {
  Write-Host "Download failed."
  Exit
}

# Things are a little logically backwards from the original script, but at this stage
# we know we have the folder created and both files successfully downloaded, so:

# Extract Zee Files
# It looks like tar now runs natively in Powershell, though this might still be pulling from
# Linux's binaries, not sure how to...
# Get-Command tar returns /usr/bin/tar, so it looks like this script won't be strictly pwsh-only

# Trial and error says pwsh requires the xzf arguments to have a hyphen
# This must be where they spent all the hyphens they're not using in their built-in commands
# No, that wasn't it. It's a gzip issue? "stdin has more than one entry--rest ignored"
# Ah. I was assuming that the tgz was a "tar gzip" and was using the -z argument.
# NOPE, I copied and pasted the Invoke-WebRequests above and didn't change both file extensions,
# so it was writing the .zip as .tgz. PEBCAK.

tar -xzf ~/public_html/powershellpics/pics.tgz -C ~/public_html/powershellpics/

# Oh no, I made a stylistic choice in the .sh version and now have to do extra work here
# to make sure they align.
# Can't extract straight to public_html because powershellpics != pics and they won't merge

Get-ChildItem -Path ~/public_html/powershellpics/pics -Recurse -File | Move-Item -Destination ~/public_html/powershellpics
Remove-Item ~/public_html/powershellpics/pics

# Same for unzip, pwsh is just invoking the Linux binary
# Borrowing syntax from getpics.sh
unzip -d ~/public_html/powershellpics -o -q ~/public_html/powershellpics/pics.zip

if (Test-Path -Path ~/public_html/powershellpics/catfiles) {
  Remove-Item ~/public_html/powershellpics/pics.zip
}
else {
  Write-Host "File did not unzip correctly. Leaving in-place for debugging."
}

if (Test-Path -Path ~/public_html/powershellpics/catfiles) {
  Remove-Item ~/public_html/powershellpics/pics.tgz
}
else {
  Write-Host "File did not extract correctly. Leaving in-place for debugging."
}

Write-Host "Done."

# Do subshells even work in powershell, who can say
# Also why do the built-in commands all have exactly one hyphen even when they're more than two words long?
$fileCount = (Get-ChildItem -Recurse -Path ~/public_html/powershellpics | Measure-Object).Count
$fileSize = [math]::Round((Get-ChildItem -Recurse -Path ~/public_html/powershellpics | Measure-Object -Sum Length).Sum / 1MB, 3)

Write-Host "Found $fileCount files in the public_html/powershellpics directory."
Write-Host "The public_html/powershellpics directory uses $fileSize M space on the disk."

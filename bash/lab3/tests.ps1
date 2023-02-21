#!/bin/pwsh
# This script seeks to duplicate the functions of tests.sh, which demonstrates file testing

if ( Test-Path /etc/resolv.conf ) {
  echo "/etc/resolv.conf exists"
}
else {
  echo "/etc/resolv.conf does not exist"
}

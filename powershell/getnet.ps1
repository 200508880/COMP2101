$getnetraw = get-ciminstance Win32_NetworkAdapterConfiguration | ? ipenabled -eq $true | select Index, Description, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder

foreach ($gnr in $getnetraw){
	$getnet += new-object -typename psobject -property @{Index=$gnr.Index; Description=$gnr.Description; IPv4Address=$gnr.IPAddress[0]; IPv6Address=$gnr.IPAddress[1]; IPSubnet=$gnr.IPSubnet[0]; DNSDomain=$gnr.DNSDomain; DNSServer=$gnr.DNSServerSearchOrder[0] }
}

$getnet | select Index, Description, IPv4Address, IPSubnet, DNSDomain, DNSServer, IPv6Address | format-list
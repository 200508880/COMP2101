function welcome {
	$now = get-date -format 'HH:mm tt on dddd'
	write-output "Hello $env:username. Welcome to $env:computername. The time is $now."
}

function bigdocs {
param ([String]$Path=".", [long]$MinimumSize = 0)
function Get-Docs ([string]$DocsPath=".") {
Get-ChildItem -Path $DocsPath `
-Include *.* `
-Recurse `
-ErrorAction SilentlyContinue
}
Get-Docs -DocsPath $path |
Where-Object { $_.length -ge $minimumsize } |
Select-Object FullName, LastAccessTime, Length |
Sort-Object -Descending Length |
Out-GridView
}

function get-cpuinfo {
	get-ciminstance cim_processor | Select Caption,CurrentClockSpeed,MaxClockSpeed,NumberOfCores | Format-List
}

function get-mydisks {
	get-disk | select Manufacturer, Model, SerialNumber, FirmwareRevision, Size | format-table
}

function getnet {
	get-ciminstance Win32_NetworkAdapterConfiguration | ? ipenabled -eq $true | select Index, Description, @{n="IPv4Address"; e={$_.IPAddress[0]}}, @{n="Subnet"; e={$_.IPSubnet[0]}}, DNSDomain, @{n="DNSServer"; e={$_.DNSServerSearchOrder[0]}}, @{n="IPv6Address"; e={$_.IPAddress[1]}} | format-table
}

function HelloWorld{
	Write-Host "Hello World!"
}

function welcome {
	$now = get-date -format 'HH:mm tt on dddd'
	write-output "Hello $env:username. Welcome to $env:computername. The time is $now."
}

function testparams{
Param ([Parameter(Mandatory=$true,position=1)][string]$SourceFile,
[Parameter(Mandatory=$true,position=2)][string]$DestinationFile )
"SourceFile was '$sourcefile'"
$objtypename = $sourcefile.gettype().name
"SourceFile was a $objtypename object"
"DestinationFile was '$destinationfile'"
$objtypename = $destinationfile.gettype().name
"DestinationFile was a $objtypename object"
}

# win32_computersystem
#  System hardware description
#  List format

# win32_operatingsystem
#  Operating system name and version number
#  List format

# win32_processor
#  Processor description, speed, number of cores, sizes of L1/2/3 caches

function getSystem {
	# cpu, OS, RAM, Video
	""
	"System Information"
	$system = Get-WmiObject win32_computersystem | select Manufacturer,Model,DNSHostName,Domain,SystemType,@{N="User"; E={$_.PrimaryOwnerName}}
	$system | Add-Member -NotePropertyName "OS" -NotePropertyValue (Get-WmiObject win32_operatingsystem).Caption
	$system | Add-Member -NotePropertyName "Version" -NotePropertyValue (Get-WmiObject win32_operatingsystem).Version
	$system | format-list
}

function getCPU {
	""
	"Processors"

	# Processor: MaxClockSpeed, NumberOfCores, L1/2/3 cache size if present
	Get-WmiObject win32_processor | select Manufacturer,Description,Name,`
		@{N="Max Clock Speed"; E={[string]([math]::Round($_.MaxClockSpeed/1000,2)) + "GHz"}},`
		NumberOfCores,`
		@{N="L1CacheSpeed"; E={ if ($_.L1CacheSpeed -ne $null){$_.L1CacheSpeed} else{"N/A"}}},`
		@{N="L2CacheSpeed"; E={ if ($_.L2CacheSpeed -ne $null){$_.L2CacheSpeed} else{"N/A"}}},`
		@{N="L3CacheSpeed"; E={ if ($_.L3CacheSpeed -ne $null){$_.L3CacheSpeed} else{"N/A"}}} | format-list
}

function getRam {
	""
	"Memory"
# win32_physicalmemory
#  RAM vendor, description, size, bank, slot for each DIMM (table), summary with total ram
	$ramTotal = 0
	$RamObject = Get-WmiObject win32_physicalmemory | Select Manufacturer,Description,`
		@{N="Capacity"; E={[string]($_.Capacity/1gb) + "GB"}},`
		@{N="Bank"; E={ if([int]$_.BankLabel -gt 0) {$_.BankLabel} else {"N/A"}	} },`
		@{N="Slot"; E={$_.DeviceLocator}}
	$RamObject | foreach-object {$ramTotal += $_.Capacity}

	$RamObject | format-table

	Write-Host "RAM total:"(${ramTotal}/1gb)"GB"
}
#getSystem
#getCPU

# win32_diskdrive, win32_diskpartition, win32_logicaldisk
#  Vendor, model, size, space (max, free, percentage in a table, one logical disk per line)

function getDisk {
	# disk report only
	#$disks = Get-WmiObject Win32_LogicalDisk | Select {$_.GetRelated("Win32_DiskPartition").DeviceID}
	""
	"Storage"
	$diskInfo = Get-WmiObject win32_logicaldisk | select Description,DeviceID,Filesystem,`
		@{N="Manufacturer"; E={`
			$tempID = $_.DeviceId;`
			if($_.Description -eq "CD-ROM Disc"){(Get-WmiObject Win32_CdromDrive | Where {$_.Id -eq $tempID}).Manufacturer}`
			#else{($_.GetRelated("Win32_DiskPartition") | Select {$_.GetRelated("Win32_DiskDrive").Manufacturer})}`
			# Whew, this took so much trial and error.
			# Chaining GetRelated() felt like a breakthrough
			else{($_.GetRelated("Win32_DiskPartition").GetRelated("Win32_DiskDrive").Manufacturer)}`
		}},`
		# Definitely just copying and pasting that instead of finding a better way
		@{N="Model"; E={`
			$tempID = $_.DeviceId;`
			if($_.Description -eq "CD-ROM Disc"){(Get-WmiObject Win32_CdromDrive | Where {$_.Id -eq $tempID}).Name}`
			else{($_.GetRelated("Win32_DiskPartition").GetRelated("Win32_DiskDrive").Model)}`
		}},`
		@{N="Free (GB)"; E={[math]::Round($_.FreeSpace/1gb,2)}},`
		@{N="Total (GB)"; E={[math]::Round($_.Size/1gb,2)}},`
		@{N="Free (%)"; E={[math]::Round($_.FreeSpace/$_.Size,2)*100}},`
		@{N="Location"; E={if($_.Description -eq "CD-ROM Disc"){ "Optical Media"} else {$_.GetRelated("win32_diskpartition").DeviceID}}}

	$diskInfo | format-table
	
}

# win32_videocontroller
#  Video card vendor, description, resolution (w x h)
function getVideo {
	""
	"Display"
	Get-WmiObject Win32_VideoController | `
		Select Description, `
		@{N="Resolution"; E={[string]$_.CurrentHorizontalResolution + " x " + [string]$_.CurrentVerticalResolution}}, `
		@{N="Manufacturer"; E={$_.GetRelated("Win32_PnPEntity").Manufacturer}} `
		| Format-List
	
}

function systemreport{
	param ([Switch]$System,
	   [Switch]$Disks,
	   [Switch]$Network)
	if(($System -eq $false) -And ($Disks -eq $false) -And ($Network -eq $false)){
		getSystem;
		getCPU;
		getRam;
		getDisk;
		""; "Network"; getnet;
	}
	else{
		if($System -eq $true){ getSystem; getCPU; getRam; }
		if($Disks -eq $true){ getDisk; }
		if($Network -eq $true){ ""; "Network"; getnet; }
	}
}


# win32_computersystem
#  System hardware description
#  List format

# win32_operatingsystem
#  Operating system name and version number
#  List format

# win32_processor
#  Processor description, speed, number of cores, sizes of L1/2/3 caches



# win32_videocontroller
#  Video card vendor, description, resolution (w x h)

function getSystem {
	# cpu, OS, RAM, Video
	Write-Host "System Information"
	$system = Get-WmiObject win32_computersystem | select Manufacturer,Model,DNSHostName,Domain,SystemType,@{N="User"; E={$_.PrimaryOwnerName}}
	$system | Add-Member -NotePropertyName "OS" -NotePropertyValue (Get-WmiObject win32_operatingsystem).Caption
	$system | Add-Member -NotePropertyName "Version" -NotePropertyValue (Get-WmiObject win32_operatingsystem).Version
	$system | format-list
}

function getCPU {
	Write-Host "Processors"

	# Processor: MaxClockSpeed, NumberOfCores, L1/2/3 cache size if present
	Get-WmiObject win32_processor | select Manufacturer,Description,Name,`
		@{N="Max Clock Speed"; E={[string]([math]::Round($_.MaxClockSpeed/1000,2)) + "GHz"}},`
		NumberOfCores,`
		@{N="L1CacheSpeed"; E={ if ($_.L1CacheSpeed -ne $null){$_.L1CacheSpeed} else{"N/A"}}},`
		@{N="L2CacheSpeed"; E={ if ($_.L2CacheSpeed -ne $null){$_.L2CacheSpeed} else{"N/A"}}},`
		@{N="L3CacheSpeed"; E={ if ($_.L3CacheSpeed -ne $null){$_.L3CacheSpeed} else{"N/A"}}} | format-list
}

function getRam {
	Write-Host "Memory"
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
getRam

# win32_diskdrive, win32_diskpartition, win32_logicaldisk
#  Vendor, model, size, space (max, free, percentage in a table, one logical disk per line)

function getDisk {
	# disk report only
	
}

#Include getnet.ps1
function getNet {
	#network report only
}


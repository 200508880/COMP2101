Param ([Parameter(Mandatory=$true,position=1)][string]$SourceFile,
[Parameter(Mandatory=$true,position=2)][string]$DestinationFile )
"SourceFile was '$sourcefile'"
$objtypename = $sourcefile.gettype().name
"SourceFile was a $objtypename object"
"DestinationFile was '$destinationfile'"
$objtypename = $destinationfile.gettype().name
"DestinationFile was a $objtypename object"
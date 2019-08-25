param (
	[Parameter(Mandatory=$true)]
	[string]
	$VariableName,

	[Parameter(Mandatory=$true)]
	[version]
	$Value,

	[uint16]
	$Increment = 1
)

Write-Host "##vso[task.setvariable variable=$VariableName;issecret=false]$([version]::new($Value.Major, $Value.Minor, $Value.Build, $Value.Revision + $Increment))"

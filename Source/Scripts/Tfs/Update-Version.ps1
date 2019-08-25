param (
	[Parameter(Mandatory=$true)]
	[string]
	$VariableName,

	[Parameter(Mandatory=$true)]
	[version]
	$Value,

	[Parameter(Mandatory=$true)]
	[string]
	$Organization,

	[string]
	$Project = $env:SYSTEM_TEAMPROJECT,

	[Parameter(Mandatory=$true)]
	[uint16]
	$VariableGroupId,

	[Parameter(Mandatory=$true)]
	[string]
	$User,

	[Parameter(Mandatory=$true)]
	[string]
	$Token,

	[Parameter(HelpMessage="Persist in build session.")]
	[switch]
	$KeepInSession,

	[string]
	$ApiVersion = 'api-version=5.1-preview.1'
)

$getResponse = & $PSScriptRoot\Get-Version.ps1 `
	-VariableName $VariableName `
	-Organization $Organization `
	-Project $Project `
	-VariableGroupId $VariableGroupId `
	-User $User `
	-Token $Token `
	-ApiVersion $ApiVersion

$body = @{
	'variables' = @{
		$VariableName = "$Value"
	};
	
	'type' = $getResponse.type
	'name' = $getResponse.name
	'description' = $getResponse.description
}

$auth = [convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("${User}:${Token}"))

$response = Invoke-RestMethod `
	-Uri https://dev.azure.com/${Organization}/${Project}/_apis/distributedtask/variablegroups/${VariableGroupId}?${ApiVersion} `
	-Headers @{ Authorization="Basic $auth" } `
	-Method Put `
	-ContentType 'application/json' `
	-Body (ConvertTo-Json $body)

if ($KeepInSession) {
	Write-Host "##vso[task.setvariable variable=$VariableName;issecret=false]$($response.variables.$VariableName.value)"
}

return $response

param (
	[Parameter(Mandatory=$true)]
	[string] $VariableName,

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
	$Token = $env:SYSTEM_ACCESSTOKEN,

	[Parameter(HelpMessage="Persist in build session.")]
	[switch]
	$KeepInSession,

	[string]
	$ApiVersion = 'api-version=5.1-preview.1'
)

$auth = [convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("${User}:${Token}"))

$response = Invoke-RestMethod `
	-Uri https://dev.azure.com/${Organization}/${Project}/_apis/distributedtask/variablegroups/${VariableGroupId}?${ApiVersion} `
	-Headers @{ Authorization="Basic $auth" } `
	-Method Get

if ($KeepInSession) {
	Write-Host "##vso[task.setvariable variable=$VariableName;issecret=false]$($response.variables.$VariableName.value)"
}

return $response

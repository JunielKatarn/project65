param (
	[Parameter(Mandatory=$true)]
	[string] $VariableName
)

Import-Module VSTeam

Add-VSTeamAccount `
  -Account $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI `
  -PersonalAccessToken $env:SYSTEM_ACCESSTOKEN

$successfulBuilds =	Get-VSTeamBuild `
						-ResultFilter succeeded `
						-Definitions $env:BUILD_TRIGGEREDBY_DEFINITIONID `
						-ProjectName $env:SYSTEM_TEAMPROJECT
$version = "0.0.0.$($successfulBuilds.Count + 1)"
# Use the environment variables input below to pass secret variables to this script.
Write-Host "##vso[task.setvariable variable=$VariableName;issecret=false]$version"
#
# Bootstrap.ps1
#
param (
	$Git		= "${env:ProgramFiles}\Git\cmd\git.exe",
	$Nuget		= 'NuGet.exe'
)

Push-Location

$rootDir = $PSScriptRoot | Split-Path | Split-Path
Set-Location $rootDir

# Restore Git submoudles.
& $Git submodule update --init

Set-Location $rootDir\ReactWindows

# Restore packages.
& $NuGet restore

Pop-Location

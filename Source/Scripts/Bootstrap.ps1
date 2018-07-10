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

# Copy static files
Copy-Item .\Source\Cpp\Project64-core\Version.h .\modules\project64\Source\Project64-core\

# Restore packages.
& $NuGet restore

Pop-Location

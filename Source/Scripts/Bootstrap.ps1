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
$msbuildVersion = '15.7.179'
& $NuGet install `
	-Source https://api.nuget.org/v3/index.json `
	-OutputDirectory $rootDir\Build\NuGet\packages `
	-Version $msbuildVersion `
	Microsoft.Build

& $NuGet install `
	-Source https://api.nuget.org/v3/index.json `
	-OutputDirectory $rootDir\Build\NuGet\packages `
	-Version $msbuildVersion `
	Microsoft.Build.Utilities.Core

# Copy .NET Framework DLLs to library directory.
New-Item -ItemType Directory $rootDir\Build\bin -Force | Out-Null
Get-ChildItem -Path $rootDir\Build\NuGet\packages -Recurse -Include '*.dll' | `
	Where-Object { $_ -match 'net45' -or $_ -match 'net46' } | `
	ForEach-Object { Copy-Item $_ $rootDir\Build\bin\ }

Pop-Location

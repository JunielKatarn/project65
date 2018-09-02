#
# Layout.ps1
#
# Updates the sources and headers based in the Project64 code base.
#
param (
	[ValidateSet('x86')]
	[string] $Platform = 'x86',
	[ValidateSet('Debug', 'Release')]
	[string] $Configuration = 'Release',
	[string] $InstallDir = "$($PSScriptRoot | Split-Path | Split-Path)\Target\$Platform\$Configuration\Project64"
)

$root = $PSScriptRoot | Split-Path | Split-Path
$pj64Root = "$root\modules\project64"
$targetRoot = "$root\Target\$Platform\$Configuration"

# Ensure install paths exists
New-Item -ItemType Directory -Force $InstallDir | Out-Null
('Audio', 'GFX', 'Input', 'RSP') | ForEach-Object { New-Item -ItemType Directory -Force $InstallDir\Plugin\$_ | Out-Null }
('Lang', 'Config') | ForEach-Object { Copy-Item -Recurse -Force $pj64Root\$_ $InstallDir\ }
Copy-Item -Recurse -Force $root\Source\Config $InstallDir

# Copy binaries
Copy-Item $targetRoot\Project64\Project64.exe $InstallDir\ -ErrorAction Ignore # Ignore if source dir == target dir.
Copy-Item $targetRoot\Project64-audio\Project64-audio.dll $InstallDir\Plugin\Audio\
Copy-Item $targetRoot\Project64-input\Project64-input.dll $InstallDir\Plugin\Input\
Copy-Item $targetRoot\Project64-video\Project64-video.dll $InstallDir\Plugin\GFX\
Copy-Item $targetRoot\RSP\RSP.dll $InstallDir\Plugin\RSP\

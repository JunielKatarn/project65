#
# Layout.ps1
#
# Updates the sources and headers based in the Project64 code base.
#
param (
	[ValidateSet('Win32')]
	[string] $Platform = 'Win32',
	[ValidateSet('Debug', 'Release')]
	[string] $Configuration = 'Release'
)

$root = $PSScriptRoot | Split-Path | Split-Path
$pj64Root = "$root\modules\project64"
$targetRoot = "$root\Target\$Platform\$Configuration"
$installDir = "$targetRoot\Project64"

('Lang', 'Config') | ForEach-Object { Copy-Item -Recurse -Force $pj64Root\$_ $installDir\ }
('Audio', 'GFX', 'Input', 'RSP') | ForEach-Object { New-Item -ItemType Directory -Force $installDir\Plugin\$_ }
Copy-Item -Recurse -Force $root\Source\Config $installDir

# Copy plugins
Copy-Item $targetRoot\Project64-audio\Project64-audio.dll $installDir\Plugin\Audio\
Copy-Item $targetRoot\Project64-input\Project64-input.dll $installDir\Plugin\Input\
Copy-Item $targetRoot\Project64-video\Project64-video.dll $installDir\Plugin\GFX\
Copy-Item $targetRoot\RSP\RSP.dll $installDir\Plugin\RSP\
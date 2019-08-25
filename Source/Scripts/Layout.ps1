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

	[string]
	$Path = "$($PSScriptRoot | Split-Path | Split-Path)\Target\$Platform\$Configuration\Project64",

	[switch]
	$ClickOnce
)

$root = $PSScriptRoot | Split-Path | Split-Path
$pj64Root = "$root\modules\project64"
$targetRoot = "$root\Target\$Platform\$Configuration"

# Ensure install paths exists
New-Item -ItemType Directory -Force $Path | Out-Null
('Audio', 'GFX', 'Input', 'RSP') | ForEach-Object {
	New-Item -ItemType Directory -Force $Path\Plugin\$_ | Out-Null
}
('Lang', 'Config') | ForEach-Object {
	Copy-Item -Recurse -Force $pj64Root\$_ $Path\
}
Copy-Item -Recurse -Force $root\Source\Config $Path

# Copy binaries
Copy-Item $targetRoot\Project64\Project64.exe $Path\ -ErrorAction Ignore # Ignore if source dir == target dir.
Copy-Item $targetRoot\Project64\Project64.pdb $Path\ -ErrorAction Ignore # Ignore if source dir == target dir.
Copy-Item $targetRoot\Project64-audio\Project64-audio.dll $Path\Plugin\Audio\
Copy-Item $targetRoot\Project64-audio\Project64-audio.pdb $Path\Plugin\Audio\
Copy-Item $targetRoot\Project64-video\Project64-video.dll $Path\Plugin\GFX\
Copy-Item $targetRoot\Project64-video\Project64-video.pdb $Path\Plugin\GFX\
Copy-Item $targetRoot\NRage_Input_V2\NRage_Input_V2.dll $Path\Plugin\Input\
Copy-Item $targetRoot\NRage_Input_V2\NRage_Input_V2.pdb $Path\Plugin\Input\
Copy-Item $targetRoot\RSP\RSP.dll $Path\Plugin\RSP\
Copy-Item $targetRoot\RSP\RSP.pdb $Path\Plugin\RSP\

# ClickOnce binaries
if ($ClickOnce) {
	Copy-Item $targetRoot\Project65.ClickOnce\*.exe $Path -ErrorAction Ignore # Ignore if source dir == target dir.
}
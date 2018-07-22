param(
	[string] $Publisher = 'Hyvart Software',
	[string] $AppName = 'Project65',
	[ValidateSet('x86', 'Win32')]
	[string] $Platform = 'Win32',
	[ValidateSet('Debug', 'Release')]
	[string] $Configuration = 'Release',
	[string] $StagingDir = "$($PSScriptRoot | Split-Path | Split-Path)\Target\$Platform\$Configuration\Project64",
	[Parameter(Mandatory=$true)]
	[version] $Version,
	[Parameter(Mandatory=$true)]
	[string] $ProviderUrlBase,
	[string] $Mage = "${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.7.1 Tools\mage.exe"
)

$appManifest = "$AppName.manifest"
$deployManifest = "$AppName.application"
$processor = ($Platform, 'x86')[$Platform -eq 'Win32'] # Win32 IS x86

# Create application manifest
& $Mage	-New			'Application' `
		-Processor		$processor `
		-Name			$AppName `
		-Version		$Version `
		-FromDirectory	$StagingDir `
		-ToFile			"$StagingDir\$appManifest"

# Create deployment manifest
& $Mage	-New			'Deployment' `
		-Processor		$processor `
		-Publisher		$Publisher `
		-Version		$Version `
		-Install		'true' `
		-ProviderUrl	"$ProviderUrlBase/$deployManifest" `
		-AppCodeBase	"$ProviderUrlBase/$appManifest" `
		-AppManifest	"$StagingDir\$appManifest" `
		-ToFile			"$StagingDir\$deployManifest"

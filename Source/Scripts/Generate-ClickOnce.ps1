param(
	[string]
	$Publisher = 'Hyvart Software',

	[string]
	$AppName = 'Project65',

	[ValidateSet('x86', 'x64')]
	[string]
	$Platform = 'x86',

	[ValidateSet('Debug', 'Release')]
	[string]
	$Configuration = 'Release',

	[System.IO.DirectoryInfo]
	$StagingDir = "$($PSScriptRoot | Split-Path | Split-Path)\Target\$Platform\$Configuration\Project64",

	[Parameter(Mandatory=$true)]
	[version] $Version,

	[Parameter(Mandatory=$true)]
	[string] $ProviderUrlBase,

	[string]
	$NetfxVersion = '4.7.2',

	[string] $Mage = "${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v10.0A\bin\NETFX $NetfxVersion Tools\mage.exe"
)

$appManifest = "$AppName.manifest"
$deployManifest = "$AppName.application"

# Create application manifest
& $Mage	-New			'Application' `
		-Processor		$Platform `
		-Name			$AppName `
		-Version		$Version `
		-FromDirectory	$StagingDir `
		-ToFile			"$StagingDir\$appManifest"

# Create deployment manifest
& $Mage	-New			'Deployment' `
		-Processor		$Platform `
		-Publisher		$Publisher `
		-Version		$Version `
		-Install		'true' `
		-ProviderUrl	"$ProviderUrlBase/$deployManifest" `
		-AppCodeBase	"$ProviderUrlBase/$appManifest" `
		-AppManifest	"$StagingDir\$appManifest" `
		-ToFile			"$StagingDir\$deployManifest"

$importRoot = "$($PSScriptRoot | Split-Path | Split-Path)\modules\project64\Source"
$exportRoot = "$($PSScriptRoot | Split-Path)\MSBuild"

$projectMap = @{
	'3rdParty\7zip\7zip.vcxproj'				= '7zip.vcxproj'
	'3rdParty\duktape\duktape.vcxproj'			= 'duktape.vcxproj'
	'3rdParty\png\png.vcxproj'					= 'png.vcxproj'
	'3rdParty\WTL\WTL.vcxproj'					= 'WTL.vcxproj'
	'3rdParty\zlib\zlib.vcxproj'				= 'zlib.vcxproj'
	'Common\Common.vcxproj' 		 			= 'Common.vcxproj'
	'nragev20\NRage_Input_V2.vcxproj' 			= 'Project64-input.vcxproj'
	'Project64\Project64.vcxproj' 				= 'Project64.vcxproj'
	'Project64-audio\Project64-audio.vcxproj'	= 'Project64-audio.vcxproj'
	'Project64-core\Project64-core.vcxproj'		= 'Project64-core.vcxproj'
	'Project64-video\Project64-video.vcxproj'	= 'Project64-video.vcxproj'
	'RSP\RSP.vcxproj'							= 'RSP.vcxproj'
	'Settings\Settings.vcxproj'					= 'Settings.vcxproj'
}

$basePathMap = @{}
$projectMap.Keys | ForEach-Object {
	$lastIndex = $_.LastIndexOfAny('/\')
	if ($lastIndex -gt 0) {
		$basePathMap[$_] = $_.Substring(0, $lastIndex)
	} else {
		$basePathMap[$_] = ''
	}
}

$projectMap.Keys | ForEach-Object {
	& $PSScriptRoot\Import-Project.ps1 -Source "$importRoot\$_" -Target "$exportRoot\$($projectMap[$_])" -ItemPath $basePathMap[$_]
}

#
# Import-Project.ps1
#
# Imports the sources and headers based from the source project into the target project.
#
param (
	[Parameter(Mandatory=$true)]
	[string] $Source,
	[Parameter(Mandatory=$true)]
	[string] $Target,
	[string] $ItemPath,
	[string]
	$MSBuildHome = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0"
)

#Add-Type -Path "$MSBuildHome\Bin\Microsoft.Build.dll"
Add-Type -Path "$($PSScriptRoot | Split-Path | Split-Path)\Build\lib\Microsoft.Build.dll"

#TODO: Process VCXPROJ projects in order.
# $project64Sln = (Get-ChildItem .\modules\project64\Project64.sln).FullName
# $sln = [Microsoft.Build.Construction.SolutionFile]::Parse($project64Sln)

# Default options
$options = [Microsoft.Build.Definition.ProjectOptions]::new()
$itemTypes = ('ClInclude', 'ClCompile', 'None', 'ResourceCompile')

$importedProject = [Microsoft.Build.Evaluation.Project]::FromFile((Get-ChildItem $Source).FullName, $options)
$importedItems = $importedProject.Items | Where-Object { $_.ItemType -in $itemTypes }

$targetProject = [Microsoft.Build.Evaluation.Project]::FromFile((Get-ChildItem $Target).FullName, $options)
$targetProject.SkipEvaluation = $true

# Clear items from target project.
$oldItems = $targetProject.Items | Where-Object { $_.ItemType -in $itemTypes -and $_.Xml.Label -eq 'Imported' }
$oldItems | ForEach-Object { $targetProject.RemoveItem($_) } | Out-Null

$filtersProject = New-Object -TypeName 'Microsoft.Build.Evaluation.Project'
$filtersProject.SkipEvaluation = $true

# Filter roots by item type
$filterRoots = @{
	'ClInclude'			= 'Header Files'
	'ClCompile'			= 'Source Files'
	'None'				= 'Resource Files'
	'ResourceCompile'	= 'Resource Files'
}
$filterNames = @{
	'Header Files'	= $true
	'Source Files'	= $true
	'Resource Files'= $true
}
$filterExtensions = @{
	'Header Files'	= 'h;hpp;hxx;hm;inl'
	'Source Files'	= 'cpp;c;cxx;rc;def;r;odl;idl;hpj;bat'
	'Resource Files'= 'ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe'
}

$filterNames.Keys | ForEach-Object {
	$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
	$metadata['UniqueIdentifier'] = "{$([Guid]::NewGuid())}"
	$metadata['Extensions'] = $filterExtensions[$_]
	$filtersProject.AddItem('Filter', $_, $metadata) | Out-Null
}

$importedItems | ForEach-Object {
	# Copy item path for manipulation.
	$filterPath = $filterRoots[$_.ItemType] + '\' + ($_.UnevaluatedInclude -replace '\.\.\\','')
	$lastIndex = $filterPath.LastIndexOfAny('/\')
	while ($lastIndex -gt 0) {
		$filterPath = $filterPath.Substring(0, $lastIndex)

		if (! $filterNames[$filterPath]) {
			$filterNames[$filterPath] = $true
			$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
			$metadata['UniqueIdentifier'] = "{$([Guid]::NewGuid())}"
			$filtersProject.AddItem('Filter', $filterPath, $metadata) | Out-Null
		}
		$lastIndex = $filterPath.LastIndexOfAny('/\')
	}

	$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
	$_.DirectMetadata | Where-Object { $_.Name -in ('ExcludedFromBuild') } | ForEach-Object { $metadata[$_.Name] = $_.UnevaluatedValue }

	$unevaluatedInclude = "`$(SourceRoot)$ItemPath\$($_.UnevaluatedInclude)"

	$item = $targetProject.AddItem($_.ItemType, $unevaluatedInclude, $metadata)
	$item.Xml.Label = 'Imported'
	# When metadata is not empty, Include gets evaluated.
	$item | ForEach-Object { $_.UnevaluatedInclude = $unevaluatedInclude }

	# Add items with filter.
	$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
	$metadata['Filter'] = $filterRoots[$_.ItemType]
	$lastIndex = $_.UnevaluatedInclude.LastIndexOfAny('/\')
	if ($lastIndex -gt 0) {
		$metadata['Filter'] += "\$($_.UnevaluatedInclude.Substring(0, $lastIndex))" -replace '\.\.\\',''
	}
	$filterItem = $filtersProject.AddItem($_.ItemType, $unevaluatedInclude, $metadata)
	# When metadata is not empty, Include gets evaluated.
	$filterItem | ForEach-Object { $_.UnevaluatedInclude = $unevaluatedInclude }
}

$targetProject.Save()
$filtersProject.Save("$Target.filters")

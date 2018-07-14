#
# Update-Project.ps1
#
# Updates the sources and headers based in the Project64 code base.
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

Add-Type -Path "$MSBuildHome\Bin\Microsoft.Build.dll"

#TODO: Process VCXPROJ projects in order.
# $project64Sln = (Get-ChildItem .\modules\project64\Project64.sln).FullName
# $sln = [Microsoft.Build.Construction.SolutionFile]::Parse($project64Sln)

# Default options
$options = [Microsoft.Build.Definition.ProjectOptions]::new()
$itemTypes = ('ClInclude', 'ClCompile', 'None', 'ResourceCompile')

$importedProject = [Microsoft.Build.Evaluation.Project]::FromFile((Get-ChildItem $Source).FullName, $options)
$importedItems = $importedProject.Items | Where-Object { $_.ItemType -in $itemTypes }

$targetProject = [Microsoft.Build.Evaluation.Project]::FromFile((Get-ChildItem $Target).FullName, $options)

# Clear items.
$oldItems = $targetProject.Items | Where-Object { $_.ItemType -in $itemTypes -and $_.Xml.Label -eq 'Imported' }
$oldItems | ForEach-Object { $targetProject.RemoveItem($_) }

$filtersProject = New-Object -TypeName 'Microsoft.Build.Evaluation.Project'

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
	$filtersProject.AddItem('Filter', $_, $metadata)
}

$importedItems | ForEach-Object {
	$path = $_.UnevaluatedInclude

	# Copy item path for manipulation.
	$filterPath = $path
	$lastIndex = $filterPath.LastIndexOfAny('/\')
	while ($lastIndex -gt 0) {
		$filterPath = $filterPath.Substring(0, $lastIndex)

		if (! $filterNames[$filterPath]) {
			$filterNames[$filterPath] = $true
			$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
			$metadata['UniqueIdentifier'] = "{$([Guid]::NewGuid())}"
			$filtersProject.AddItem('Filter', "$($filterRoots[$_.ItemType])\$filterPath", $metadata)
		}
		$lastIndex = $filterPath.LastIndexOfAny('/\')
	}

	$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
	$_.DirectMetadata | Where-Object { $_.Name -in ('ExcludedFromBuild') } | ForEach-Object { $metadata[$_.Name] = $_.UnevaluatedValue }

	#TODO: When metadata is not empty, Include gets evaluated.
	echo "`$(SourceRoot)$ItemPath\$path"
	$item = $targetProject.AddItem($_.ItemType, "`$(SourceRoot)$ItemPath\$path", $metadata)
	$item.Xml.Label = 'Imported'

	# Add items with filter.
	$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
	$metadata['Filter'] = $filterRoots[$_.ItemType]
	$lastIndex = $path.LastIndexOfAny('/\')
	if ($lastIndex -gt 0) {
		$metadata['Filter'] += "\$($path.Substring(0, $lastIndex))"
	}
	$filtersProject.AddItem($_.ItemType, "`$(SourceRoot)$path", $metadata)
}

$targetProject.Save()
$filtersProject.Save("$Target.filters")

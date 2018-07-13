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
$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
$metadata['UniqueIdentifier'] = "{$([Guid]::NewGuid())}"
$metadata['Extensions'] = 'cpp;c;cxx;rc;def;r;odl;idl;hpj;bat'
$filtersProject.AddItem('Filter', 'Source Files', $metadata)
$metadata['UniqueIdentifier'] = "{$([Guid]::NewGuid())}"
$metadata['Extensions'] = 'h;hpp;hxx;hm;inl'
$filtersProject.AddItem('Filter', 'Header Files', $metadata)
$filtersProject.Save("$Target.filters")

$importedItems | ForEach-Object {
	$metadata = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.String]'
	$_.DirectMetadata | Where-Object { $_.Name -in ('ExcludedFromBuild') } | ForEach-Object { $metadata[$_.Name] = $_.UnevaluatedValue }

	#TODO: When metadata is not empty, Include gets evaluated.
	$item = $targetProject.AddItem($_.ItemType, "`$(SourceRoot)$ItemPath\$($_.UnevaluatedInclude)", $metadata)
	$item.Xml.Label = 'Imported'
}

$targetProject.Save()

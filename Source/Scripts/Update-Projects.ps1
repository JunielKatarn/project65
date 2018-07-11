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

$importedItems | ForEach-Object {
	$item = $targetProject.AddItem($_.ItemType, "`$(SourceRoot)$ItemPath\$($_.UnevaluatedInclude)")
	$item.Xml.Label = 'Imported'
}

$targetProject.Save()

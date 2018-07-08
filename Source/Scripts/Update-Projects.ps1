#
# Update-Project.ps1
#
# Updates the sources and headers based in the Project64 code base.
#
param (
	$MSBuildHome = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0"
)

Add-Type -Path "$MSBuildHome\Bin\Microsoft.Build.dll"

#TODO: Process VCXPROJ projects in order.
# $project64Sln = (Get-ChildItem .\modules\project64\Project64.sln).FullName
# $sln = [Microsoft.Build.Construction.SolutionFile]::Parse($project64Sln)

# Default options
$options = $options = [Microsoft.Build.Definition.ProjectOptions]::new()

$projectPath = (Get-ChildItem .\modules\project64\Source\Common\Common.vcxproj).FullName
$sourceProject = [Microsoft.Build.Evaluation.Project]::FromFile($projectPath, $options)
$headers = $sourceProject.Items | Where-Object { $_.ItemType -eq 'ClInclude' }
$sources = $sourceProject.Items | Where-Object { $_.ItemType -eq 'ClCompile' }

$projectPath = (Get-ChildItem .\Source\MSBuild\Common.vcxproj).FullName
$targetProject = [Microsoft.Build.Evaluation.Project]::FromFile($projectPath, $options)

# foreach ($header in $headers) {
# 	$targetProject.AddItem($header.ItemType, "`$(SourceRoot)Common\$($header.UnevaluatedInclude)")
# }
$headers | ForEach-Object { $targetProject.AddItem($_.ItemType, "`$(SourceRoot)Common\$($_.UnevaluatedInclude)") }
$sources | ForEach-Object { $targetProject.AddItem($_.ItemType, "`$(SourceRoot)Common\$($_.UnevaluatedInclude)") }

$targetProject.Save()

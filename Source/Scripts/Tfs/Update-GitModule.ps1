param(
    [string] $UserToken
)

git submodule update --remote
git add modules/project64

Push-Location
Set-Location modules\project64
[string] $commitId = git rev-parse HEAD
Pop-Location

$branch = "modules/project64/sync-$env:BUILD_BUILDID"
git branch $branch
git checkout $branch
git config user.email 'pj64@hyvart.com'
git config user.name 'Project65 Build Bot'
git commit -m "Update project64 to commit $commitId"

$pushUrl = "$env:BUILD_REPOSITORY_URI" -replace 'https://',"https://$UserToken@"
Write-Host "git push -u $pushUrl $branch"
git push -u $pushUrl $branch

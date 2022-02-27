git remote add upstream 'https://github.com/project64/project64'

if (git diff --name-only upstream/develop 'origin/develop') {
	$date = Get-Date
	$title = "Sync Project64 $(Get-Date -Date $date -AsUTC -Format 'yyyy-MM-dd HH:mm:ss')"

	git pull upstream develop
	git push origin develop

	gh pr create `
		--no-maintainer-edit `
		--repo JunielKatarn/project64 `
		--base pj65 `
		--head project64:develop `
		--title $title `
		--body 'Sync Pull Request'
} else {
	Write-Host 'No changes found'
}
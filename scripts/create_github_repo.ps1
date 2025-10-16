param(
  [string]$RepoName = "covid-tracker",
  [string]$Description = "COVID-19 tracker project",
  [string]$Visibility = "public" # public or private
)

# Requires a GITHUB_TOKEN environment variable with repo scope
if (-not $env:GITHUB_TOKEN) {
  Write-Error "Please set GITHUB_TOKEN environment variable with repo:create permissions."
  exit 1
}

$body = @{ name = $RepoName; description = $Description; private = ($Visibility -eq 'private') } | ConvertTo-Json
$resp = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers @{ Authorization = "token $env:GITHUB_TOKEN"; Accept = 'application/vnd.github+json' } -Body $body
Write-Host "Repository created: $($resp.html_url)"
Write-Host "Clone URL: $($resp.clone_url)"

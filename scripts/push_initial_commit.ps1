git init
git add .
git commit -m "Initial commit: covid-tracker"
git branch -M main
git remote add origin $RemoteUrl
git push -u origin main
param(
  [string]$RemoteUrl,
  [string]$Branch = "master"
)

if (-not $RemoteUrl) {
  Write-Error "Provide RemoteUrl (HTTPS)"
  exit 1
}

# Initialize git if needed, add files, and push to the specified branch
if (-not (Test-Path .git)) {
  git init
}

git add .
try {
  git commit -m "Initial commit: covid-tracker" -q
} catch {
  Write-Host "No changes to commit or commit failed - continuing"
}

# Create or reset branch locally to the requested branch name
git branch -M $Branch

if (-not (git remote | Select-String "origin")) {
  git remote add origin $RemoteUrl
} else {
  git remote set-url origin $RemoteUrl
}

Write-Host "Pushing local branch '$Branch' to $RemoteUrl (origin/$Branch)..."
# Use credential helper or prompt for credentials
git push -u origin $Branch
Write-Host "Pushed code to $RemoteUrl (branch: $Branch)"

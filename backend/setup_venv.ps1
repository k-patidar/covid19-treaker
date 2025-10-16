# PowerShell helper: create venv and install requirements for backend
$venvPath = "$PSScriptRoot/.venv"
python -m venv $venvPath
& "$venvPath\Scripts\Activate.ps1"
python -m pip install --upgrade pip
pip install -r "$PSScriptRoot/requirements.txt"
Write-Host "Virtual environment created at $venvPath and dependencies installed."

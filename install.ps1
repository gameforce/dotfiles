# temporary bypass execution policy
# powershell.exe -noprofile -executionpolicy bypass -file .\install.ps1
Set-ExecutionPolicy -Scope CurrentUser Bypass

# update winget
winget update

# update packages
winget upgrade --all --include-unknown

# Install PowerShell, Windows Terminal, oh-my-posh
winget install Microsoft.PowerShell
winget install Microsoft.WindowsTerminal
winget install JanDeDobbeleer.OhMyPosh

# reload PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# install the Nerd Font used by the p10k / oh-my-posh prompt
& (Join-Path $PSScriptRoot "fonts\install-nerd-font.ps1") -FontName "Hack"

# initialize oh-my-posh
$ohMyPoshTheme = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\powerlevel10k_modern.omp.json"
oh-my-posh --init --shell pwsh --config "$ohMyPoshTheme" | Invoke-Expression

# add oh-my-posh to $profile
Add-Content -Path $profile "`noh-my-posh --init --shell pwsh --config `"$ohMyPoshTheme`" | Invoke-Expression"

# install icons
Install-Module -Name Terminal-Icons -Repository PSGallery -Force

# add icons to $profile
Add-Content -Path $profile "`nImport-Module -Name Terminal-Icons"

# reload profile
. $PROFILE



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

# install icons
Install-Module -Name Terminal-Icons -Repository PSGallery -Force


# copy a repo file into place, keeping a dated backup of what was there
function Install-DotFile($Source, $Target) {
    New-Item -ItemType Directory -Force -Path (Split-Path $Target) | Out-Null
    if (Test-Path $Target) {
        if ((Get-FileHash $Source).Hash -eq (Get-FileHash $Target).Hash) {
            Write-Host "OK: $Target is up to date"
            return
        }
        Copy-Item $Target "$Target.bak-$(Get-Date -Format yyyy-MM-dd)"
    }
    Copy-Item $Source $Target -Force
    Write-Host "OK: installed $Target"
}

# PowerShell 7 profile (resolved from Documents so it works from powershell.exe too)
$pwshProfile = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "PowerShell\Microsoft.PowerShell_profile.ps1"
Install-DotFile (Join-Path $PSScriptRoot "terminal\powershell\Microsoft.PowerShell_profile.ps1") $pwshProfile

# Windows Terminal settings (Store/winget install, else unpackaged install)
$wtDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
if (-not (Test-Path $wtDir)) { $wtDir = "$env:LOCALAPPDATA\Microsoft\Windows Terminal" }
Install-DotFile (Join-Path $PSScriptRoot "terminal\windows-terminal\settings.json") (Join-Path $wtDir "settings.json")

Write-Host "Done. Open a new Windows Terminal tab to load the profile."

# Downloads and installs a Nerd Font (Mono variant) for the current user.
#
# Nothing font-related is vendored in this repo -- this always pulls
# whatever is currently the latest release from ryanoasis/nerd-fonts.
# Installs per-user (no admin rights required), so it works the same way
# on a locked-down machine as anywhere else. Covers Windows Terminal and
# ConEmu -- both just need a regular monospaced Nerd Font on the system,
# there's no separate "Windows compatible" build anymore (that naming was
# retired years ago upstream).
#
# Usage: .\install-nerd-font.ps1 [-FontName Hack]
param(
    [string]$FontName = "Hack"
)

$ErrorActionPreference = "Stop"

$releaseUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FontName.zip"
$zipPath = Join-Path $env:TEMP "$FontName-nerd-font.zip"
$extractDir = Join-Path $env:TEMP "$FontName-nerd-font"

Write-Host "-> Downloading $FontName Nerd Font from $releaseUrl..."
Invoke-WebRequest -Uri $releaseUrl -OutFile $zipPath

if (Test-Path $extractDir) { Remove-Item $extractDir -Recurse -Force }
Expand-Archive -Path $zipPath -DestinationPath $extractDir -Force

$fontDir = Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Fonts"
New-Item -ItemType Directory -Force -Path $fontDir | Out-Null
$regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

Write-Host "-> Installing the Mono variant (recommended for terminals) for the current user..."
Get-ChildItem -Path $extractDir -Filter "*NerdFontMono*.ttf" | ForEach-Object {
    $destPath = Join-Path $fontDir $_.Name
    Copy-Item $_.FullName $destPath -Force
    New-ItemProperty -Path $regPath -Name "$($_.BaseName) (TrueType)" -Value $_.Name -PropertyType String -Force | Out-Null
}

Remove-Item $zipPath -Force
Remove-Item $extractDir -Recurse -Force

Write-Host "OK: $FontName Nerd Font Mono installed to $fontDir"
Write-Host "   Set Windows Terminal / ConEmu's font to `"$FontName Nerd Font Mono`"."

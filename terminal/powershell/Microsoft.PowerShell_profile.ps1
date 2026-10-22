# PowerShell 7 profile, installed by install.ps1 (edit the copy in the dotfiles repo)

# 1. Custom SSH Wrapper Function with Tab Title Injection
function Connect-SSH {
    if ($args.Count -gt 0) {
        # Grab the last argument (e.g., 'nas')
        $hostName = $args[-1]
        # Send a clean native ANSI escape string to change the tab title
        Write-Host -NoNewline "$([char]27)]2;$hostName$([char]7)"
    }
    # Call the exact system path directly to avoid engine module confusion
    & C:\Windows\System32\OpenSSH\ssh.exe @args
}

# 2. Intercept 'ssh' command and route to our function
Set-Alias -Name ssh -Value Connect-SSH -Option AllScope -Force

# 3. Disable Oh My Posh from continuously resetting the title to PWD
$env:POSH_THEME_DISABLE_TITLE = "true"

# 4. Initialize Oh My Posh, if installed
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $themes = if ($env:POSH_THEMES_PATH) { $env:POSH_THEMES_PATH } else { "$env:LOCALAPPDATA\Programs\oh-my-posh\themes" }
    oh-my-posh init pwsh --config "$themes\powerlevel10k_modern.omp.json" | Invoke-Expression
}

# 4b. Tab title: host:path at every prompt (ssh wrapper above still sets the
#     remote host while a session is open)
$ompPrompt = $function:prompt
function prompt {
    $loc = $executionContext.SessionState.Path.CurrentLocation.ProviderPath
    if ($loc.StartsWith($HOME)) { $loc = '~' + $loc.Substring($HOME.Length) }
    $Host.UI.RawUI.WindowTitle = "$($env:COMPUTERNAME.ToLower()):$loc"
    & $ompPrompt
}

# 5. Load UI modules, if installed
if (Get-Module -ListAvailable -Name Terminal-Icons) {
    Import-Module -Name Terminal-Icons
}

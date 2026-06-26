## Install script for Windows PowerShell config (windows-config repo)
##
## Records the repo location in $env:WINCONFIG (User scope, persistent) so the config can
## live ANYWHERE and BOTH editions - PowerShell 7 and Windows PowerShell 5.1 - load it.
## Writes a one-line stub into each edition's $PROFILE that dot-sources the repo profile.
## Idempotent: safe to re-run.
##
## Usage:
##   .\install.ps1                       # repo location = folder this script lives in
##   .\install.ps1 -ConfigPath C:\src\windows-config\powershell   # explicit location
##   .\install.ps1 -InstallModules       # also install the PSGallery modules

[CmdletBinding()]
param(
    # Path to the powershell/ folder inside the repo. Defaults to this script's own
    # location\powershell (this script lives at repo root, next to the powershell/ folder).
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'powershell'),
    [switch]$InstallModules
)

$ErrorActionPreference = 'Stop'

# Normalise to an absolute path and verify it looks like the config folder.
$ConfigPath = (Resolve-Path $ConfigPath).Path
$repoProfile = Join-Path $ConfigPath 'profile.ps1'
if (-not (Test-Path $repoProfile)) {
    throw "No profile.ps1 found at '$ConfigPath'. Pass -ConfigPath pointing at the repo's powershell/ folder."
}

Write-Host "Installing config from: $ConfigPath" -ForegroundColor Cyan

# ------------------------------------------------------------------------------------------
# 1. Record the location persistently (User scope -> BOTH editions inherit it)
# ------------------------------------------------------------------------------------------
[Environment]::SetEnvironmentVariable('WINCONFIG', $ConfigPath, 'User')
$env:WINCONFIG = $ConfigPath   # also set in THIS session so it's usable immediately
Write-Host "Set WINCONFIG = $ConfigPath (User, persistent)" -ForegroundColor Green

# ------------------------------------------------------------------------------------------
# 2. Stub BOTH editions' all-hosts profile -> repo profile.ps1
# ------------------------------------------------------------------------------------------
# Each edition has its own profile folder (Documents\PowerShell vs Documents\WindowsPowerShell).
# We write a one-line stub into both so whichever you launch, it loads the same repo profile.
# Stub (not hardlink): no admin/symlink rights, and editors can't sever it.
$stubLine = ". `"$repoProfile`""

$profiles = @(
    (Join-Path $HOME 'Documents\PowerShell\profile.ps1')           # PowerShell 7+ (Core)
    (Join-Path $HOME 'Documents\WindowsPowerShell\profile.ps1')    # Windows PowerShell 5.1
)

foreach ($p in $profiles) {
    $dir = Split-Path $p
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    # Back up an existing real profile unless it's already our stub.
    if (Test-Path $p) {
        $existing = Get-Content $p -Raw -ErrorAction SilentlyContinue
        if ($existing -and ($existing -notmatch [regex]::Escape($repoProfile))) {
            $backup = "$p.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
            Move-Item $p $backup
            Write-Host "  Backed up $p -> $backup" -ForegroundColor Yellow
        }
    }

    Set-Content -Path $p -Value $stubLine -Encoding UTF8
    Write-Host "  Stub written: $p" -ForegroundColor Green
}

# ------------------------------------------------------------------------------------------
# 3. Windows Terminal Fragments via junction (no admin needed, works on directories)
# ------------------------------------------------------------------------------------------
$fragTarget = Join-Path (Split-Path $ConfigPath) 'WindowsTerminal\Fragments'   # repo\WindowsTerminal\Fragments
$fragLink   = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\Fragments'

if (Test-Path $fragTarget) {
    if (-not (Test-Path $fragLink)) {
        New-Item -ItemType Junction -Path $fragLink -Target $fragTarget | Out-Null
        Write-Host "Junctioned WT Fragments -> $fragTarget" -ForegroundColor Green
    }
    else {
        Write-Host "WT Fragments link already exists - skipping"
    }
}
else {
    Write-Host "No WT Fragments folder in repo - skipping" -ForegroundColor DarkGray
}

# ------------------------------------------------------------------------------------------
# 4. Let bin/ scripts run by bare name: add .PS1 to PATHEXT (User scope, persistent)
# ------------------------------------------------------------------------------------------
$curPE = [Environment]::GetEnvironmentVariable('PATHEXT', 'User')
if (-not $curPE) { $curPE = $env:PATHEXT }
if (";$curPE;" -notlike "*;.PS1;*") {
    [Environment]::SetEnvironmentVariable('PATHEXT', "$curPE;.PS1", 'User')
    Write-Host "Added .PS1 to PATHEXT (User) - run bin scripts by bare name" -ForegroundColor Green
}
else {
    Write-Host ".PS1 already in PATHEXT - skipping"
}

# ------------------------------------------------------------------------------------------
# 5. PSGallery modules the profile imports (only if -InstallModules)
# ------------------------------------------------------------------------------------------
# PSReadLine auto-loads and ships with PS7, so it's not installed here.
# git-aliases-plus is imported by the profile; install it yourself if you use it.
if ($InstallModules) {
    $modules = 'Terminal-Icons', 'posh-git', 'PSFzf'
    foreach ($m in $modules) {
        if (-not (Get-Module -ListAvailable -Name $m)) {
            Write-Host "Installing $m ..." -ForegroundColor Yellow
            Install-Module -Name $m -Repository PSGallery -Scope CurrentUser -Force
        }
        else {
            Write-Host "$m already installed - skipping"
        }
    }
}

# ------------------------------------------------------------------------------------------
# 6. Reminders
# ------------------------------------------------------------------------------------------
Write-Host "`nDone." -ForegroundColor Cyan
Write-Host "  - starship (if missing):  winget install Starship.Starship"
Write-Host "  - git-aliases-plus:        install if you use it (profile imports it)"
Write-Host "  - Open a NEW shell (either edition) to load the profile."
Write-Host "`nTo MOVE the config later: move the folder, then re-run:" -ForegroundColor Cyan
Write-Host "  .\install.ps1 -ConfigPath <new-path>\powershell"

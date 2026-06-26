## Install script for Windows PowerShell config (windows-config repo)
##
## Idempotent: safe to re-run. Wires up a STUB $PROFILE that dot-sources the repo profile
## (no symlink/hardlink needed), junctions the Windows Terminal Fragments folder, and
## installs the PSGallery modules the profile expects.

$ErrorActionPreference = 'Stop'

$profile_folder    = Split-Path $PROFILE
$powershell_config = Join-Path $profile_folder 'windows-config\powershell'
$repo_profile      = Join-Path $powershell_config 'profile.ps1'

# ------------------------------------------------------------------------------------------
# 1. $PROFILE -> stub that dot-sources the repo profile
# ------------------------------------------------------------------------------------------
# Target the all-hosts profile explicitly so this loads in the console, VS Code, ISE, etc.
# (The old install linked a file literally named profile.ps1 into the profile folder, which
#  only worked because the all-hosts profile happens to be named profile.ps1 - fragile.)
# Stub instead of hardlink: no admin/symlink rights needed, and editors can't sever it.
$profilePath = $PROFILE.CurrentUserAllHosts
$profileDir  = Split-Path $profilePath

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Back up any existing real profile (skip if it's already our stub).
if (Test-Path $profilePath) {
    $existing = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
    if ($existing -notmatch [regex]::Escape($repo_profile)) {
        $backup = "$profilePath.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
        Move-Item $profilePath $backup
        Write-Host "Backed up existing profile -> $backup" -ForegroundColor Yellow
    }
}

Set-Content -Path $profilePath -Value ". `"$repo_profile`"" -Encoding UTF8
Write-Host "Stub profile written: $profilePath -> $repo_profile" -ForegroundColor Green

# ------------------------------------------------------------------------------------------
# 2. Windows Terminal Fragments via junction (no admin needed, works on directories)
# ------------------------------------------------------------------------------------------
$fragTarget = Join-Path $profile_folder 'windows-config\WindowsTerminal\Fragments'
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
# 3. PSGallery modules the profile imports (only install if missing)
# ------------------------------------------------------------------------------------------
# Note: PSReadLine auto-loads and ships with PS7, so it's not installed here.
$modules = 'Terminal-Icons', 'posh-git', 'PSFzf', "git-aliases-plus"

foreach ($m in $modules) {
    if (-not (Get-Module -ListAvailable -Name $m)) {
        Write-Host "Installing $m ..." -ForegroundColor Yellow
        Install-Module -Name $m -Repository PSGallery -Scope CurrentUser -Force
    }
    else {
        Write-Host "$m already installed - skipping"
    }
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
# 5. Reminders for things not installed from the Gallery
# ------------------------------------------------------------------------------------------
Write-Host "`nNext steps (not handled here):" -ForegroundColor Cyan
Write-Host "  - starship:        winget install Starship.Starship"
Write-Host "  - Open a NEW shell to load the profile."

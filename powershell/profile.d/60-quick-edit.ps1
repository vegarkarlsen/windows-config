### ----------------------------------------------------------------------------------------
### 60-quick-edit.ps1  -  Helpers for editing this config, plus the lazy-tools loader
### ----------------------------------------------------------------------------------------

# Open a file's containing folder in the editor, edit it, then return.
function Edit-InEditor {
    param([Parameter(Mandatory)]$Path)
    $dir = if (Test-Path $Path -PathType Container) { $Path } else { Split-Path $Path }
    Push-Location $dir
    & $env:EDITOR $Path        # call operator handles spaces in paths
    Pop-Location
}

# Edit the live profile (all-hosts) and reload it.
function Edit-Profile {
    Edit-InEditor $PROFILE.CurrentUserAllHosts
    . $PROFILE.CurrentUserAllHosts
}

# Edit individual fragments. $env:WINCONFIG is set in profile.ps1.
function Edit-Env       { Edit-InEditor (Join-Path $env:WINCONFIG 'powershell\profile.d\00-env.ps1') }
function Edit-Aliases   { Edit-InEditor (Join-Path $env:WINCONFIG 'powershell\profile.d\20-aliases.ps1') }
function Edit-Overrides { Edit-InEditor (Join-Path $env:WINCONFIG 'powershell\profile.d\30-overrides.ps1') }
function Edit-Functions { Edit-InEditor (Join-Path $env:WINCONFIG 'powershell\profile.d\50-functions.ps1') }

function Edit-LocalProfile {
    $file = Join-Path $env:WINCONFIG 'powershell\local-profile.ps1'
    if (-not (Test-Path $file)) { New-Item -ItemType File -Path $file | Out-Null }
    Edit-InEditor $file
    . $file
}

function Edit-Nvim { Edit-InEditor "$env:LOCALAPPDATA\nvim" }

Set-Alias malias  Edit-Aliases
Set-Alias maliasl Edit-LocalProfile

# ------------------------------------------------------------------------------------------
#   Lazy tools loader
# ------------------------------------------------------------------------------------------
# For heavy / situational function sets you do NOT want loaded at startup. Drop a .ps1 in
# the repo's lazy/ folder and pull it in on demand:  Load-Tools <name>   (no extension).
function Load-Tools {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ArgumentCompleter({
            param($cmd, $param, $word)
            $dir = Join-Path $env:WINCONFIG 'lazy'
            if (Test-Path $dir) {
                Get-ChildItem "$dir\*.ps1" |
                    ForEach-Object { $_.BaseName } |
                    Where-Object { $_ -like "$word*" }
            }
        })]
        [string]$Name
    )
    $file = Join-Path $env:WINCONFIG "lazy\$Name.ps1"
    if (Test-Path $file) {
        . $file
        Write-Host "Loaded lazy tools: $Name" -ForegroundColor Green
    }
    else {
        Write-Warning "No lazy tool set named '$Name' in $($env:WINCONFIG)\lazy"
    }
}

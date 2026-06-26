### ----------------------------------------------------------------------------------------
### PowerShell profile entry point - Vegar Karlsen
###
### This file is intentionally thin. The real $PROFILE (in each edition) is a one-line stub
### that dot-sources this file. install.ps1 records the repo location in $env:WINCONFIG, and
### this profile reads it - so the config can live ANYWHERE, and both PowerShell 7 and
### Windows PowerShell 5.1 load the exact same files.
###
### To install / relocate: see install.ps1
### ----------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
#   Resolve the config root from $env:WINCONFIG (set persistently by install.ps1)
# ------------------------------------------------------------------------------------------
# Single source of truth. install.ps1 sets WINCONFIG at User scope, so both editions inherit
# it. The fallbacks only matter if the profile is somehow run before install.ps1 has set it.
if ($env:WINCONFIG -and (Test-Path $env:WINCONFIG)) {
    $ConfigRoot = "$env:WINCONFIG/powershell"
}
else {
    # Fallbacks, in order of preference. Adjust the first if you move the repo and haven't
    # yet (re)run install.ps1.
    $candidates = @(
        "$HOME\Documents\PowerShell\windows-config\powershell"          # PS7 default
        "$HOME\Documents\WindowsPowerShell\windows-config\powershell"   # 5.1 default
    )
    $ConfigRoot = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $ConfigRoot) { $ConfigRoot = $candidates[0] }   # last resort, may not exist
    $env:WINCONFIG = $ConfigRoot
}

# ------------------------------------------------------------------------------------------
#   Load every fragment in profile.d, in filename order
# ------------------------------------------------------------------------------------------
# Numeric prefixes (00-, 10-, ...) control load order. Drop a new file in and it just loads;
# no edit to this file required. A broken fragment warns instead of killing the whole profile.
$fragmentDir = Join-Path $ConfigRoot 'profile.d'
if (Test-Path $fragmentDir) {
    Get-ChildItem "$fragmentDir\*.ps1" | Sort-Object Name | ForEach-Object {
        try {
            . $_.FullName
        }
        catch {
            Write-Warning "profile.d: failed to load $($_.Name): $_"
        }
    }
}
else {
    Write-Warning "WINCONFIG resolved to '$ConfigRoot' but no profile.d found. Run install.ps1."
}

# ------------------------------------------------------------------------------------------
#   Machine-specific config (not committed; see local-profile.example.ps1)
# ------------------------------------------------------------------------------------------
$localProfile = Join-Path $ConfigRoot 'local-profile.ps1'
if (Test-Path $localProfile) {
    . $localProfile
}

# ------------------------------------------------------------------------------------------
#   Prompt (load last, after everything else is in place)
# ------------------------------------------------------------------------------------------
Invoke-Expression (&starship init powershell)

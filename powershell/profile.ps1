### ----------------------------------------------------------------------------------------
### PowerShell profile entry point - Vegar Karlsen
###
### This file is intentionally thin. The real $PROFILE is a one-line stub that
### dot-sources this file (see install.ps1). All real configuration lives in
### profile.d/ (loaded every session, in filename order).
###
### To install: see install.ps1
### ----------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
#   Single source of truth for the repo location
# ------------------------------------------------------------------------------------------
# Everything derives from this one variable. Never hard-code the Documents path anywhere
# else (that was the WindowsPowerShell-vs-PowerShell bug in the old config).
$ConfigRoot = Join-Path (Split-Path $PROFILE) 'windows-config\powershell'

# Expose it to child processes (and the Edit-*/Load-Tools helpers) so they can locate the repo.
$env:WINCONFIG = $ConfigRoot

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

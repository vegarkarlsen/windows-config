### ----------------------------------------------------------------------------------------
### 10-modules.ps1  -  Module imports and session settings
###
### These modules have load-time side effects we WANT at startup (prompt integration, key
### chords, icons), so eager import is correct here - unlike pure utility functions, which
### live in 50-functions.ps1.
### ----------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
#   PSReadLine - vi editing mode
# ------------------------------------------------------------------------------------------
# PSReadLine auto-loads, so we do not Import-Module it explicitly. Just configure it.
Set-PSReadLineOption -EditMode vi

# Optional extras - uncomment to taste:
# Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# Set-PSReadLineOption -BellStyle None

# ------------------------------------------------------------------------------------------
#   Modules with startup side effects (eager import is intentional)
# ------------------------------------------------------------------------------------------
Import-Module Terminal-Icons                            # nicer icons in listings
Import-Module PSFzf                                     # fuzzy finder
Import-Module git-aliases-plus -DisableNameChecking     # git aliases (oh-my-posh style)
Import-Module posh-git -ArgumentList 0, 0, 1            # git tab-completion + status

# PSFzf key chords
Set-PsFzfOption `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordProvider 'Ctrl+t'

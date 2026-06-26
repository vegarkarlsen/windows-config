### PowerShell template profile
### Version 1.01 - Vegar Karlsen
###
###
### ----------------------------------------------------------------------------------------


# ------------------------------------------------------------------------------------------
#   SETTINGS
# ------------------------------------------------------------------------------------------
# $env:VIRTUAL_ENV_DISABLE_PROMPT = 1                         # disable python (venv) prompt
Set-PSREadlineOption -EditMOde vi
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete    # get autocomplete menu on tab


# ------------------------------------------------------------------------------------------
#   Import Modules
# ------------------------------------------------------------------------------------------
Import-Module -Name Terminal-Icons                          # Nicer icons on ls
Import-Module -Name PSReadLine                              # PSReadLine (This may be deafult)
Import-Module -Name PSFzf                                   # Fuzzy finder
Import-Module -Name git-aliases-plus -DisableNameChecking   # Git aliases based on (oh-my-posh git plugin)
Import-Module -Name posh-git -arg 0,0,1                     # Automcomplete git commands

# Setup recursive fzf
Set-PsFzfOption `
  -PSReadlineChordReverseHistory 'Ctrl+r' `
  -PSReadlineChordProvider 'Ctrl+t'

# Optional: make history richer / more useful
# Set-PSReadLineOption -HistorySearchCursorMovesToEnd
# Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -BellStyle None

# ------------------------------------------------------------------------------------------
#   Soruce config files
# ------------------------------------------------------------------------------------------
$profile_folder = Split-Path $PROFILE
$powershell_config = "$profile_folder/windows-config/powershell"

. "$powershell_config/env.ps1"
. "$powershell_config/aliases.ps1"
. "$powershell_config/quick_edit.ps1"

if (Test-Path "$powershell_config/local-profile.ps1"){
        . "$powershell_config/local-profile.ps1"
    }

# ------------------------------------------------------------------------------------------
#   Load prompt
# ------------------------------------------------------------------------------------------
# oh-my-posh init pwsh --config "$powershell_config\custom_posh_themes\iterm2.omp.json" | Invoke-Expression
Invoke-Expression (&starship init powershell)

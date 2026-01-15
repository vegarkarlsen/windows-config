### PowerShell template profile
### Version 1.01 - Vegar Karlsen
###
### The Profile is inspired by Tim Sneath <tim@sneath.org>
### https://gist.github.com/timsneath/19867b12eee7fd5af2ba
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
# Import-Module -Name posh-git                                # Automcomplete git commands

# ------------------------------------------------------------------------------------------
#   Soruce config files
# ------------------------------------------------------------------------------------------
$profile_folder = Split-Path $PROFILE
$powershell_config = "$profile_folder/windows-config/powershell"

. "$powershell_config/env.ps1"
. "$powershell_config/aliases.ps1"


# ------------------------------------------------------------------------------------------
#   Load prompt
# ------------------------------------------------------------------------------------------
# oh-my-posh init pwsh --config "$powershell_config\custom_posh_themes\iterm2.omp.json" | Invoke-Expression
Invoke-Expression (&starship init powershell)

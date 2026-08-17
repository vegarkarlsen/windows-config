### ----------------------------------------------------------------------------------------
### 30-overrides.ps1  -  Deliberate overrides of built-in commands
###
### These reshape standard commands to behave more like their Linux counterparts.
### They MUST load eagerly (here, not in an auto-loaded module) so they take precedence
### the moment the shell starts. Grouping them in one clearly-named file documents the
### intent: "I am deliberately changing how standard commands behave."
### ----------------------------------------------------------------------------------------

# function Remove-AliasIfExists {
#     [CmdletBinding()]
#     param(
#         [Parameter(Mandatory)]
#         [string]$Name
#     )
#
#     if ( (Get-Command $Name -ErrorAction SilentlyContinue).CommandType -eq "Alias" ) {
#         Remove-Item Alias:$Name -Force
#     }
# }


# ------------------------------------------------------------------------------------------
#   cd - bare `cd` goes HOME
# ------------------------------------------------------------------------------------------

# NOTE: The override is not needed on pwsh >= 7.6.5. This feature is default
# if ((Get-Command cd -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
#     Remove-Item Alias:cd -Force
# }
# function cd {
#     param([string]$Path)
#     if (-not $Path) { Set-Location $HOME } else { Set-Location $Path }
# }

# Quick parent-directory traversal
function cd..   { Set-Location .. }
function cd...  { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# ------------------------------------------------------------------------------------------
#   Override built in ls with eza
# ------------------------------------------------------------------------------------------
if ((Get-Command ls -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
    Remove-Item Alias:ls -Force
}

function ls {
    # eza --icons --group-directories-first
    eza --group-directories-first $args
}
function la { eza -a }            # all, including dotfiles
function ll { eza -l }     # all, including hidden/system
function lla { eza -la }     # all, including hidden/system

# Remove sl command
if ((Get-Command sl -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
    Remove-Item Alias:sl -Force
}

if ((Get-Command tree -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
    Remove-Item Alias:tree -Force
}
function tree { eza --tree }

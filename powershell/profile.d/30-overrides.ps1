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
#   cd - bare `cd` goes HOME (full path), not to the drive root
# ------------------------------------------------------------------------------------------
# Old version used $env:HOMEPATH (no drive letter), which landed you at the drive root.
# $HOME is the full path (e.g. C:\Users\you).
if ((Get-Command cd -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
    Remove-Item Alias:cd -Force
}
function cd {
    param([string]$Path)
    if (-not $Path) { Set-Location $HOME } else { Set-Location $Path }
}

# Quick parent-directory traversal
function cd..   { Set-Location .. }
function cd...  { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# ------------------------------------------------------------------------------------------
#   ls / la / ll - Linux-style listing (hide dotfiles by default)
# ------------------------------------------------------------------------------------------
if ((Get-Command ls -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
    Remove-Item Alias:ls -Force
}
# function ls {
#     if ($args.Count -eq 0) {
#         Get-ChildItem | Where-Object { $_.Name -notmatch '^\.' }
#     }
#     elseif ($args -contains '-la' -or $args -contains '-al') {
#         Get-ChildItem -Force
#     }
#     elseif ($args -contains '-a') {
#         Get-ChildItem
#     }
#     else {
#         Get-ChildItem @args
#     }
# }
function ls {
    # eza --icons --group-directories-first
    eza --group-directories-first $args
}
function la { ls -a }            # all, including dotfiles
function ll { ls -l }     # all, including hidden/system
function lla { ls -la }     # all, including hidden/system


if ((Get-Command tree -ErrorAction SilentlyContinue).CommandType -eq 'Alias') {
    Remove-Item Alias:tree -Force
}
function tree { eza --tree }
# ------------------------------------------------------------------------------------------
#   Env: drive shortcut
# ------------------------------------------------------------------------------------------
function Env: { Set-Location Env: }

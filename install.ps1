## Install script for Windows powershell config

$profile_folder = Split-Path $PROFILE
$powershell_config = "$profile_folder/windows-config/powershell"

# link profile script. Use Hardlink instead of Smbolic due to symboic requires admin access
# New-Item -Path "$profile_folder/profile.ps1" -ItemType SymbolicLink -Value "$powershell_config/profile.ps1" -Force
New-Item -Path "$profile_folder/profile.ps1" -ItemType HardLink -Value "$powershell_config/profile.ps1"

# Creat windows terminal junction for Fragments
New-Item -ItemType Junction -Path "$ENV:LOCALAPPDATA/Microsoft/Windows Terminal/Fragments" -Target "$profile_folder/windows-config\WindowsTerminal\Fragments\"

# Install oh-my-posh
# winget install JanDeDobbeleer.OhMyPosh

# Install Terminal-Icons
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser

# Install PSreadline
Install-Module -Name PSReadLine -Repository PSGallery -Scope CurrentUser

# Install Git autocompletion
Install-Module posh-git -Scope CurrentUser

# Install fzf
# winget install fzf # TODO: Do we need this aswell?
Install-Module PSFzf -Scope CurrentUser




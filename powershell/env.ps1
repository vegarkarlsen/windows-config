
$env:EDITOR = "nvim"

# Add to path
$env:PATH += ";C:\Program Files\LLVM\bin"
$env:PATH += ";C:\Program Files\Vim\vim91"
$env:PATH += ";C:\Program Files\Neovim\bin"
$env:PATH += ";$HOME\.local\var\nvim-win64\bin"
$env:PATH += ";C:\Program Files\QGIS 3.40.15/bin/"
$env:PATH += ";$HOME\Documents\PowerShell\windows-config\scripts\"

# User executables
$env:PATH += ";$HOME\.local\bin"

# Starship
$env:STARSHIP_CONFIG = "$HOME\Documents\WindowsPowerShell\windows-config\starship\starship.toml"


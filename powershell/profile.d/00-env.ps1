### ----------------------------------------------------------------------------------------
### 00-env.ps1  -  Environment variables and PATH
###
### Loaded first so EDITOR, PATH, etc. are available to everything after it.
### NOTE: $env:* set here is SESSION-ONLY (this PowerShell process and its children).
### Anything that GUI apps / VS Code / PyInstaller must also see should be set persistently
### in install.ps1 instead.
### ----------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
#   Idempotent PATH helper
# ------------------------------------------------------------------------------------------
# Appends a directory to PATH only if it is not already present. This makes re-sourcing the
# profile (e.g. via the Edit-* functions) safe - no more duplicated PATH entries.
# Also normalises trailing slashes so "C:\foo" and "C:\foo\" are treated as the same entry.
function Add-ToPath {
    param([Parameter(Mandatory)][string]$Dir)

    if ([string]::IsNullOrWhiteSpace($Dir)) { return }
    $Dir = $Dir.TrimEnd('\', '/')
    if (";$env:PATH;" -notlike "*;$Dir;*") {
        $env:PATH += ";$Dir"
    }
}

# ------------------------------------------------------------------------------------------
#   Editor
# ------------------------------------------------------------------------------------------
$env:EDITOR = "nvim"

# ------------------------------------------------------------------------------------------
#   PATH additions (machine-independent tools)
# ------------------------------------------------------------------------------------------
Add-ToPath "C:\Program Files\LLVM\bin"
Add-ToPath "C:\Program Files\Vim\vim91"
Add-ToPath "C:\Program Files\Neovim\bin"
Add-ToPath "$HOME\.local\var\nvim-win64\bin"
Add-ToPath "C:\Program Files\QGIS 3.40.15\bin"


# Add-ToPath "C:\msys64"
# Add-ToPath "C:\msys64\ucrt64\bin"

# Repo scripts (the committed bin/) and user-local bin (machine-local symlinks)
# Add-ToPath (Join-Path $env:WINCONFIG 'bin')
Add-ToPath "$HOME\.local\bin"

$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"

# ------------------------------------------------------------------------------------------
#   Starship config - derived from $env:WINCONFIG, never hard-coded
# ------------------------------------------------------------------------------------------
$env:STARSHIP_CONFIG = Join-Path $env:WINCONFIG 'starship\starship.toml'

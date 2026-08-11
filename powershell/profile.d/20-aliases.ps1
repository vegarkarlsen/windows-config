### ----------------------------------------------------------------------------------------
### 20-aliases.ps1  -  Real aliases only
###
### Just short-name -> command bindings. Functions that override built-ins live in
### 30-overrides.ps1; Unix-style shim functions live in 40-unix-compat.ps1; reusable
### library functions live in 50-functions.ps1.
### ----------------------------------------------------------------------------------------

# Editors / launchers
Set-Alias n      notepad
Set-Alias e      explorer.exe
Set-Alias open   Invoke-Item

# Python venv (run the activate script in the current dir's venv)
# Set-Alias activate .\venv\Scripts\Activate.ps1

# gsudo (uncomment if installed)
# Set-Alias sudo gsudo

# Small convenience: open nvim. Use the call operator (&) so paths with spaces in
# $env:EDITOR are handled correctly (Invoke-Expression breaks on those).
function vim { & $env:EDITOR @args }

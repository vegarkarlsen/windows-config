### ----------------------------------------------------------------------------------------
### 40-unix-compat.ps1  -  Unix muscle-memory shims
###
### Functions that imitate Unix commands. Kept dot-sourced (not in a module) because you
### want them present and named exactly the moment the shell opens, and some manipulate
### session state (export). These are the "would I be surprised if this wasn't instantly
### available in a fresh shell?" -> yes commands.
### ----------------------------------------------------------------------------------------

# grep - search stdin or files in a dir
# FIXME (carried from old config): does not yet support context lines (-A/-B/-C).
function grep($regex, $dir) {
    if ($dir) {
        Get-ChildItem $dir | Select-String $regex
        return
    }
    $input | Select-String $regex
}

# sed - simple in-place find/replace
function sed($file, $find, $replace) {
    (Get-Content $file).Replace($find, $replace) | Set-Content $file
}

# touch - create an empty file (or update if you extend it)
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

# which - show the resolved definition/path of a command
function which {
    param([string]$name)
    if (-not $name) { Write-Warning "Usage: which <command>"; return }
    Get-Command $name | Select-Object -ExpandProperty Definition
}

# export NAME VALUE - set a session env var the Unix way
function export($name, $value) {
    Set-Item -Force -Path "env:$name" -Value $value
}

# Process helpers
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
    Get-Process $name -ErrorAction SilentlyContinue
}

# df - disk/volume overview
function df { Get-Volume }

# Power control
function poweroff { shutdown /s /t 0 }
function reboot   { shutdown /r /t 0 }

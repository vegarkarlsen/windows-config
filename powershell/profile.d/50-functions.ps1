### ----------------------------------------------------------------------------------------
### 50-functions.ps1  -  Reusable utility functions and aliases
### ----------------------------------------------------------------------------------------


# Get-PubIP - this machine's public IP.
function Get-PubIP {
    (Invoke-WebRequest -Uri 'http://ifconfig.me/ip' -UseBasicParsing).Content.Trim()
}


# dirs - rough equivalent of `dir /s /b`.
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include $args | ForEach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | ForEach-Object FullName
    }
}

# File hashes - verify downloads.
function md5    { Get-FileHash -Algorithm MD5    $args }
function sha1   { Get-FileHash -Algorithm SHA1   $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# ln / New-Link - create a symbolic link (or hard link with -Hard).
# NOTE: SymbolicLink needs admin/Developer Mode. Without it, use -Hard (files, same volume)
# or a junction for directories (New-Item -ItemType Junction). The old `ln` had a $targe
# typo that silently passed $null - fixed here.
function ln {
    param(
        [Parameter(Mandatory)][string]$Link,
        [Parameter(Mandatory)][string]$Target,
        [switch]$Hard
    )
    $type = if ($Hard) { 'HardLink' } else { 'SymbolicLink' }
    New-Item -Path $Link -ItemType $type -Value $Target
}

function unzip {
    param(
        [Parameter(Mandatory)][string]$File,
        [string]$Destination = $PWD
    )
    Write-Host "Extracting $File -> $Destination"
    Expand-Archive -Path $File -DestinationPath $Destination -Force
}

function activate {
    $venvNames = @(
        ".venv",
        "venv"
    )

    foreach ($name in $venvNames) {
            $activate = Join-Path $PWD ".\$name\Scripts\Activate.ps1"

            if (Test-Path $activate) {
                Write-Host "Activating $name"
                & $activate
                return
            }

    }
    write-Warning "No python virtual environment found."


}

# uptime - last boot + elapsed. Get-CimInstance (Get-WmiObject is gone in PS7).
function uptime {
    Get-CimInstance -ClassName Win32_OperatingSystem |
        Select-Object CSName, LastBootUpTime,
            @{ Name = 'Uptime'; Expression = { (Get-Date) - $_.LastBootUpTime } }
}

# Test-CommandExists - true/false if a command resolves.
function Test-CommandExists {
    param([Parameter(Mandatory)][string]$Command)
    [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}


### ----------------------------------------------------------------------------------------
### Functions that imitate Unix commands.
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

### ----------------------------------------------------------------------------------------
### Aliases
### ----------------------------------------------------------------------------------------

# Editors / launchers
Set-Alias n      notepad
Set-Alias e      explorer.exe
Set-Alias open   Invoke-Item

# Open editor in vim
function vim { & $env:EDITOR @args }

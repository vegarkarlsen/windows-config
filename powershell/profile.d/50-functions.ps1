### ----------------------------------------------------------------------------------------
### 50-functions.ps1  -  Reusable utility functions
###
### Formerly the "MyTools" module. Now just dot-sourced like everything else - no manifest,
### no PSModulePath, no auto-load machinery. If a genuine reusable library emerges later,
### this is the file to lift into a module. Until then: just functions.
### ----------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------
#   Network
# ------------------------------------------------------------------------------------------

# Get-PubIP - this machine's public IP.
function Get-PubIP {
    (Invoke-WebRequest -Uri 'http://ifconfig.me/ip' -UseBasicParsing).Content.Trim()
}

# ------------------------------------------------------------------------------------------
#   Files
# ------------------------------------------------------------------------------------------

# Find-File - recursively find files whose name contains a substring.
function Find-File {
    param([Parameter(Mandatory)][string]$Name)
    Get-ChildItem -Recurse -Filter "*$Name*" -ErrorAction SilentlyContinue |
        ForEach-Object { $_.FullName }
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

# unzip - the actually-working extractor (old one was a stub).
function unzip {
    param(
        [Parameter(Mandatory)][string]$File,
        [string]$Destination = $PWD
    )
    Write-Host "Extracting $File -> $Destination"
    Expand-Archive -Path $File -DestinationPath $Destination -Force
}

# ------------------------------------------------------------------------------------------
#   System
# ------------------------------------------------------------------------------------------

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

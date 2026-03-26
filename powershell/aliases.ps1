### ----------------------------------------------------------------------------------------
### Functions
### ----------------------------------------------------------------------------------------

# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
# Useful shortcuts for traversing directories
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

# Compute file hashes - useful for checking successful downloads
function md5 { Get-FileHash -Algorithm MD5 $args }
function sha1 { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
function n { notepad $args }
function vim { Invoke-expression "$env:EDITOR $args" }

# Drive shortcuts
function Env: { Set-Location Env: }

# Creates drive shortcut for Work Folders, if current user account is using it
# if (Test-Path "$env:USERPROFILE\Work Folders") {
#     New-PSDrive -Name Work -PSProvider FileSystem -Root "$env:USERPROFILE\Work Folders" -Description "Work Folders"
#     function Work: { Set-Location Work: }
# }

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    } else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}


# TODO: Missplacesd?
Function Test-CommandExists {
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'
    try { if (Get-Command $command) { RETURN $true } }
    Catch { Write-Host "$command does not exist"; RETURN $false }
    Finally { $ErrorActionPreference = $oldPreference }
}

function ln ($link, $target){
    # New-Item -Path $link -ItemType SymbolicLink -Value $targe
    New-Item -Path $link -ItemType HardLink -Value $targe
}


function Get-PubIP {
    (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

function uptime {
    #Windows Powershell
    Get-WmiObject win32_operatingsystem | Select-Object csname, @{
        LABEL      = 'LastBootUpTime';
        EXPRESSION = { $_.ConverttoDateTime($_.lastbootuptime) }
    }
}

function Find-File($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}
# function unzip ($file) {
#     Write-Output("Extracting", $file, "to", $pwd)
#     $fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object { $_.FullName }
#     Expand-Archive -Path $fullFile -DestinationPath $pwd
# }


# FIXME: does not work
function unzip ($file, $out_name = $file){
    Write-Output(This function does not work)
}




# FIXME: should output some lines before and after
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}


function touch($file) {
    "" | Out-File $file -Encoding ASCII
}

function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which() {
    param(
        [string]$name
    )
    if ( $name -eq ""){
            return "No argument passed."
        }
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}

function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
    try { Get-Process $name -ErrorAction "SilentlyContinue" }
    catch { Write-Host "Prosess $name does not exist" }
}

function df { get-volume }

function poweroff { shutdown /s }

function reboot { shutdown /r }

# Remove alias cd and replace by custom function
if ((get-command cd).CommandType -eq "Alias") {
    Remove-Item Alias:cd    # Powershell < v.5
    #Remove-Alias -Name cd   # Powershell > v.6
    }
function cd {
    param (
        [string]$Path
    )

    if (-not $Path) {
        Set-Location $env:HOMEPATH
    } else {
        Set-Location $Path
    }
}

if ((Get-Command ls).CommandType -eq "Alias") {
        Remove-Item Alias:ls
    }
function ls {
    if ($args.Count -eq 0) {
        Get-ChildItem | Where-Object { $_.Name -notmatch '^\.' }
    }
    elseif ($args -contains "-a"){
        Get-ChildItem
    }
    elseif ($args -contains "-la"){
        Get-ChildItem -Force
    }
    else {
        Get-ChildItem $args
    }
}
function la {
    Get-ChildItem
}
function ll {
    Get-ChildItem -Force
}

# function ll { Get-ChildItem -Path $pwd -File }

#function activate { .\venv\Scripts\activate.ps1 }
Set-Alias activate .\venv\Scripts\Activate.ps1

#function sudo { gsudo }
# Set-Alias sudo gsudo

#function e { explorer.exe $_}
Set-Alias e explorer.exe

Set-Alias open Invoke-Item

# function t {
#         echo "test"
#     }


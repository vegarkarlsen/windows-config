


function Create-Shortcut() {
    $WshShell = New-Object -ComObject WScript.Shell
    $ShortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\myapp.lnk"

    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "C:\Users\You\bin\myapp.exe"
    $Shortcut.WorkingDirectory = "C:\Users\You\bin"
    $Shortcut.Arguments = ""
    $Shortcut.IconLocation = "C:\Users\You\bin\myapp.exe"
    $Shortcut.Description = "My custom app"

    $Shortcut.Save()
}


function New-Shortcut {
    param (
        [Parameter(Mandatory=$true)]
        [string]$TargetPath,

        [Parameter(Mandatory=$true)]
        [string]$ShortcutPath,

        [string]$WorkingDirectory = "",
        [string]$Arguments = "",
        [string]$IconLocation = ""
    )

    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)

    $Shortcut.TargetPath = $TargetPath

    if ($WorkingDirectory) {
        $Shortcut.WorkingDirectory = $WorkingDirectory
    }

    if ($Arguments) {
        $Shortcut.Arguments = $Arguments
    }

    if ($IconLocation) {
        $Shortcut.IconLocation = $IconLocation
    }

    $Shortcut.Save()
}

# ------------------------------------------------------------------------------------------------------------
# This script is Outdated. PLease use install.ps1 instead
# ------------------------------------------------------------------------------------------------------------

# Check if we are running from right github repo:
$inGithubRepo = git rev-parse --is-inside-work-tree 2>$null
$inRightFolder = Test-Path -Path "$pwd\Microsoft.PowerShell_profile.ps1"
$FolderGood = ($inGithubRepo -eq $true) -and ($inRightFolder -eq $true)


#If the $PROFILE does not exist, create it.
if (!(Test-Path -Path $PROFILE -PathType Leaf)) {
    try {
        # Detect Version of Powershell & Create Profile directories if they do not exist.
        if ($PSVersionTable.PSEdition -eq "Core" ) { 
            if (!(Test-Path -Path ($env:userprofile + "\Documents\Powershell"))) {
                New-Item -Path ($env:userprofile + "\Documents\Powershell") -ItemType "directory"
            }
        }
        elseif ($PSVersionTable.PSEdition -eq "Desktop") {
            if (!(Test-Path -Path ($env:userprofile + "\Documents\WindowsPowerShell"))) {
                New-Item -Path ($env:userprofile + "\Documents\WindowsPowerShell") -ItemType "directory"
            }
        }
        
        # TODO: make backups with timestamps when changing $profile-file
        # if you are running github from cloned github repo:
        if ($FolderGood){
            Copy-Item -Path "$pwd\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE
            Write-Host "The profile @ [$PROFILE] has been created."  
        }
        # TODO: else: copy from raw github file 
        else {Write-Host "you are not in a github repository, and the profile-file is currently not availible online"}


        # download from ChrisTitusTech's repo
        # Invoke-RestMethod https://github.com/ChrisTitusTech/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -o $PROFILE
        # Write-Host "The profile @ [$PROFILE] has been created."
    }
    catch {
        throw $_.Exception.Message
    }
}

# If the file already exists, take copy of old file and swap with updated version
 else {

        # TODO: make backups with timestamps when changing $profile-file
        # If you are running github from cloned github repo:
        if ($FolderGood) {
            Get-Item -Path $PROFILE | Move-Item -Destination "$pwd\oldprofile.ps1"
            Copy-Item -Path "$pwd\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE
            Write-Host "The profile @ [$PROFILE] has been updated, and old profile have been backed up."  
        }
        # TODO: copy from raw link
        else {
            Write-Host "you are not in a github repository, and the profile-file is currently not availible online"
        }

		#  Get-Item -Path $PROFILE | Move-Item -Destination oldprofile.ps1
		#  Invoke-RestMethod https://github.com/ChrisTitusTech/powershell-profile/raw/main/Microsoft.PowerShell_profile.ps1 -o $PROFILE
		#  Write-Host "The profile @ [$PROFILE] has been created and old profile removed."
 }

 & $profile 2>$null

# Oh My Posh - Install
#
winget install -e --accept-source-agreements --accept-package-agreements JanDeDobbeleer.OhMyPosh

# Font Install
# You will have to extract and Install this font manually, alternatively use the oh my posh font installer (Must be run as admin)
# oh-my-posh font install
# You will also need to set your Nerd Font of choice in your window defaults or in the Windows Terminal Settings.
$cove_exists = Test-path "$pwd\cove.zip"
if (! $cove_exists){
    Invoke-RestMethod https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip?WT.mc_id=-blog-scottha -OutFile cove.zip
}

# Choco install
# TODO: Should not try to install if allerady installed
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Terminal Icons Install
#
Install-Module -Name Terminal-Icons -Repository PSGallery

# TODO: Add more packages if reqired
#

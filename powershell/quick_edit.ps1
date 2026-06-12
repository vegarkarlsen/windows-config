

function Change-Folder-Open-file {
        param($file)

        Push-Location (Split-Path $file)
        Invoke-Expression "$env:EDITOR $file"
        Pop-Location
    }

# Make it easy to edit this profile once it's installed
function Edit-Profile {
    $file = $profile.CurrentUserAllHosts
    # if ($host.Name -match "ise") {
    #     $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    # }

    Change-Folder-Open-file $file
    . $file

}

function Edit-LocalProfile {
        $file = "$powershell_config/local-profile.ps1"
        if (-not (Test-Path $file)){
                new-item $file
            }
        Change-Folder-Open-file $file
        . $file
    }

function Edit-alias {
    $alias_file = "$powershell_config/aliases.ps1"
    Change-Folder-Open-file $alias_file
    . $alias_file
}

function Edit-nvim {
    $nvim_folder = "$env:LocalAppData/nvim"
    Change-Folder-Open-file $nvim_folder
}

function Edit-penv {
        $env_file = "$powershell_config/env.ps1"
        # nvim "$env_file"
        Change-Folder-Open-file $env_file
        . $env_file
    }


Set-Alias malias Edit-alias
Set-Alias maliasl Edit-LocalProfile

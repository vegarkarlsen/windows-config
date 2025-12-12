# Windows config

This repository containts a collections of usefull scripts and configurations for windows.

## prerequisites
- WindowsTerminal
- Git
- Powershell v 5.1 or later

Powershells defualt execution policy is set to `Restricted`, which means that scripts can't be run, and the config will not work. The execution plolicy can be changed by runing the following command in powershell with admin privileges:
```powershell
Set-ExecutionPolicy $POLICY -Scope CurrentUser
```
The $POLICY variable needs to be set to something that allows scripts to run, for example `Bypass`. For more information about powershell execution policy see: [Powershell Exectuion Policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4).

## Download
To download the repository make sure you are in the `$profile` folder, which is usually found in "~/Documents/WindowsPowerShell/", and run the following command:
```powershell
git clone https://github.com/vegarkarlsen/windows-config.git
```

The full configuration can be installed by running the `install.ps1` script, this sets up symbolic links for all the config files in the right directories, as well as download some usefull powershell modules.

```powershell
cd powershell
./install.ps1
```
NB! The install script has to be run with admin privileges to make the symolic links.

If you dont have the permissions to run the install script you can manually copy the config files to the right directories.

### Fonts
I currently uses the patched MesloLGS NF font from powerlevel10k. The font can be downloaded direclty from the [powerlevel10k-project](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k) on github.

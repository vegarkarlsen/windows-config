# Windows Config

This repository contains a collections of useful scripts and configurations for
windows.

## prerequisites

- WindowsTerminal
- Git
- Powershell v 5.1 or later

Powershell's default execution policy is set to `Restricted`, which means that
scripts can't be run, and the config will not work. The execution policy can be
changed for the current user by running the following command in powershell:

```
powershell Set-ExecutionPolicy $POLICY -Scope CurrentUser
```

The $POLICY variable needs to be set to something that allows scripts to run,
for example `Bypass`. For more information about powershell execution policy
see:
[Powershell Exectuion
Policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4).

## Download

To download the repository make sure you are in the `$profile` folder, which is
usually found in `~/Documents/WindowsPowerShell/`, and run the following
command:

```
powershell git clone https://github.com/vegarkarlsen/windows-config.git
```

The full configuration can be installed by running the `install.ps1` script.
This script links all config files to the necessary locations.

### Fonts

I currently uses the patched MesloLGS NF font from powerlevel10k. The font can
be downloaded direclty from the [powerlevel10k-project](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#meslo-nerd-font-patched-for-powerlevel10k)
on github.

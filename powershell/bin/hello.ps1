### bin/hello.ps1  -  Example standalone script.
###
### bin/ on PATH (via 00-env.ps1) plus .PS1 in PATHEXT lets you run this from anywhere by
### bare name:  hello   (set PATHEXT once: see README). Otherwise call it as  hello.ps1
###
### Drop any standalone .ps1 tool in here, or symlink one into ~/.local/bin, and it
### becomes runnable by name - the Windows equivalent of your Linux ~/.local/bin workflow.

param([string]$Name = 'world')
Write-Host "hello, $Name"

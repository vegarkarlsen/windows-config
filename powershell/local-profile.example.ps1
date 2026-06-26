### ----------------------------------------------------------------------------------------
### local-profile.example.ps1  -  Template for machine-specific config
###
### Copy to  local-profile.ps1  (which should be gitignored) and customise per machine.
### Loaded automatically by profile.ps1 if present. Use Add-ToPath (defined in 00-env.ps1)
### so re-sourcing never duplicates PATH entries.
### ----------------------------------------------------------------------------------------

# Example: msys2 / ucrt64 toolchain (this machine only)
# Add-ToPath "C:\msys64"
# Add-ToPath "C:\msys64\ucrt64\bin"

# Example: GIS / point-cloud tools on a work machine
# Add-ToPath "C:\lastools\bin"
# Add-ToPath "$HOME\.local\var\ImageMagick-7.1.2-22-portable-Q16-x86"
# Add-ToPath "$HOME\.local\var\PotreeConverter_windows_x64"
# Add-ToPath "$HOME\.local\var\CloudCompare_v2.14.beta_bin_x64"

# Example: msys2 pacman wrapper
# function pacman { & C:\msys64\usr\bin\pacman.exe @args }

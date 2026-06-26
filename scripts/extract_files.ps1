

function Extract-Files {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$Source,

        [Parameter(Mandatory)]
        [string]$Destination,

        [Parameter(Mandatory)]
        [string]$Pattern,

        [switch]$Copy  # use -Copy to copy instead of move

    )

    # Normalize paths (remove trailing slash issues)
    $Source = (Resolve-Path $Source).Path
    $Destination = (Resolve-Path $Destination -ErrorAction SilentlyContinue) ?? $Destination

    Get-ChildItem -Path $Source -Recurse -File -Filter $Pattern | ForEach-Object {

        # Compute relative path
        $relativePath = $_.FullName.Substring($Source.Length).TrimStart('\')

        # Build destination path
        $targetPath = Join-Path $Destination $relativePath
        $targetDir  = Split-Path $targetPath

        # Ensure directory exists
        if (!(Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }

        # Action description (for -WhatIf / -Verbose)
        $action = if ($Copy) { "Copy" } else { "Move" }

        if ($PSCmdlet.ShouldProcess($_, "$action -> $targetPath")) {
            if ($Copy) {
                $cmd = "Copy-Item $_ -Destination $targetPath"
                
            } else {
                $cmd = "Move-Item $_ -Destination $targetPath"
            }

        }
        Write-Host $cmd
        Invoke-Expression $cmd
    }
}

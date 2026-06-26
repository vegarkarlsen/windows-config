### lazy/example.ps1  -  Example situational tool set.
###
### NOT loaded at startup. Pull it in only when you need it:   Load-Tools example
### (Load-Tools is defined in profile.d/50-quick-edit.ps1 and tab-completes from this folder.)
###
### Use this for heavy or rarely-needed function groups you don't want costing startup time
### and don't want auto-loading either - e.g. one-off migration helpers, experimental stuff.

function Invoke-ExampleTool {
    Write-Host "This came from lazy/example.ps1 - loaded on demand."
}

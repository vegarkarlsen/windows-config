
$UTL_LOG_FILE = ".uptime.log"


function log_last_boot(){
    $last_boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime.ToString("dd-MM-yyyy HH:mm:ss")
    # (Get-CimInstance Win32_OperatingSystem).LastBootUpTime | select-object -ExpandProperty TimeCreated | 
    # Out-File $UTL_LOG_FILE -Append
    "Bootup: $last_boot" | Out-File $UTL_LOG_FILE -Append
    
}

function log_last_shutdown(){
    # $last_shutdown = Get-WinEvent -FilterHashtable @{LogName='System'; ID=6006} -MaxEvents 1
    #
    # $last_shutdown.TimeCreated | Out-File $UTL_LOG_FILE -Append

    $last_shutdown = (Get-WinEvent -FilterHashtable @{LogName='System'; ID=6006} -MaxEvents 1).TimeCreated.ToString("dd-MM-yyyy HH:mm:ss")
    "Shutdown: $last_shutdown" | Out-File $UTL_LOG_FILE -Append
}

log_last_shutdown
log_last_boot




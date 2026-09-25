# Problem #22: System Uptime (Refactored with LoggerModule)
# Reports system uptime and boot time

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "SystemUptime"

try {
    Write-Log "Gathering system uptime information..."

    $os = Get-CimInstance Win32_OperatingSystem
    $lastBoot = $os.LastBootUpTime
    $uptime = (Get-Date) - $lastBoot

    $info = [PSCustomObject]@{
        LastBootTime = $lastBoot
        UptimeDays   = $uptime.Days
        UptimeHours  = $uptime.Hours
        UptimeMinutes= $uptime.Minutes
    }

    $info | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "System uptime report generated successfully."
}
catch {
    Write-Log "Error retrieving system uptime: $_" -Level "ERROR"
}
finally {
    Close-Logger "SystemUptime"
}

# Problem #25: Security Event Log Audit (Refactored with LoggerModule)
# Collects recent security events from the Windows Event Log

param(
    [int]$DaysBack = 7
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "EventLogSecurity"

try {
    Write-Log "Gathering security event logs (last $DaysBack days)..."

    $cutoff = (Get-Date).AddDays(-$DaysBack)
    $events = Get-WinEvent -LogName Security | Where-Object { $_.TimeCreated -ge $cutoff } | Select-Object -First 50

    if (-Not $events) {
        Write-Log "No security events found in the last $DaysBack days." -Level "WARN"
        Close-Logger "EventLogSecurity"
        exit
    }

    $events | Select-Object TimeCreated, Id, LevelDisplayName, Message |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Security event log audit completed successfully."
}
catch {
    Write-Log "Error retrieving security event logs: $_" -Level "ERROR"
}
finally {
    Close-Logger "EventLogSecurity"
}


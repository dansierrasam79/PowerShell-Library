# Problem #29: Event Log Summary (Refactored with LoggerModule)
# Summarizes recent Application and System events

param(
    [int]$DaysBack = 7
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "EventLogSummary"

try {
    Write-Log "Summarizing event logs (last $DaysBack days)..."

    $cutoff = (Get-Date).AddDays(-$DaysBack)
    $appEvents = Get-WinEvent -LogName Application | Where-Object { $_.TimeCreated -ge $cutoff } | Select-Object -First 20
    $sysEvents = Get-WinEvent -LogName System | Where-Object { $_.TimeCreated -ge $cutoff } | Select-Object -First 20

    Write-Log "Application Events:"
    $appEvents | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "System Events:"
    $sysEvents | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Event log summary completed successfully."
}
catch {
    Write-Log "Error retrieving event logs: $_" -Level "ERROR"
}
finally {
    Close-Logger "EventLogSummary"
}

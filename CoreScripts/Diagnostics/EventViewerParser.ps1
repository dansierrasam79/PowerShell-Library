# Problem #39: Event Viewer Parser (Refactored with LoggerModule)
# Extracts and summarizes recent critical and error events

param(
    [int]$DaysBack = 3
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "EventViewerParser"

try {
    Write-Log "Parsing Event Viewer logs (last $DaysBack days)..."

    $cutoff = (Get-Date).AddDays(-$DaysBack)
    $events = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=$cutoff} -ErrorAction SilentlyContinue | Select-Object -First 50

    if (-Not $events) {
        Write-Log "No critical or error events found in the last $DaysBack days." -Level "WARN"
        Close-Logger "EventViewerParser"
        exit
    }

    $events | Select-Object TimeCreated, Id, LevelDisplayName, Message |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Event Viewer parsing completed successfully."
}
catch {
    Write-Log "Error parsing Event Viewer logs: $_" -Level "ERROR"
}
finally {
    Close-Logger "EventViewerParser"
}

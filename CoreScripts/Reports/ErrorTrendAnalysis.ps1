# Problem #42: Error Trend Analysis (Refactored with LoggerModule)
# Analyzes error events over a time window

param(
    [int]$DaysBack = 14
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "ErrorTrendAnalysis"

try {
    Write-Log "Analyzing error trends (last $DaysBack days)..."

    $cutoff = (Get-Date).AddDays(-$DaysBack)
    $events = Get-WinEvent -LogName System | Where-Object { $_.TimeCreated -ge $cutoff -and $_.LevelDisplayName -eq "Error" }

    if (-Not $events) {
        Write-Log "No error events found in the last $DaysBack days." -Level "WARN"
        Close-Logger "ErrorTrendAnalysis"
        exit
    }

    $trend = $events | Group-Object { $_.TimeCreated.Date } | Select-Object Name, Count
    $trend | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Error trend analysis completed successfully."
}
catch {
    Write-Log "Error analyzing error trends: $_" -Level "ERROR"
}
finally {
    Close-Logger "ErrorTrendAnalysis"
}

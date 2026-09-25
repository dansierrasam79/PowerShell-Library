# Problem #6: High CPU/Memory Usage (Refactored with LoggerModule)
# Lists top processes by CPU and memory usage, logs results via LoggerModule

param(
    [int]$TopCount = 10  # Number of top processes to display
)

$loggerModule = Join-Path $PSScriptRoot "..\Utilities\LoggerModule.psm1"
Import-Module $loggerModule
Initialize-Logger "HighResourceUsage"

try {
    Write-Log "Gathering process resource usage..."

    $processes = Get-Process -ErrorAction Stop
    if (-Not $processes) {
        Write-Log "No processes found." -Level "WARN"
        Close-Logger "HighResourceUsage"
        exit
    }

    # Top by CPU
    Write-Log "Top $TopCount Processes by CPU Time:"
    $cpuTop = $processes | Sort-Object CPU -Descending | 
              Select-Object -First $TopCount -Property Id, ProcessName, CPU, @{Name="MemoryMB";Expression={[math]::Round($_.WorkingSet/1MB,2)}}
    $cpuTop | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    # Top by Memory
    Write-Log "Top $TopCount Processes by Memory Usage:"
    $memTop = $processes | Sort-Object WorkingSet -Descending | 
              Select-Object -First $TopCount -Property Id, ProcessName, @{Name="MemoryMB";Expression={[math]::Round($_.WorkingSet/1MB,2)}}, CPU
    $memTop | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "High resource usage report generated successfully."
}
catch {
    Write-Log "Error retrieving process information: $_" -Level "ERROR"
}
finally {
    Close-Logger "HighResourceUsage"
}
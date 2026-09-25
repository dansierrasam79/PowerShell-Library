# Problem #20: Disk I/O Stats (Refactored with LoggerModule)
# Collects disk I/O statistics for performance monitoring

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "DiskIOStats"

try {
    Write-Log "Gathering disk I/O statistics..."

    $diskStats = Get-CimInstance Win32_PerfFormattedData_PerfDisk_PhysicalDisk -ErrorAction SilentlyContinue
    if (-Not $diskStats) {
        Write-Log "No disk I/O stats found." -Level "WARN"
        Close-Logger "DiskIOStats"
        exit
    }

    $diskStats | Select-Object Name, DiskReadsPerSec, DiskWritesPerSec, AvgDiskSecPerRead, AvgDiskSecPerWrite |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Disk I/O stats collected successfully."
}
catch {
    Write-Log "Error retrieving disk I/O stats: $_" -Level "ERROR"
}
finally {
    Close-Logger "DiskIOStats"
}

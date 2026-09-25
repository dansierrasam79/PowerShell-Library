# Problem #38: Disk Health Check (Refactored with LoggerModule)
# Reports SMART status and health of physical disks

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "DiskHealthCheck"

try {
    Write-Log "Checking disk health..."

    $disks = Get-PhysicalDisk -ErrorAction SilentlyContinue
    if (-Not $disks) {
        Write-Log "No physical disks found." -Level "WARN"
        Close-Logger "DiskHealthCheck"
        exit
    }

    $disks | Select-Object FriendlyName, OperationalStatus, HealthStatus, Size |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Disk health check completed successfully."
}
catch {
    Write-Log "Error retrieving disk health info: $_" -Level "ERROR"
}
finally {
    Close-Logger "DiskHealthCheck"
}

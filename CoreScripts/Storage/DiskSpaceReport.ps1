# Problem #27: Disk Space Report (Refactored with LoggerModule)
# Reports disk space usage for all logical drives

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "DiskSpaceReport"

try {
    Write-Log "Gathering disk space information..."

    $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction SilentlyContinue
    if (-Not $drives) {
        Write-Log "No logical drives found." -Level "WARN"
        Close-Logger "DiskSpaceReport"
        exit
    }

    $drives | Select-Object DeviceID,
        @{Name="SizeGB";Expression={[math]::Round($_.Size/1GB,2)}},
        @{Name="FreeGB";Expression={[math]::Round($_.FreeSpace/1GB,2)}},
        @{Name="UsedGB";Expression={[math]::Round(($_.Size - $_.FreeSpace)/1GB,2)}},
        @{Name="PercentFree";Expression={[math]::Round(($_.FreeSpace/$_.Size)*100,2)}} |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Disk space report generated successfully."
}
catch {
    Write-Log "Error retrieving disk space info: $_" -Level "ERROR"
}
finally {
    Close-Logger "DiskSpaceReport"
}

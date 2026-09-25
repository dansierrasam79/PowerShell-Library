# Problem #40: Daily Summary Report (Refactored with LoggerModule)
# Generates a daily summary of system status

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "DailySummary"

try {
    Write-Log "Generating daily summary..."

    $uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
            Select-Object DeviceID,@{Name="FreeGB";Expression={[math]::Round($_.FreeSpace/1GB,2)}}

    $summary = [PSCustomObject]@{
        Date        = Get-Date
        Computer    = $env:COMPUTERNAME
        UptimeDays  = $uptime.Days
        FreeSpaceGB = ($disk | ForEach-Object { "$($_.DeviceID): $($_.FreeGB) GB" }) -join "; "
    }

    $summary | Format-List | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Daily summary report generated successfully."
}
catch {
    Write-Log "Error generating daily summary: $_" -Level "ERROR"
}
finally {
    Close-Logger "DailySummary"
}

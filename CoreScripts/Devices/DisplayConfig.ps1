# Problem #54: Display Configuration (Refactored with LoggerModule)
# Reports display settings and resolutions

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "DisplayConfig"

try {
    Write-Log "Gathering display configuration..."

    $monitors = Get-CimInstance Win32_DesktopMonitor -ErrorAction SilentlyContinue
    if (-Not $monitors) {
        Write-Log "No monitors detected." -Level "WARN"
        Close-Logger "DisplayConfig"
        exit
    }

    $monitors | Select-Object Name, ScreenHeight, ScreenWidth, DeviceID |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Display configuration report completed successfully."
}
catch {
    Write-Log "Error retrieving display configuration: $_" -Level "ERROR"
}
finally {
    Close-Logger "DisplayConfig"
}

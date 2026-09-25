# Problem #52: USB Device Audit (Refactored with LoggerModule)
# Lists connected USB devices

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "USBDeviceAudit"

try {
    Write-Log "Auditing connected USB devices..."

    $usbDevices = Get-PnpDevice -Class USB -ErrorAction SilentlyContinue
    if (-Not $usbDevices) {
        Write-Log "No USB devices found." -Level "WARN"
        Close-Logger "USBDeviceAudit"
        exit
    }

    $usbDevices | Select-Object Name, Status, InstanceId |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "USB device audit completed successfully."
}
catch {
    Write-Log "Error retrieving USB device info: $_" -Level "ERROR"
}
finally {
    Close-Logger "USBDeviceAudit"
}

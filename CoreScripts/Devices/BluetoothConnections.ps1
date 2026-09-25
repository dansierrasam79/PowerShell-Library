# Problem #53: Bluetooth Connections (Refactored with LoggerModule)
# Lists paired Bluetooth devices

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "BluetoothConnections"

try {
    Write-Log "Auditing Bluetooth connections..."

    $btDevices = Get-PnpDevice | Where-Object { $_.Class -eq "Bluetooth" }
    if (-Not $btDevices) {
        Write-Log "No Bluetooth devices found." -Level "WARN"
        Close-Logger "BluetoothConnections"
        exit
    }

    $btDevices | Select-Object Name, Status, InstanceId |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Bluetooth connections audit completed successfully."
}
catch {
    Write-Log "Error retrieving Bluetooth info: $_" -Level "ERROR"
}
finally {
    Close-Logger "BluetoothConnections"
}

# Problem #51: Printer Status (Refactored with LoggerModule)
# Reports installed printers and their status

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "PrinterStatus"

try {
    Write-Log "Checking printer status..."

    $printers = Get-Printer -ErrorAction SilentlyContinue
    if (-Not $printers) {
        Write-Log "No printers found." -Level "WARN"
        Close-Logger "PrinterStatus"
        exit
    }

    $printers | Select-Object Name, PrinterStatus, Default, Shared |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Printer status report completed successfully."
}
catch {
    Write-Log "Error retrieving printer status: $_" -Level "ERROR"
}
finally {
    Close-Logger "PrinterStatus"
}

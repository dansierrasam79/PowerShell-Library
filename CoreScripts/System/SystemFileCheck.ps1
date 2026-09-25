# Problem #50: System File Check (Refactored with LoggerModule)
# Runs SFC and DISM scans for system integrity

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "SystemFileCheck"

try {
    Write-Log "Running System File Checker (SFC)..."
    sfc /scannow | Out-Null
    Write-Log "SFC scan completed."

    Write-Log "Running DISM health check..."
    DISM /Online /Cleanup-Image /CheckHealth | Out-Null
    Write-Log "DISM health check completed."

    Write-Log "System file integrity check completed successfully."
}
catch {
    Write-Log "Error running system file checks: $_" -Level "ERROR"
}
finally {
    Close-Logger "SystemFileCheck"
}

# Problem #57: Auto Cleanup (Refactored with LoggerModule)
# Cleans temporary files and logs

param(
    [string]$TempPath = $env:TEMP,
    [string]$LogPath = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'Logs')
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "AutoCleanup"

try {
    Write-Log "Starting auto cleanup..."

    if (Test-Path $TempPath) {
        Get-ChildItem -Path $TempPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        Write-Log "Temporary files cleaned from $TempPath."
    } else {
        Write-Log "Temp path not found: $TempPath" -Level "WARN"
    }

    if (Test-Path $LogPath) {
        Get-ChildItem -Path $LogPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        Write-Log "Log files cleaned from $LogPath."
    } else {
        Write-Log "Log path not found: $LogPath" -Level "WARN"
    }

    Write-Log "Auto cleanup completed successfully."
}
catch {
    Write-Log "Error during auto cleanup: $_" -Level "ERROR"
}
finally {
    Close-Logger "AutoCleanup"
}

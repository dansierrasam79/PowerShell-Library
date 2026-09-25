# Problem #34: OneDrive Sync Status (Refactored with LoggerModule)
# Reports OneDrive sync client status and folder health

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "OneDriveSyncStatus"

try {
    Write-Log "Checking OneDrive sync status..."

    $process = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    if (-Not $process) {
        Write-Log "OneDrive process not running." -Level "WARN"
    } else {
        Write-Log "OneDrive is running (PID: $($process.Id))."
    }

    $syncFolder = "$env:USERPROFILE\OneDrive"
    if (Test-Path $syncFolder) {
        $files = Get-ChildItem $syncFolder -Recurse -ErrorAction SilentlyContinue | Measure-Object
        Write-Log "OneDrive folder contains $($files.Count) items."
    } else {
        Write-Log "OneDrive folder not found." -Level "WARN"
    }

    Write-Log "OneDrive sync status check completed successfully."
}
catch {
    Write-Log "Error checking OneDrive sync status: $_" -Level "ERROR"
}
finally {
    Close-Logger "OneDriveSyncStatus"
}

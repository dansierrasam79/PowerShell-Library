# Problem #33: Restore Point Manager (Refactored with LoggerModule)
# Creates and lists system restore points

param(
    [string]$Description = "CoreScripts Restore Point"
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "RestorePointManager"

try {
    Write-Log "Creating system restore point: $Description..."
    Checkpoint-Computer -Description $Description -RestorePointType "MODIFY_SETTINGS"
    Write-Log "Restore point created successfully."

    Write-Log "Listing existing restore points..."
    $restorePoints = Get-CimInstance Win32_ShadowCopy | Select-Object ID, InstallDate, Description
    $restorePoints | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Restore point management completed successfully."
}
catch {
    Write-Log "Error managing restore points: $_" -Level "ERROR"
}
finally {
    Close-Logger "RestorePointManager"
}

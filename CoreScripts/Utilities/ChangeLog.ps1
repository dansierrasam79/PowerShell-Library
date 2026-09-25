# Problem #44: Change Log Generator (Refactored with LoggerModule)
# Appends a change entry to ChangeLog.md

param(
    [string]$Message = "Updated scripts",
    [string]$LogFile = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'ChangeLog.md')
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "ChangeLog"

try {
    Write-Log "Updating change log..."

    $entry = "## [$((Get-Date).ToString('yyyy-MM-dd HH:mm'))]`r`n- $Message`r`n"
    Add-Content -Path $LogFile -Value $entry
    Write-Log "Change log updated successfully."
}
catch {
    Write-Log "Error updating change log: $_" -Level "ERROR"
}
finally {
    Close-Logger "ChangeLog"
}

# Problem #23: Audit Local Administrators (Refactored with LoggerModule)
# Lists members of the local Administrators group

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "AuditLocalAdmins"

try {
    Write-Log "Auditing local Administrators group..."

    $admins = Get-LocalGroupMember -Group "Administrators" -ErrorAction SilentlyContinue
    if (-Not $admins) {
        Write-Log "No local administrators found." -Level "WARN"
        Close-Logger "AuditLocalAdmins"
        exit
    }

    $admins | Select-Object Name, ObjectClass | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Local administrators audit completed successfully."
}
catch {
    Write-Log "Error retrieving local administrators: $_" -Level "ERROR"
}
finally {
    Close-Logger "AuditLocalAdmins"
}

# Problem #28: Policy Compliance Audit (Refactored with LoggerModule)
# Checks key Windows security/compliance policies

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "PolicyCompliance"

try {
    Write-Log "Auditing policy compliance..."

    $policies = @(
        @{ Name="Password Complexity"; Value=(Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -ErrorAction SilentlyContinue).LimitBlankPasswordUse },
        @{ Name="Minimum Password Length"; Value=(Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -ErrorAction SilentlyContinue).MinimumPasswordLength },
        @{ Name="Audit Logon Events"; Value=(Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -ErrorAction SilentlyContinue).AuditLogonEvents }
    )

    $policies | Format-Table Name, Value -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Policy compliance audit completed successfully."
}
catch {
    Write-Log "Error retrieving policy compliance info: $_" -Level "ERROR"
}
finally {
    Close-Logger "PolicyCompliance"
}

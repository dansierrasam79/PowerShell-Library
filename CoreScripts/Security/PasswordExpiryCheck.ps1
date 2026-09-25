# Problem #24: Password Expiry Check (Refactored with LoggerModule)
# Lists local user accounts and their password expiry details

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "PasswordExpiryCheck"

try {
    Write-Log "Checking password expiry for local users..."

    $users = Get-LocalUser -ErrorAction SilentlyContinue
    if (-Not $users) {
        Write-Log "No local users found." -Level "WARN"
        Close-Logger "PasswordExpiryCheck"
        exit
    }

    $users | Select-Object Name, Enabled, LastLogon, PasswordExpires |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Password expiry check completed successfully."
}
catch {
    Write-Log "Error retrieving password expiry info: $_" -Level "ERROR"
}
finally {
    Close-Logger "PasswordExpiryCheck"
}

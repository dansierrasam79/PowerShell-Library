# Problem #5: User Account Management (Refactored with LoggerModule)
# Lists local user accounts and allows basic management actions

param(
    [switch]$ListOnly = $true
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "UserAccountManagement"

try {
    Write-Log "Retrieving local user accounts..."

    $users = Get-LocalUser -ErrorAction SilentlyContinue
    if (-Not $users) {
        Write-Log "No local users found." -Level "WARN"
        Close-Logger "UserAccountManagement"
        exit
    }

    $users | Select-Object Name, Enabled, LastLogon |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    if (-Not $ListOnly) {
        Write-Log "Management mode enabled. Example: disabling Guest account..."
        $guest = Get-LocalUser -Name "Guest" -ErrorAction SilentlyContinue
        if ($guest -and $guest.Enabled) {
            Disable-LocalUser -Name "Guest"
            Write-Log "Guest account disabled successfully."
        } else {
            Write-Log "Guest account not found or already disabled." -Level "WARN"
        }
    }

    Write-Log "User account management completed successfully."
}
catch {
    Write-Log "Error managing user accounts: $_" -Level "ERROR"
}
finally {
    Close-Logger "UserAccountManagement"
}

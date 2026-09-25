# Problem #36: Microsoft 365 License Report (Refactored with LoggerModule)
# Reports license usage for Microsoft 365 users

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "M365LicenseReport"

try {
    Write-Log "Generating Microsoft 365 license report..."

    Connect-MgGraph -Scopes "User.Read.All" -ErrorAction SilentlyContinue | Out-Null
    Select-MgProfile -Name "beta"

    $users = Get-MgUser -Property "DisplayName,UserPrincipalName,AssignedLicenses" -All
    if (-Not $users) {
        Write-Log "No Microsoft 365 users found." -Level "WARN"
        Close-Logger "M365LicenseReport"
        exit
    }

    foreach ($u in $users) {
        $info = [PSCustomObject]@{
            DisplayName = $u.DisplayName
            UPN         = $u.UserPrincipalName
            Licenses    = ($u.AssignedLicenses.SkuId -join ", ")
        }
        $info | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    }

    Write-Log "M365 license report generated successfully."
}
catch {
    Write-Log "Error generating M365 license report: $_" -Level "ERROR"
}
finally {
    Close-Logger "M365LicenseReport"
}

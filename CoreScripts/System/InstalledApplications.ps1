# Problem #48: Installed Applications (Refactored with LoggerModule)
# Lists installed applications from registry

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "InstalledApplications"

try {
    Write-Log "Gathering installed applications..."

    $apps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
            Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

    if (-Not $apps) {
        Write-Log "No installed applications found." -Level "WARN"
        Close-Logger "InstalledApplications"
        exit
    }

    $apps | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Installed applications report generated successfully."
}
catch {
    Write-Log "Error retrieving installed applications: $_" -Level "ERROR"
}
finally {
    Close-Logger "InstalledApplications"
}

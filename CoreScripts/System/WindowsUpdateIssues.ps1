# Problem #49: Windows Update Issues (Refactored with LoggerModule)
# Reports recent Windows Update history and failures

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "WindowsUpdateIssues"

try {
    Write-Log "Checking Windows Update history..."

    $updates = Get-WindowsUpdateLog -ErrorAction SilentlyContinue
    if (-Not $updates) {
        Write-Log "No update logs found." -Level "WARN"
        Close-Logger "WindowsUpdateIssues"
        exit
    }

    $updates | Select-Object Time, Message | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Windows Update issues report generated successfully."
}
catch {
    Write-Log "Error retrieving Windows Update info: $_" -Level "ERROR"
}
finally {
    Close-Logger "WindowsUpdateIssues"
}

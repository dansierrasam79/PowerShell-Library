# Problem #47: Startup Programs Audit (Refactored with LoggerModule)
# Lists programs configured to run at startup

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "StartupPrograms"

try {
    Write-Log "Auditing startup programs..."

    $startupItems = Get-CimInstance Win32_StartupCommand -ErrorAction SilentlyContinue
    if (-Not $startupItems) {
        Write-Log "No startup programs found." -Level "WARN"
        Close-Logger "StartupPrograms"
        exit
    }

    $startupItems | Select-Object Name, Command, Location |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Startup programs audit completed successfully."
}
catch {
    Write-Log "Error auditing startup programs: $_" -Level "ERROR"
}
finally {
    Close-Logger "StartupPrograms"
}

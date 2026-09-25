# Problem #56: Background Jobs Manager (Refactored with LoggerModule)
# Lists and manages PowerShell background jobs

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "BackgroundJobs"

try {
    Write-Log "Checking background jobs..."

    $jobs = Get-Job -ErrorAction SilentlyContinue
    if (-Not $jobs) {
        Write-Log "No background jobs found." -Level "WARN"
        Close-Logger "BackgroundJobs"
        exit
    }

    $jobs | Select-Object Id, Name, State, HasMoreData |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Background jobs audit completed successfully."
}
catch {
    Write-Log "Error retrieving background jobs: $_" -Level "ERROR"
}
finally {
    Close-Logger "BackgroundJobs"
}

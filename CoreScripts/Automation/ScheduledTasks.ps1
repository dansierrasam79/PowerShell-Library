# Problem #55: Scheduled Tasks Audit (Refactored with LoggerModule)
# Lists scheduled tasks and their status

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "ScheduledTasks"

try {
    Write-Log "Auditing scheduled tasks..."

    $tasks = Get-ScheduledTask -ErrorAction SilentlyContinue
    if (-Not $tasks) {
        Write-Log "No scheduled tasks found." -Level "WARN"
        Close-Logger "ScheduledTasks"
        exit
    }

    $tasks | Select-Object TaskName, State, Author |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Scheduled tasks audit completed successfully."
}
catch {
    Write-Log "Error retrieving scheduled tasks: $_" -Level "ERROR"
}
finally {
    Close-Logger "ScheduledTasks"
}


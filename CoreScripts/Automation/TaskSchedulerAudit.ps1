# Problem #58: Task Scheduler Audit (Refactored with LoggerModule)
# Audits Task Scheduler entries for compliance

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "TaskSchedulerAudit"

try {
    Write-Log "Auditing Task Scheduler entries..."

    $tasks = schtasks /Query /FO LIST /V
    if (-Not $tasks) {
        Write-Log "No Task Scheduler entries found." -Level "WARN"
        Close-Logger "TaskSchedulerAudit"
        exit
    }

    $tasks | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Task Scheduler audit completed successfully."
}
catch {
    Write-Log "Error auditing Task Scheduler: $_" -Level "ERROR"
}
finally {
    Close-Logger "TaskSchedulerAudit"
}

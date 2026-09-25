# Problem #37: Network Trace (Refactored with LoggerModule)
# Performs a traceroute to a target host

param(
    [string]$Target = "8.8.8.8"
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "NetworkTrace"

try {
    Write-Log "Running network trace to $Target..."

    $trace = Test-NetConnection -ComputerName $Target -TraceRoute -ErrorAction SilentlyContinue
    if (-Not $trace) {
        Write-Log "No trace results found." -Level "WARN"
        Close-Logger "NetworkTrace"
        exit
    }

    $trace.TraceRoute | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Network trace completed successfully."
}
catch {
    Write-Log "Error running network trace: $_" -Level "ERROR"
}
finally {
    Close-Logger "NetworkTrace"
}

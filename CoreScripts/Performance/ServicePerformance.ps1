# Problem #21: Service Performance (Refactored with LoggerModule)
# Lists running services and their resource usage

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "ServicePerformance"

try {
    Write-Log "Gathering service performance information..."

    $services = Get-Service | Where-Object { $_.Status -eq "Running" }
    if (-Not $services) {
        Write-Log "No running services found." -Level "WARN"
        Close-Logger "ServicePerformance"
        exit
    }

    foreach ($svc in $services) {
        $proc = Get-Process -Name $svc.Name -ErrorAction SilentlyContinue
        if ($proc) {
            $info = [PSCustomObject]@{
                ServiceName = $svc.Name
                DisplayName = $svc.DisplayName
                CPU         = $proc.CPU
                MemoryMB    = [math]::Round($proc.WorkingSet/1MB,2)
            }
            $info | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
        }
    }

    Write-Log "Service performance audit completed successfully."
}
catch {
    Write-Log "Error retrieving service performance: $_" -Level "ERROR"
}
finally {
    Close-Logger "ServicePerformance"
}

# Problem #30: System Baseline Compare (Refactored with LoggerModule)
# Compares current system configuration against a saved baseline

param(
    [string]$BaselineFile = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'Baseline\system_baseline.json')
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "SystemBaselineCompare"

try {
    Write-Log "Comparing system configuration against baseline..."

    if (-Not (Test-Path $BaselineFile)) {
        Write-Log "Baseline file not found: $BaselineFile" -Level "ERROR"
        Close-Logger "SystemBaselineCompare"
        exit
    }

    $baseline = Get-Content $BaselineFile | ConvertFrom-Json
    $current = @{
        OSVersion = (Get-CimInstance Win32_OperatingSystem).Version
        ComputerName = $env:COMPUTERNAME
        InstalledApps = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName).DisplayName
    }

    $differences = Compare-Object -ReferenceObject $baseline.InstalledApps -DifferenceObject $current.InstalledApps

    $differences | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Baseline comparison completed successfully."
}
catch {
    Write-Log "Error comparing system baseline: $_" -Level "ERROR"
}
finally {
    Close-Logger "SystemBaselineCompare"
}

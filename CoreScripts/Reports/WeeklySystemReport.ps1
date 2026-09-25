# Problem #41: Weekly System Report (Refactored with LoggerModule)
# Summarizes system performance and events for the past 7 days

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "WeeklySystemReport"

try {
    Write-Log "Generating weekly system report..."

    $cutoff = (Get-Date).AddDays(-7)
    $events = Get-WinEvent -LogName System | Where-Object { $_.TimeCreated -ge $cutoff } | Select-Object -First 50

    $uptime = (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
    $cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' | 
               Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

    $report = [PSCustomObject]@{
        Date       = Get-Date
        Computer   = $env:COMPUTERNAME
        UptimeDays = $uptime.Days
        AvgCPU     = [math]::Round($cpuLoad,2)
        EventCount = $events.Count
    }

    $report | Format-List | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Weekly system report generated successfully."
}
catch {
    Write-Log "Error generating weekly system report: $_" -Level "ERROR"
}
finally {
    Close-Logger "WeeklySystemReport"
}

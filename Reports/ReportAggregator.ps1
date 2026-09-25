# ReportAggregator.ps1
# Collects reports from Daily and Weekly, applies retention, archives old files

Import-Module (Join-Path $PSScriptRoot '..\Modules\ConfigLoader.psm1')
Import-Config

$dailyDir   = Get-ConfigValue -FileName "paths" -Key "ReportsDir" + "\Daily"
$weeklyDir  = Get-ConfigValue -FileName "paths" -Key "ReportsDir" + "\Weekly"
$archiveDir = Get-ConfigValue -FileName "paths" -Key "ReportsDir" + "\Archive"
$retention  = Get-ConfigValue -FileName "settings" -Key "LogRetentionDays"

Write-Output "=== Report Aggregator ==="
Write-Output "Daily: $dailyDir"
Write-Output "Weekly: $weeklyDir"
Write-Output "Archive: $archiveDir"
Write-Output "Retention: $retention days"

# Ensure archive folder exists
if (-not (Test-Path $archiveDir)) {
    New-Item -ItemType Directory -Path $archiveDir | Out-Null
}

# Move old reports to Archive
$cutoff = (Get-Date).AddDays(-$retention)

Get-ChildItem -Path $dailyDir -File | Where-Object { $_.LastWriteTime -lt $cutoff } | ForEach-Object {
    Move-Item $_.FullName -Destination $archiveDir -Force
    Write-Output "Archived old daily report: $($_.Name)"
}

Get-ChildItem -Path $weeklyDir -File | Where-Object { $_.LastWriteTime -lt $cutoff } | ForEach-Object {
    Move-Item $_.FullName -Destination $archiveDir -Force
    Write-Output "Archived old weekly report: $($_.Name)"
}

# Generate a weekly summary (simple concatenation)
$summaryFile = Join-Path $weeklyDir "WeeklySummary.txt"
Get-ChildItem -Path $weeklyDir -File | ForEach-Object {
    Add-Content -Path $summaryFile -Value "===== $($_.Name) ====="
    Add-Content -Path $summaryFile -Value (Get-Content $_.FullName)
    Add-Content -Path $summaryFile -Value "`n"
}

Write-Output "Weekly summary generated: $summaryFile"

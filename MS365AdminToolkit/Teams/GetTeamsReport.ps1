Import-Module (Join-Path $PSScriptRoot '..\..\Modules\ConfigLoader.psm1')
Import-Config
$reportDir = Get-ConfigValue -FileName "settings" -Key "ReportDirectory"
Write-Output "Simulated Teams Report"
Write-Output "Report would normally be saved to: $reportDir"

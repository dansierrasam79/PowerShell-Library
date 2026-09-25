# Problem #6: Monitor Firewall (Refactored with LoggerModule)
# Comprehensive firewall monitoring and audit tool

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "Monitor-Firewall"

try {
    Write-Log "Auditing firewall profiles..."
    Get-NetFirewallProfile | Format-Table Name, Enabled, DefaultInboundAction, DefaultOutboundAction | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Auditing custom block rules..."
    Get-NetFirewallRule | Where-Object DisplayName -like "Block*" | Format-Table DisplayName, Enabled, Direction, Action | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Auditing active TCP connections..."
    Get-NetTCPConnection | Sort-Object LocalPort | Format-Table LocalAddress, LocalPort, RemoteAddress, State | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Auditing active UDP endpoints..."
    Get-NetUDPEndpoint | Sort-Object LocalPort | Format-Table LocalAddress, LocalPort, RemoteAddress, LocalPort | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Firewall monitoring completed successfully."
}
catch {
    Write-Log "Error retrieving firewall info: $_" -Level "ERROR"
}
finally {
    Close-Logger "Monitor-Firewall"
}

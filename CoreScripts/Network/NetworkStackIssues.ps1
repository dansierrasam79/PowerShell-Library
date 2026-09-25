# Problem #4: Network Stack Issues (Refactored with LoggerModule)
# Collects network adapter and IP configuration details with error handling

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')

Initialize-Logger "NetworkStackIssues"

try {
    Write-Log "Gathering network stack information..."

    $adapters = Get-NetAdapter -ErrorAction Stop
    if (-Not $adapters) {
        Write-Log "No network adapters found." -Level "WARN"
        Close-Logger "NetworkStackIssues"
        exit
    }

    Write-Log "Network Adapters:" 
    $adapters | Select-Object Name, InterfaceDescription, Status, MacAddress, LinkSpeed | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "IP Configuration:" 
    Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Connectivity Test (ping to 8.8.8.8):"
    $pingResult = Test-Connection -ComputerName 8.8.8.8 -Count 2 -ErrorAction SilentlyContinue |
                  Select-Object Address, ResponseTime, Status
    $pingResult | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Report completed successfully." -Level "INFO"
}
catch {
    Write-Log "Error retrieving network info: $_" -Level "ERROR"
}
finally {
    Close-Logger "NetworkStackIssues"
}

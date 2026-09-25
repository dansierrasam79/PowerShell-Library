# Problem #2: Block Risky Ports (Refactored with LoggerModule)
# Harden Windows by blocking risky inbound ports

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "Block-RiskyPorts"

try {
    $adapter = Get-NetAdapter -Name "Ethernet 2" -ErrorAction SilentlyContinue
    if ($adapter -and $adapter.Status -eq "Up") {
        Write-Log "Ethernet 2 is active. Applying firewall rules..."

        New-NetFirewallRule -DisplayName "Block RPC 135" -Direction Inbound -LocalPort 135 -Protocol TCP -InterfaceAlias "Ethernet 2" -Action Block
        New-NetFirewallRule -DisplayName "Block SMB 445" -Direction Inbound -LocalPort 445 -Protocol TCP -InterfaceAlias "Ethernet 2" -Action Block
        New-NetFirewallRule -DisplayName "Block WinRM 5985" -Direction Inbound -LocalPort 5985 -Protocol TCP -InterfaceAlias "Ethernet 2" -Action Block
        New-NetFirewallRule -DisplayName "Block NetBIOS UDP 137" -Direction Inbound -LocalPort 137 -Protocol UDP -InterfaceAlias "Ethernet 2" -Action Block

        Write-Log "Firewall rules applied successfully."
    } else {
        Write-Log "Ethernet 2 not active. No rules applied." -Level "WARN"
    }
}
catch {
    Write-Log "Error applying firewall rules: $_" -Level "ERROR"
}
finally {
    Close-Logger "Block-RiskyPorts"
}


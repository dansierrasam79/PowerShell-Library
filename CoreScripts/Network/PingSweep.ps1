# Problem #18: Ping Sweep (Refactored with LoggerModule)
# Performs a ping sweep across a subnet range

param(
    [string]$Subnet = "192.168.1",
    [int]$Start = 1,
    [int]$End = 20
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "PingSweep"

try {
    Write-Log "Performing ping sweep on $Subnet.$Start-$End..."

    $results = for ($i = $Start; $i -le $End; $i++) {
        $ip = "$Subnet.$i"
        $ping = Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue
        [PSCustomObject]@{ IPAddress = $ip; Reachable = $ping }
    }

    $results | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Ping sweep completed successfully."
}
catch {
    Write-Log "Error during ping sweep: $_" -Level "ERROR"
}
finally {
    Close-Logger "PingSweep"
}


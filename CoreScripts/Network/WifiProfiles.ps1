# Problem #19: Wi-Fi Profiles (Refactored with LoggerModule)
# Lists saved Wi-Fi profiles and their authentication details

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "WiFiProfiles"

try {
    Write-Log "Gathering Wi-Fi profile information..."

    $profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
        ($_ -split ":")[1].Trim()
    }

    if (-Not $profiles) {
        Write-Log "No Wi-Fi profiles found." -Level "WARN"
        Close-Logger "WiFiProfiles"
        exit
    }

    $wifiInfo = foreach ($profile in $profiles) {
        $details = netsh wlan show profile name="$profile" | Select-String "Authentication|Cipher"
        [PSCustomObject]@{
            Profile        = $profile
            Authentication = ($details | Where-Object { $_ -match "Authentication" } -split ":")[1].Trim()
            Cipher         = ($details | Where-Object { $_ -match "Cipher" } -split ":")[1].Trim()
        }
    }

    $wifiInfo | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
    Write-Log "Wi-Fi profiles audit completed successfully."
}
catch {
    Write-Log "Error retrieving Wi-Fi profiles: $_" -Level "ERROR"
}
finally {
    Close-Logger "WiFiProfiles"
}

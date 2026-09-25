# Problem #35: Azure Resource Audit (Refactored with LoggerModule)
# Lists Azure resources using Az PowerShell module

param(
    [string]$SubscriptionId = ""
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "AzureResourceAudit"

try {
    Write-Log "Auditing Azure resources..."

    Connect-AzAccount -ErrorAction SilentlyContinue | Out-Null
    if ($SubscriptionId) { Set-AzContext -Subscription $SubscriptionId | Out-Null }

    $resources = Get-AzResource -ErrorAction SilentlyContinue
    if (-Not $resources) {
        Write-Log "No Azure resources found." -Level "WARN"
        Close-Logger "AzureResourceAudit"
        exit
    }

    $resources | Select-Object Name, ResourceType, ResourceGroupName, Location |
        Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Azure resource audit completed successfully."
}
catch {
    Write-Log "Error auditing Azure resources: $_" -Level "ERROR"
}
finally {
    Close-Logger "AzureResourceAudit"
}

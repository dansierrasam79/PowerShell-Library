# Problem #32: Registry Backup (Refactored with LoggerModule)
# Exports Windows registry hives to backup files

param(
    [string]$BackupPath = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'Backups\Registry')
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "RegistryBackup"

try {
    Write-Log "Backing up registry hives to $BackupPath..."

    $hives = @("HKCU","HKLM","HKCR","HKU","HKCC")
    foreach ($hive in $hives) {
        $file = Join-Path $BackupPath "$hive.reg"
        reg export $hive $file /y | Out-Null
        Write-Log "Exported $hive to $file"
    }

    Write-Log "Registry backup completed successfully."
}
catch {
    Write-Log "Error during registry backup: $_" -Level "ERROR"
}
finally {
    Close-Logger "RegistryBackup"
}

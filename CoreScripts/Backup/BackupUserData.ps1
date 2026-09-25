# Problem #31: Backup User Data (Refactored with LoggerModule)
# Copies user Documents, Desktop, and Pictures to a backup location

param(
    [string]$BackupPath = (Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'Backups\UserData')
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "BackupUserData"

try {
    Write-Log "Backing up user data to $BackupPath..."

    $folders = @("Documents","Desktop","Pictures")
    foreach ($folder in $folders) {
        $source = Join-Path $env:USERPROFILE $folder
        if (Test-Path $source) {
            $dest = Join-Path $BackupPath $folder
            robocopy $source $dest /MIR /R:1 /W:1 | Out-Null
            Write-Log "Backed up $folder to $dest"
        } else {
            Write-Log "Folder not found: $source" -Level "WARN"
        }
    }

    Write-Log "User data backup completed successfully."
}
catch {
    Write-Log "Error during user data backup: $_" -Level "ERROR"
}
finally {
    Close-Logger "BackupUserData"
}

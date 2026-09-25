# Problem #12: File/Folder Automation (Refactored with LoggerModule)
# Automates creation of folders and moves files

param(
    [string]$Source = "C:\Users\chakdaniel\Downloads",
    [string]$Destination = "C:\Users\chakdaniel\Documents\Organized"
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "FileFolderAutomation"

try {
    Write-Log "Automating file/folder organization from $Source to $Destination..."

    if (-Not (Test-Path $Destination)) { New-Item -ItemType Directory -Path $Destination | Out-Null }

    Get-ChildItem -Path $Source -File | ForEach-Object {
        $ext = $_.Extension.TrimStart(".")
        $target = Join-Path $Destination $ext
        if (-Not (Test-Path $target)) { New-Item -ItemType Directory -Path $target | Out-Null }
        Move-Item $_.FullName $target -Force
        Write-Log "Moved $($_.Name) to $target"
    }

    Write-Log "File/folder automation completed successfully."
}
catch {
    Write-Log "Error during file/folder automation: $_" -Level "ERROR"
}
finally {
    Close-Logger "FileFolderAutomation"
}

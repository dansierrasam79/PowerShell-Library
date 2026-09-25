# Problem #13: Find Large Files (Refactored with LoggerModule)
# Lists files larger than a threshold size

param(
    [string]$Path = "C:\Users\chakdaniel\Documents",
    [int]$SizeMB = 100
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "FindLargeFiles"

try {
    Write-Log "Searching for files larger than $SizeMB MB in $Path..."

    $files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
             Where-Object { $_.Length -gt ($SizeMB * 1MB) }

    if (-Not $files) {
        Write-Log "No files larger than $SizeMB MB found." -Level "WARN"
        Close-Logger "FindLargeFiles"
        exit
    }

    $files | Select-Object FullName,@{Name="SizeMB";Expression={[math]::Round($_.Length/1MB,2)}} |
        Sort-Object SizeMB -Descending | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }

    Write-Log "Large file search completed successfully."
}
catch {
    Write-Log "Error searching for large files: $_" -Level "ERROR"
}
finally {
    Close-Logger "FindLargeFiles"
}

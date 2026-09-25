# Problem #26: Duplicate Files (Refactored with LoggerModule)
# Scans a directory for duplicate files based on hash comparison

param(
    [string]$Path = "C:\Users\chakdaniel\Documents"
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "DuplicateFiles"

try {
    Write-Log "Scanning for duplicate files in $Path..."

    $files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue
    if (-Not $files) {
        Write-Log "No files found under $Path." -Level "WARN"
        Close-Logger "DuplicateFiles"
        exit
    }

    $hashes = @{}
    $duplicates = @()

    foreach ($file in $files) {
        try {
            $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash
            if ($hashes.ContainsKey($hash)) {
                $duplicates += [PSCustomObject]@{ Duplicate = $file.FullName; Original = $hashes[$hash] }
            } else {
                $hashes[$hash] = $file.FullName
            }
        } catch {
            Write-Log "Error hashing file: $($file.FullName)" -Level "ERROR"
        }
    }

    if ($duplicates.Count -gt 0) {
        $duplicates | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Log $_ }
        Write-Log "Duplicate files detected."
    } else {
        Write-Log "No duplicate files found." -Level "INFO"
    }
}
catch {
    Write-Log "Error scanning for duplicates: $_" -Level "ERROR"
}
finally {
    Close-Logger "DuplicateFiles"
}

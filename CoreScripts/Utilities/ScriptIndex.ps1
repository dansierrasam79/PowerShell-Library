# Problem #43: Script Index Generator (Refactored with LoggerModule)
# Builds an index of all scripts in the CoreScripts library

param(
    [string]$RootPath = (Split-Path -Parent $PSScriptRoot)
)

Import-Module (Join-Path $PSScriptRoot '..\Utilities\LoggerModule.psm1')
Initialize-Logger "ScriptIndex"

try {
    Write-Log "Building script index from $RootPath..."

    $scripts = Get-ChildItem -Path $RootPath -Recurse -Include *.ps1,*.psm1 -ErrorAction SilentlyContinue
    if (-Not $scripts) {
        Write-Log "No scripts found under $RootPath." -Level "WARN"
        Close-Logger "ScriptIndex"
        exit
    }

    $scripts | ForEach-Object { Write-Log $_.FullName }
    Write-Log "Script index generated successfully."
}
catch {
    Write-Log "Error generating script index: $_" -Level "ERROR"
}
finally {
    Close-Logger "ScriptIndex"
}

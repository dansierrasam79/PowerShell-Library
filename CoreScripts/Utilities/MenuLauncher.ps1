# Problem #46: Menu Launcher (Refactored with LoggerModule)
# Provides a menu to run scripts from categories

param(
    [string]$RootPath = (Join-Path (Split-Path -Parent $PSScriptRoot) ".")
)

Import-Module (Join-Path $RootPath "Utilities\LoggerModule.psm1")
Initialize-Logger "MenuLauncher"

try {
    Write-Log "Launching CoreScripts menu..."

    $categories = Get-ChildItem -Path $RootPath -Directory
    $i = 1
    foreach ($cat in $categories) {
        Write-Log "$i. $($cat.Name)"
        $i++
    }

    $choice = Read-Host "Select a category number"
    $selected = $categories[$choice - 1]

    $scripts = Get-ChildItem -Path $selected.FullName -Filter *.ps1
    $j = 1
    foreach ($s in $scripts) {
        Write-Log "$j. $($s.Name)"
        $j++
    }

    $scriptChoice = Read-Host "Select a script number"
    $scriptToRun = $scripts[$scriptChoice - 1].FullName

    Write-Log "Running $scriptToRun..."
    & $scriptToRun
    Write-Log "Menu launcher executed successfully."
}
catch {
    Write-Log "Error running menu launcher: $_" -Level "ERROR"
}
finally {
    Close-Logger "MenuLauncher"
}
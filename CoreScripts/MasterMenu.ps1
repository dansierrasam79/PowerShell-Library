# MasterMenu.ps1
# Unified launcher for CoreScripts
# Supports both browsing and searching for .ps1/.psm1 scripts

param(
    [string]$RootPath = $PSScriptRoot
)

Import-Module (Join-Path $RootPath "Utilities\LoggerModule.psm1")
Initialize-Logger "MasterMenu"

try {
    Write-Log "Launching MasterMenu with search option..."

    $mode = Read-Host "Choose mode: (1) Browse folders, (2) Search by name"

    if ($mode -eq "1") {
        # Browse mode
        $folders = Get-ChildItem -Path $RootPath -Directory
        $i = 1
        foreach ($f in $folders) { Write-Host "$i. $($f.Name)"; $i++ }

        $folderChoice = Read-Host "Select a folder number"
        $selectedFolder = $folders[$folderChoice - 1]

        $items = Get-ChildItem -Path $selectedFolder.FullName -Include *.ps1,*.psm1 -ErrorAction SilentlyContinue
    }
    elseif ($mode -eq "2") {
        # Search mode
        $searchTerm = Read-Host "Enter part of script/module name"
        $items = Get-ChildItem -Path $RootPath -Recurse -Include *.ps1,*.psm1 -ErrorAction SilentlyContinue |
                 Where-Object { $_.Name -like "*$searchTerm*" }
    }
    else {
        Write-Log "Invalid mode selected." -Level "WARN"
        Close-Logger "MasterMenu"
        exit
    }

    if (-Not $items) {
        Write-Log "No matching scripts/modules found." -Level "WARN"
        Close-Logger "MasterMenu"
        exit
    }

    $j = 1
    foreach ($item in $items) { Write-Host "$j. $($item.Name)"; $j++ }

    $itemChoice = Read-Host "Select a script/module number"
    $selectedItem = $items[$itemChoice - 1]

    if ($selectedItem.Extension -eq ".ps1") {
        Write-Log "Running script: $($selectedItem.FullName)"
        & $selectedItem.FullName
        Write-Log "Script executed successfully."
    }
    elseif ($selectedItem.Extension -eq ".psm1") {
        Write-Log "Importing module: $($selectedItem.FullName)"
        Import-Module $selectedItem.FullName -Force
        Write-Log "Module imported successfully."
    }
    else {
        Write-Log "Unsupported file type: $($selectedItem.Extension)" -Level "WARN"
    }
}
catch {
    Write-Log "Error running MasterMenu: $_" -Level "ERROR"
}
finally {
    Close-Logger "MasterMenu"
}
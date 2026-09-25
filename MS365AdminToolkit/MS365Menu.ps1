# MS365Menu.ps1
# Interactive launcher for MS365AdminToolkit scripts

param(
    [string]$RootPath = $PSScriptRoot
)

Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) "Modules\ConfigLoader.psm1")
Import-Config

Write-Host "=== Microsoft 365 Admin Toolkit Menu ==="
Write-Host "Select a workload:"

$folders = Get-ChildItem -Path $RootPath -Directory
$i = 1
foreach ($f in $folders) {
    Write-Host "$i. $($f.Name)"
    $i++
}

$folderChoice = Read-Host "Enter workload number"
$selectedFolder = $folders[$folderChoice - 1]

# List scripts in chosen workload
$items = Get-ChildItem -Path $selectedFolder.FullName -Filter *.ps1 -ErrorAction SilentlyContinue
$j = 1
foreach ($item in $items) {
    Write-Host "$j. $($item.Name)"
    $j++
}

$itemChoice = Read-Host "Enter script number"
$selectedItem = $items[$itemChoice - 1]

Write-Host "Running $($selectedItem.Name)..."
& $selectedItem.FullName
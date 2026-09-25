# Problem #45: Logger Module (Already standardized)
# Provides reusable logging functions for CoreScripts

$script:LoggerModuleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Initialize-Logger {
    param([string]$ScriptName)

    $reportRoot = Join-Path $script:LoggerModuleRoot "..\..\Reports\Daily"
    if (-not (Test-Path $reportRoot)) { New-Item -ItemType Directory -Path $reportRoot -Force | Out-Null }
    $reportRoot = (Resolve-Path $reportRoot).Path

    $timestamp = Get-Date -Format "yyyyMMdd_HHmm"
    $global:LogFile = Join-Path $reportRoot "$ScriptName_$timestamp.txt"
    "[$(Get-Date)] Starting $ScriptName" | Out-File $global:LogFile -Encoding UTF8
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")

    $entry = "[$(Get-Date)] [$Level] $Message"
    Write-Host $entry
    $entry | Out-File $global:LogFile -Append
}

function Close-Logger {
    param([string]$ScriptName)
    "[$(Get-Date)] Completed $ScriptName" | Out-File $global:LogFile -Append
}

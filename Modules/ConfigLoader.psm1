# ConfigLoader.psm1
# Loads configuration files from the Config folder
# Provides helper functions for retrieving and updating values
# Integrates with LoggerModule.psm1

$global:ConfigData = @{}

function Import-Config {
    param(
        [string]$ConfigPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "Config")
    )

    Import-Module (Join-Path (Split-Path -Parent $PSScriptRoot) "CoreScripts\Utilities\LoggerModule.psm1") -Force
    Initialize-Logger "ConfigLoader"

    try {
        if (-not (Test-Path -Path $ConfigPath -PathType Container)) {
            throw "Configuration directory not found: $ConfigPath"
        }

        Write-Log "Loading configuration files from $ConfigPath..."

        # Load JSON configs
        Get-ChildItem -Path $ConfigPath -Filter *.json -File -ErrorAction Stop | ForEach-Object {
            $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
            $global:ConfigData[$_.BaseName] = $json
            Write-Log "Loaded JSON config: $($_.Name)"
        }

        # Load PSD1 configs
        Get-ChildItem -Path $ConfigPath -Filter *.psd1 -File -ErrorAction Stop | ForEach-Object {
            $psd1 = Import-PowerShellDataFile $_.FullName
            $global:ConfigData[$_.BaseName] = $psd1
            Write-Log "Loaded PSD1 config: $($_.Name)"
        }

        Write-Log "Configuration loading completed successfully."
    }
    catch {
        Write-Log "Error loading configuration: $_" -Level "ERROR"
        throw
    }
    finally {
        Close-Logger "ConfigLoader"
    }
}

function Get-ConfigValue {
    param(
        [string]$FileName,
        [string]$Key
    )
    if ($global:ConfigData.ContainsKey($FileName)) {
        return $global:ConfigData[$FileName].$Key
    } else {
        Write-Log "Config file $FileName not found." -Level "WARN"
        return $null
    }
}

function Set-ConfigValue {
    param(
        [string]$FileName,
        [string]$Key,
        [string]$Value
    )
    if ($global:ConfigData.ContainsKey($FileName)) {
        $global:ConfigData[$FileName].$Key = $Value
        Write-Log "Updated $Key in $FileName to $Value."
    } else {
        Write-Log "Config file $FileName not found." -Level "WARN"
    }
}

function Update-Config {
    param(
        [string]$ConfigPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "Config")
    )

    try {
        Import-Config -ConfigPath $ConfigPath
    }
    catch {
        Write-Log "Error updating configuration: $_" -Level "ERROR"
        throw
    }
}
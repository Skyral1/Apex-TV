#Requires -Version 5.1
<#
.SYNOPSIS
Regenerates ignored test helpers after a checkout, pull or Dart API change.
.DESCRIPTION
Runs from the repository root, regardless of the caller's directory.
Only generated outputs may be replaced; no Git reset or Flutter clean is run.
A failed dependency or generation command stops preparation immediately.
#>
[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-CheckedTool {
    param(
        [Parameter(Mandatory = $true)][string]$Executable,
        [Parameter(Mandatory = $true)][string[]]$ToolArguments
    )

    Write-Host ('=> {0} {1}' -f (Split-Path -Leaf $Executable), ($ToolArguments -join ' '))
    & $Executable @ToolArguments
    if ($LASTEXITCODE -ne 0) {
        throw ('Command failed (exit {0}): {1} {2}' -f $LASTEXITCODE, $Executable, ($ToolArguments -join ' '))
    }
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $repositoryRoot
try {
    # Application also resolves flutter.bat / dart.bat on Windows.
    $flutter = (Get-Command flutter -CommandType Application -ErrorAction Stop).Source
    $dart = (Get-Command dart -CommandType Application -ErrorAction Stop).Source

    Invoke-CheckedTool -Executable $flutter -ToolArguments @('pub', 'get')
    Invoke-CheckedTool -Executable $dart -ToolArguments @('run', 'build_runner', 'build', '--delete-conflicting-outputs')

    $mocksPath = Join-Path $repositoryRoot 'test/mocks.mocks.dart'
    if (-not (Test-Path -LiteralPath $mocksPath -PathType Leaf)) {
        throw 'Mockito did not generate test/mocks.mocks.dart. Do not run the tests yet; inspect the generator output.'
    }
    $mocks = Get-Content -LiteralPath $mocksPath -Raw
    if ($mocks -cmatch '\b(?:CellularNetworkType|NetworkType)\s*\.\s*[A-Z]\w*') {
        throw 'Generated network mocks still reference old enum names. Check that lib/ and test/mocks.dart are on the same revision.'
    }

    Invoke-CheckedTool -Executable $dart -ToolArguments @('run', 'drift_dev', 'schema', 'generate', 'drift_schemas/', 'test/generated_migrations/')
    Write-Host 'Test helpers are ready. Next: flutter analyze; flutter test'
}
finally {
    Pop-Location
}

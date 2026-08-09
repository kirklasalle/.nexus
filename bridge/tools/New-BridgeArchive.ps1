[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$BridgePath = ".",
    [string]$ArchiveMonth = (Get-Date).ToString("yyyy-MM"),
    [switch]$Force
)

$ErrorActionPreference = "Stop"
if ($BridgePath -eq "." -and $PSScriptRoot) {
    $BridgePath = (Join-Path $PSScriptRoot "..")
}
$bridgeRoot = (Resolve-Path $BridgePath).Path
$agentsDir = Join-Path $bridgeRoot "Agents"

if (-not (Test-Path $agentsDir -PathType Container)) {
    throw "Agents directory missing at $agentsDir"
}

$archiveDir = Join-Path $agentsDir "Archive"
if (-not (Test-Path $archiveDir -PathType Container)) {
    New-Item -Path $archiveDir -ItemType Directory | Out-Null
}

$activeThreads = Get-ChildItem -Path $agentsDir -Filter "*_Thread.md" -File
$results = New-Object System.Collections.Generic.List[object]

foreach ($thread in $activeThreads) {
    $activePath = $thread.FullName
    $agentName = $thread.Name -replace "_Thread.md$", ""
    $archiveName = "Thread_Archive_${agentName}_${ArchiveMonth}.md"
    $archivePath = Join-Path $archiveDir $archiveName

    if ((Test-Path $archivePath -PathType Leaf) -and -not $Force) {
        throw "Archive already exists: $archivePath. Use -Force to overwrite."
    }

    if ($PSCmdlet.ShouldProcess($agentName, "Archive active thread to $archivePath and reset active thread")) {
        Copy-Item -Path $activePath -Destination $archivePath -Force:$Force
        
        $templateLines = @(
            "# Active Thread: $agentName",
            "",
            "This file is the dedicated active communication thread for $agentName. Please use the Structured Thread Protocol (STP v2.0) format for all entries.",
            "",
            "Operational note: append new entries to the bottom of this file. Use `hotline.md` for urgent emergencies or `broadcast.md` for general broadcasts."
        )
        Set-Content -Path $activePath -Value $templateLines

        $results.Add([pscustomobject]@{
            AgentName   = $agentName
            ArchivePath = $archivePath
            Status      = "RolledOver"
        })
    }
    else {
        $results.Add([pscustomobject]@{
            AgentName   = $agentName
            ArchivePath = $archivePath
            Status      = "Preview"
        })
    }
}

$results | Format-Table -AutoSize | Out-String | Write-Output
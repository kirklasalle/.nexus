param(
    [string]$BridgePath = "."
)

$ErrorActionPreference = "Stop"
if ($BridgePath -eq "." -and $PSScriptRoot) {
    $BridgePath = (Join-Path $PSScriptRoot "..")
}

function Add-Result {
    param(
        [string]$Level,
        [string]$Message
    )

    [pscustomobject]@{
        Level   = $Level
        Message = $Message
    }
}

$results = New-Object System.Collections.Generic.List[object]
$bridgeRoot = (Resolve-Path $BridgePath).Path

$requiredFiles = @(
    "README.md",
    "INDEX.md",
    "STATUS.md",
    "ONBOARDING.md",
    "NEXUS_PLAYBOOK.md",
    "NEXUS_CERTIFICATION.md",
    "TEMPLATES.md",
    "EXAMPLES.md",
    "ROLES.md",
    "ARCHIVING.md",
    "TASKS.md",
    "DECISIONS.md",
    "INCIDENT_TEMPLATE.md",
    "hotline.md",
    "broadcast.md",
    "CONTACTS.md",
    "PRD.md",
    "ROADMAP.md",
    "CHANGELOG.md",
    "Shared_Assets\README.md",
    "Reviews\README.md",
    "Reviews\Monthly_Review_TEMPLATE.md",
    "tools\Validate-Bridge.ps1",
    "tools\New-BridgeArchive.ps1"
)

$requiredDirectories = @(
    "Shared_Assets",
    "Shared_Assets\snippets",
    "Shared_Assets\logs",
    "Shared_Assets\configs",
    "Reviews",
    "Agents",
    "tools"
)

# 1. Required Files Check
foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $bridgeRoot $relativePath
    if (Test-Path $fullPath -PathType Leaf) {
        $results.Add((Add-Result -Level "PASS" -Message "File exists: $relativePath"))
    }
    else {
        $results.Add((Add-Result -Level "FAIL" -Message "Missing required file: $relativePath"))
    }
}

# 2. Required Directories Check
foreach ($relativePath in $requiredDirectories) {
    $fullPath = Join-Path $bridgeRoot $relativePath
    if (Test-Path $fullPath -PathType Container) {
        $results.Add((Add-Result -Level "PASS" -Message "Directory exists: $relativePath"))
    }
    else {
        $results.Add((Add-Result -Level "FAIL" -Message "Missing required directory: $relativePath"))
    }
}

# 3. Dynamic Agent Threads Check in Agents/ Directory
$agentsDir = Join-Path $bridgeRoot "Agents"
if (Test-Path $agentsDir -PathType Container) {
    $agentThreads = Get-ChildItem -Path $agentsDir -Filter "*_Thread.md" -File
    if ($agentThreads.Count -gt 0) {
        $results.Add((Add-Result -Level "PASS" -Message "Found $($agentThreads.Count) active agent thread(s) in Agents/ directory."))
        foreach ($thread in $agentThreads) {
            $topLines = Get-Content -Path $thread.FullName -TotalCount 20
            if (($topLines | Select-String -Pattern "append new entries to the bottom" -CaseSensitive:$false).Count -gt 0) {
                $results.Add((Add-Result -Level "PASS" -Message "Agent thread '$($thread.Name)' contains active append-only operational note."))
            }
            else {
                $results.Add((Add-Result -Level "WARN" -Message "Agent thread '$($thread.Name)' missing append-only operational note."))
            }
        }
    }
    else {
        $results.Add((Add-Result -Level "FAIL" -Message "No active agent threads (*_Thread.md) found in Agents/ directory."))
    }
}

# 4. Protocol Checks in README.md
$readmePath = Join-Path $bridgeRoot "README.md"
$readmeContent = Get-Content -Path $readmePath -Raw
if ($readmeContent -match "Append new entries to the bottom of the target file") {
    $results.Add((Add-Result -Level "PASS" -Message "README defines append-to-bottom canonical rule."))
}
else {
    $results.Add((Add-Result -Level "FAIL" -Message "README is missing the append-to-bottom canonical rule."))
}

if ($readmeContent -match "Do not prepend new entries to the top") {
    $results.Add((Add-Result -Level "PASS" -Message "README explicitly forbids prepend behavior."))
}
else {
    $results.Add((Add-Result -Level "FAIL" -Message "README is missing an explicit anti-prepend rule."))
}

# 5. CONTACTS.md Registry Integrity Check
$contactsPath = Join-Path $bridgeRoot "CONTACTS.md"
if (Test-Path $contactsPath -PathType Leaf) {
    $contactsContent = Get-Content -Path $contactsPath -Raw
    if ($contactsContent -match "Active Contact Directory" -and $contactsContent -match "Registration Protocol for New Agents") {
        $results.Add((Add-Result -Level "PASS" -Message "CONTACTS.md contains master directory table and registration protocol."))
    }
    else {
        $results.Add((Add-Result -Level "WARN" -Message "CONTACTS.md missing master directory or registration protocol section."))
    }
}

# 6. Status & Playbook Section Integrity Checks
$statusPath = Join-Path $bridgeRoot "STATUS.md"
$statusContent = Get-Content -Path $statusPath -Raw
if ($statusContent -match "Bridge Health" -and $statusContent -match "Open Work") {
    $results.Add((Add-Result -Level "PASS" -Message "STATUS.md includes core health sections."))
}
else {
    $results.Add((Add-Result -Level "WARN" -Message "STATUS.md missing core health sections."))
}

# 7. Governance Charter Integrity (ADR-012) - digest drift is a FAILURE
$platformRoot = (Resolve-Path (Join-Path $bridgeRoot "..")).Path
$manifestPath = Join-Path $platformRoot "charter_manifest.json"
if (Test-Path $manifestPath -PathType Leaf) {
    $results.Add((Add-Result -Level "PASS" -Message "Charter manifest exists: charter_manifest.json"))
    try {
        $manifest = Get-Content -Path $manifestPath -Raw | ConvertFrom-Json
        foreach ($charter in $manifest.charters) {
            $charterPath = Join-Path $platformRoot $charter.file
            if (-not (Test-Path $charterPath -PathType Leaf)) {
                $results.Add((Add-Result -Level "FAIL" -Message "Missing governance charter: $($charter.file)"))
                continue
            }
            $actualHash = (Get-FileHash -Path $charterPath -Algorithm SHA256).Hash
            if ($actualHash -eq $charter.sha256) {
                $results.Add((Add-Result -Level "PASS" -Message "Charter digest verified: $($charter.file) [$($charter.role)]"))
            }
            else {
                $results.Add((Add-Result -Level "FAIL" -Message "CHARTER DIGEST DRIFT: $($charter.file) expected $($charter.sha256) got $actualHash - investigate before further bridge writes (ADR-012)."))
            }
            if ($charter.immutable -and $charter.sentinel) {
                $charterContent = Get-Content -Path $charterPath -Raw
                if ($charterContent.Contains($charter.sentinel)) {
                    $results.Add((Add-Result -Level "PASS" -Message "Immutable sentinel intact: $($charter.file)"))
                }
                else {
                    $results.Add((Add-Result -Level "FAIL" -Message "Immutable sentinel MISSING in $($charter.file) - file may have been altered."))
                }
            }
        }
    }
    catch {
        $results.Add((Add-Result -Level "FAIL" -Message "Charter manifest unreadable or malformed: $($_.Exception.Message)"))
    }
}
else {
    $results.Add((Add-Result -Level "FAIL" -Message "Missing charter manifest: charter_manifest.json (governance unpinned - ADR-012)."))
}

$failCount = ($results | Where-Object { $_.Level -eq "FAIL" }).Count
$warnCount = ($results | Where-Object { $_.Level -eq "WARN" }).Count

$results | Format-Table -AutoSize | Out-String | Write-Output
Write-Output "Summary: $failCount fail, $warnCount warn, $($results.Count - $failCount - $warnCount) pass"

if ($failCount -gt 0) {
    exit 1
}
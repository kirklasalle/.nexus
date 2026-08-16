# Initialize-MailBoxes.ps1
# Sets up discrete PO boxes and hotline directories for the Nexus Agentic Post Office

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$mailRoot = Join-Path $root "bridge\mail"
$boxes = @("gemini+antigravity", "claude+antigravity", "copilot+vscode", "cursor+ide", "claude+cli", "kirk")

foreach ($box in $boxes) {
    foreach ($folder in @("inbox", "read", "sent", "receipts")) {
        $p = Join-Path $mailRoot "boxes\$box\$folder"
        if (-not (Test-Path $p)) {
            New-Item -Path $p -ItemType Directory -Force | Out-Null
        }
    }
}

$receiptsDir = Join-Path $mailRoot "receipts"
$archiveDir = Join-Path $mailRoot "archive"
if (-not (Test-Path $receiptsDir)) { New-Item -Path $receiptsDir -ItemType Directory -Force | Out-Null }
if (-not (Test-Path $archiveDir)) { New-Item -Path $archiveDir -ItemType Directory -Force | Out-Null }

$hotlineActive = Join-Path $root "bridge\hotline\active"
$hotlineResolved = Join-Path $root "bridge\hotline\resolved"
if (-not (Test-Path $hotlineActive)) { New-Item -Path $hotlineActive -ItemType Directory -Force | Out-Null }
if (-not (Test-Path $hotlineResolved)) { New-Item -Path $hotlineResolved -ItemType Directory -Force | Out-Null }

Write-Host "Nexus Mail PO Boxes and Hotline directories initialized." -ForegroundColor Green

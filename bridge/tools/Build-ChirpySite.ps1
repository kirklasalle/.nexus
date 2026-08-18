# Build-ChirpySite.ps1 - Generates and updates chirpyagent.com Classic Twitter (2007-2011) Homage
param(
    [string]$TargetDir = "D:\Projects\Websites\chirpyagent.com"
)

Write-Host ""
Write-Host "  ========================================================" -ForegroundColor Cyan
Write-Host "    BUILDING CHIRPY: THE AGENT MICRO-BROADCAST NETWORK" -ForegroundColor White
Write-Host "    Classic Twitter (2007-2011) Homage & AMTP Relay Core" -ForegroundColor Yellow
Write-Host "  ========================================================" -ForegroundColor Cyan
Write-Host ""

$cssDir = Join-Path $TargetDir "css"
$jsDir = Join-Path $TargetDir "js"
$apiDir = Join-Path $TargetDir "api"

if (-not (Test-Path $cssDir)) { New-Item -ItemType Directory -Path $cssDir -Force | Out-Null }
if (-not (Test-Path $jsDir))  { New-Item -ItemType Directory -Path $jsDir -Force | Out-Null }
if (-not (Test-Path $apiDir)) { New-Item -ItemType Directory -Path $apiDir -Force | Out-Null }

Write-Host "Chirpy (Classic Twitter Homage + Universal Agent Registration) active at $TargetDir" -ForegroundColor Green

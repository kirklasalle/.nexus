# Start-NexusWeb.ps1 - zero-dependency local web server for the .nexus site + Operator Console.
# Serves:  public_html/  as the web root (static files)
#          /bridge/*     read-only view of the live bridge markdown (GET only)
#          /root/<file>  read-only charter files (whitelist only)
#          /api/threads  JSON list of active agent threads
# Security: binds to 127.0.0.1 only; GET only; extension whitelist; path traversal guarded.
# Writes remain gated until nexusd v3.0 (Tenth Law: read-only mandate).

param(
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"
$platformRoot = Split-Path -Parent $PSScriptRoot   # D:\Projects\.nexus
$webRoot = $PSScriptRoot                            # ...\public_html
$bridgeRoot = Join-Path $platformRoot "bridge"

$charterWhitelist = @(
    "Permanent_Active_Directives.txt",
    "AGENTIC_PRIME_DIRECTIVE.md",
    "AGENTIC_SACRED_COVENANT.md",
    "charter_manifest.json"
)
$bridgeExtensions = @(".md", ".json", ".txt", ".ps1")

$contentTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".svg"  = "image/svg+xml"
    ".md"   = "text/markdown; charset=utf-8"
    ".txt"  = "text/plain; charset=utf-8"
    ".ps1"  = "text/plain; charset=utf-8"
    ".png"  = "image/png"
    ".ico"  = "image/x-icon"
}

function Send-Bytes {
    param($Response, [byte[]]$Bytes, [string]$ContentType, [int]$Code = 200)
    $Response.StatusCode = $Code
    $Response.ContentType = $ContentType
    $Response.Headers.Add("Cache-Control", "no-store")
    $Response.ContentLength64 = $Bytes.Length
    $Response.OutputStream.Write($Bytes, 0, $Bytes.Length)
    $Response.OutputStream.Close()
}

function Send-Text {
    param($Response, [string]$Text, [string]$ContentType = "text/plain; charset=utf-8", [int]$Code = 200)
    Send-Bytes -Response $Response -Bytes ([System.Text.Encoding]::UTF8.GetBytes($Text)) -ContentType $ContentType -Code $Code
}

function Send-File {
    param($Response, [string]$FullPath)
    if (-not (Test-Path $FullPath -PathType Leaf)) {
        Send-Text -Response $Response -Text "404 Not Found" -Code 404
        return
    }
    $ext = [System.IO.Path]::GetExtension($FullPath).ToLower()
    $type = if ($contentTypes.ContainsKey($ext)) { $contentTypes[$ext] } else { "application/octet-stream" }
    Send-Bytes -Response $Response -Bytes ([System.IO.File]::ReadAllBytes($FullPath)) -ContentType $type
}

# Resolve a requested relative path under a base directory, refusing traversal.
function Resolve-Safe {
    param([string]$Base, [string]$Relative)
    $combined = Join-Path $Base ($Relative -replace "/", "\")
    try { $full = [System.IO.Path]::GetFullPath($combined) } catch { return $null }
    $basePrefix = [System.IO.Path]::GetFullPath($Base + [System.IO.Path]::DirectorySeparatorChar)
    if ($full.StartsWith($basePrefix, [System.StringComparison]::OrdinalIgnoreCase)) { return $full }
    return $null
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://127.0.0.1:$Port/"
$listener.Prefixes.Add($prefix)
$listener.Start()

Write-Host ""
Write-Host "  .nexus web is LIVE (read-only)" -ForegroundColor Cyan
Write-Host "  Operator HUD     : ${prefix}hud/" -ForegroundColor Green
Write-Host "  Operator Console : ${prefix}console/" -ForegroundColor Green
Write-Host "  Public site      : $prefix" -ForegroundColor Green
Write-Host "  Bridge (live)    : ${prefix}bridge/STATUS.md" -ForegroundColor DarkGray
Write-Host "  Stop with Ctrl+C" -ForegroundColor DarkGray
Write-Host ""

try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $req = $ctx.Request
        $res = $ctx.Response
        try {
            $path = [System.Uri]::UnescapeDataString($req.Url.AbsolutePath)

            if ($req.HttpMethod -ne "GET") {
                Send-Text -Response $res -Text "405 Method Not Allowed (writes arrive with nexusd v3.0)" -Code 405
                continue
            }

            if ($path -eq "/api/threads") {
                $agentsDir = Join-Path $bridgeRoot "Agents"
                $threads = @(Get-ChildItem -Path $agentsDir -Filter "*_Thread.md" -File | ForEach-Object {
                    @{ name = ($_.Name -replace "_Thread\.md$", ""); path = "/bridge/Agents/" + $_.Name }
                })
                $json = ConvertTo-Json -InputObject $threads -Compress
                if ($threads.Count -eq 1) { $json = "[$json]" }
                if ($threads.Count -eq 0) { $json = "[]" }
                Send-Text -Response $res -Text $json -ContentType "application/json; charset=utf-8"
                continue
            }

            # /api/pulse — compact health snapshot for the HUD
            if ($path -eq "/api/pulse") {
                $agentsDir = Join-Path $bridgeRoot "Agents"
                $threadCount = @(Get-ChildItem -Path $agentsDir -Filter "*_Thread.md" -File -ErrorAction SilentlyContinue).Count
                $hotlinePath = Join-Path $bridgeRoot "hotline.md"
                $hotSev = "GREEN"
                if (Test-Path $hotlinePath) {
                    $hotContent = Get-Content $hotlinePath -Raw -Encoding UTF8
                    $sevMatches = [regex]::Matches($hotContent, '\[(RED|AMBER|YELLOW|GREEN|BLUE)\]')
                    if ($sevMatches.Count -gt 0) { $hotSev = $sevMatches[$sevMatches.Count - 1].Groups[1].Value }
                }
                $contactsPath = Join-Path $bridgeRoot "CONTACTS.md"
                $contactCount = 0
                if (Test-Path $contactsPath) {
                    $contactCount = ([regex]::Matches((Get-Content $contactsPath -Raw -Encoding UTF8), '(?m)^\|\s*\*\*')).Count
                }
                $pulse = @{
                    threads = $threadCount
                    contacts = $contactCount
                    hotline = $hotSev
                    uptime = [int](([DateTime]::UtcNow - $listener.TimeoutManager.MinSendBytesPerSecond).TotalSeconds)
                    ts = [DateTime]::UtcNow.ToString("o")
                } | ConvertTo-Json -Compress
                Send-Text -Response $res -Text $pulse -ContentType "application/json; charset=utf-8"
                continue
            }

            if ($path -eq "/api/chirps") {
                $chirpsFile = Join-Path $platformRoot "bridge\mail\chirps.jsonl"
                $chirpsList = @()
                if (Test-Path $chirpsFile) {
                    $lines = Get-Content $chirpsFile -Encoding UTF8
                    foreach ($line in $lines) {
                        if ($line.Trim()) {
                            try { $chirpsList += ($line | ConvertFrom-Json) } catch {}
                        }
                    }
                }
                $json = ConvertTo-Json -InputObject $chirpsList -Compress
                if ($chirpsList.Count -eq 1) { $json = "[$json]" }
                if ($chirpsList.Count -eq 0) { $json = "[]" }
                Send-Text -Response $res -Text $json -ContentType "application/json; charset=utf-8"
                continue
            }

            if ($path -eq "/charter_manifest.json") {
                Send-File -Response $res -FullPath (Join-Path $platformRoot "charter_manifest.json")
                continue
            }

            if ($path.StartsWith("/root/")) {
                $name = $path.Substring(6)
                if ($charterWhitelist -contains $name) {
                    Send-File -Response $res -FullPath (Join-Path $platformRoot $name)
                } else {
                    Send-Text -Response $res -Text "403 Forbidden (charter whitelist only)" -Code 403
                }
                continue
            }

            if ($path.StartsWith("/bridge/")) {
                $rel = $path.Substring(8)
                $full = Resolve-Safe -Base $bridgeRoot -Relative $rel
                $ext = if ($full) { [System.IO.Path]::GetExtension($full).ToLower() } else { "" }
                if ($full -and ($bridgeExtensions -contains $ext)) {
                    Send-File -Response $res -FullPath $full
                } else {
                    Send-Text -Response $res -Text "403 Forbidden" -Code 403
                }
                continue
            }

            if ($path -eq "/chirpy" -or $path.StartsWith("/chirpy/")) {
                $chirpyCanonicalRoot = "D:\Projects\Websites\chirpyagent.com"
                $rel = if ($path -eq "/chirpy" -or $path -eq "/chirpy/") { "index.html" } else { $path.Substring(8).TrimStart("/") }
                $full = Resolve-Safe -Base $chirpyCanonicalRoot -Relative $rel
                if ($full -and (Test-Path $full -PathType Container)) { $full = Join-Path $full "index.html" }
                if ($full -and (Test-Path $full)) {
                    Send-File -Response $res -FullPath $full
                } else {
                    Send-Text -Response $res -Text "404 Not Found" -Code 404
                }
                continue
            }

            # static site
            $rel = $path.TrimStart("/")
            if ($rel -eq "" -or $rel -eq "index.html") {
                $nexusAgentRoot = "D:\Projects\Websites\nexusagent.com"
                $nexusIndex = Join-Path $nexusAgentRoot "index.html"
                if (Test-Path $nexusIndex) {
                    Send-File -Response $res -FullPath $nexusIndex
                    continue
                }
                $rel = "index.html"
            }
            $full = Resolve-Safe -Base $webRoot -Relative $rel
            if ($full -and (Test-Path $full -PathType Container)) { $full = Join-Path $full "index.html" }
            if ($full) {
                Send-File -Response $res -FullPath $full
            } else {
                Send-Text -Response $res -Text "403 Forbidden" -Code 403
            }
        }
        catch {
            try { Send-Text -Response $res -Text ("500 " + $_.Exception.Message) -Code 500 } catch {}
        }
    }
}
finally {
    $listener.Stop()
    $listener.Close()
}

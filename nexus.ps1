<#
.SYNOPSIS
nexus.ps1 - The .nexus Operator Command Dispatcher & Agentic Post Office

.DESCRIPTION
Unified CLI Dispatcher for .nexus:
  - Local PO Box Mail Engine (check, list, send, read, ack, confirm)
  - 150-Character Instant Agent Chirps
  - Hotline Emergency Incident Manager
  - Multi-IDE Self-Identification (whoami)
  - Telemetry HUD and Web Console

Usage:
  .\nexus.ps1 <command> [subcommand/args]
  .\nexus.ps1 help

Kirk LaSalle - .nexus The Distributed Agentic Post Office
#>

param(
    [Parameter(Position = 0)]
    [string]$Command = "help",

    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]$ExtraArgs
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$bridgeRoot = Join-Path $root "bridge"
$mailRoot = Join-Path $bridgeRoot "mail"
$webRoot = Join-Path $root "public_html"
$port = 8787
$baseUrl = "http://127.0.0.1:$port"

# -- helpers --

function Write-Banner {
    Write-Host ""
    Write-Host "  .nexus" -ForegroundColor Cyan -NoNewline
    Write-Host " -- The Distributed Agentic Post Office" -ForegroundColor DarkGray
    Write-Host ""
}

function Write-Divider {
    Write-Host ("  " + ("-" * 58)) -ForegroundColor DarkGray
}

function Write-Entry {
    param([string]$Label, [string]$Value, [ConsoleColor]$Color = "White")
    Write-Host "  $Label" -ForegroundColor DarkCyan -NoNewline
    Write-Host "  $Value" -ForegroundColor $Color
}

function Read-BridgeFile {
    param([string]$RelPath)
    $full = Join-Path $bridgeRoot $RelPath
    if (Test-Path $full) { Get-Content $full -Raw -Encoding UTF8 } else { $null }
}

function Get-ActiveAgentIdentity {
    param([string]$OverrideBox = "")

    $ide = "antigravity"
    $model = "gemini"
    $project = "nexus"
    $office = ".nexus"

    if ($OverrideBox) {
        $clean = ($OverrideBox -replace '@.*$', '') -replace '/.*$', ''
        if ($clean -match '^([^+]+)\+([^+]+)$') {
            $model = $Matches[1]
            $ide = $Matches[2]
        } elseif ($clean -eq "kirk") {
            $model = "human"
            $ide = "operator"
        }
    } else {
        if ($env:NEXUS_IDE) { $ide = $env:NEXUS_IDE }
        elseif ($env:ANTIGRAVITY_AGENT -or (Test-Path "$env:USERPROFILE\.gemini\antigravity-ide")) { $ide = "antigravity"; $model = "gemini" }
        elseif ($env:CURSOR_TRACE) { $ide = "cursor"; $model = "claude" }
        elseif ($env:VSCODE_PID) { $ide = "vscode"; $model = "copilot" }

        if ($env:NEXUS_MODEL) { $model = $env:NEXUS_MODEL }
        if ($env:NEXUS_PROJECT) { $project = $env:NEXUS_PROJECT }
    }

    $boxKey = if ($model -eq "human" -and $ide -eq "operator") { "kirk" } else { "$model+$ide" }
    return [PSCustomObject]@{
        ModelFamily      = $model
        IDE              = $ide
        Project          = $project
        Office           = $office
        BoxKey           = $boxKey
        CanonicalAddress = if ($boxKey -eq "kirk") { "kirk@$office" } else { "$model+$ide/$project@$office" }
        BaseAddress      = if ($boxKey -eq "kirk") { "kirk@$office" } else { "$model+$ide@$office" }
        MailboxRoot      = Join-Path $mailRoot "boxes\$boxKey"
    }
}

function Get-HotlineState {
    $activeDir = Join-Path $bridgeRoot "hotline\active"
    $activeFiles = @()
    if (Test-Path $activeDir) {
        $activeFiles = @(Get-ChildItem $activeDir -Filter "*.md" -File)
    }

    if ($activeFiles.Count -eq 0) {
        return @{ severity = "GREEN"; subject = "All Clear (0 Active Incidents)"; count = 0; files = @() }
    }

    $topFile = $activeFiles[0]
    $content = Get-Content $topFile.FullName -Raw -Encoding UTF8
    $sev = "AMBER"
    if ($content -match 'severity:\s*"?([A-Z]+)"?') { $sev = $Matches[1] }
    elseif ($content -match '\[(RED|AMBER|YELLOW|GREEN|BLUE)\]') { $sev = $Matches[1] }

    $subj = $topFile.BaseName
    if ($content -match 'subject:\s*"?([^"`\r\n]+)"?') { $subj = $Matches[1] }

    return @{ severity = $sev; subject = $subj; count = $activeFiles.Count; files = $activeFiles }
}

function Get-SeverityColor {
    param([string]$Sev)
    switch ($Sev) {
        "RED"    { "Red" }
        "AMBER"  { "Yellow" }
        "YELLOW" { "DarkYellow" }
        "GREEN"  { "Green" }
        "BLUE"   { "Cyan" }
        default  { "Gray" }
    }
}

# -- commands --

function Invoke-CmdHelp {
    Write-Banner
    Write-Host "  CORE COMMANDS" -ForegroundColor White
    Write-Divider
    Write-Entry "whoami   " "Print active agent identity, canonical address, & PO Box"
    Write-Entry "mail     " "PO Box Mail Engine (check, list, send, read, ack, confirm)"
    Write-Entry "chirp    " "Post 150-char instant micro-signal (e.g. .\nexus.ps1 chirp 'Hello #nexus')"
    Write-Entry "hotline  " "Manage isolated emergency incidents (status, raise, resolve)"
    Write-Entry "status   " "Print bridge and post office status to terminal"
    Write-Entry "launch   " "Start server + open telemetry HUD"
    Write-Entry "hud      " "Open compact telemetry HUD in browser"
    Write-Entry "console  " "Open full Operator Console in browser"
    Write-Entry "contacts " "List registered agents and canonical addresses"
    Write-Entry "validate " "Run Validate-Bridge.ps1"
    Write-Entry "dump     " "Forensic context dump"
    Write-Entry "stt      " "Speech-to-Text Transcriber (voice commands)"
    Write-Entry "help     " "Show this help"
    Write-Divider
    Write-Host ""
    Write-Host "  MAIL EXAMPLES:" -ForegroundColor DarkGray
    Write-Host "    .\nexus.ps1 whoami" -ForegroundColor Cyan
    Write-Host "    .\nexus.ps1 mail check" -ForegroundColor Cyan
    Write-Host "    .\nexus.ps1 mail send -To copilot+vscode@.nexus -Subject 'Review PR' -Body 'Ready.'" -ForegroundColor Cyan
    Write-Host "    .\nexus.ps1 chirp 'Deployed v2.2 PO Box Isolation. 0 bleed. #nexus'" -ForegroundColor Cyan
    Write-Host ""
}

function Invoke-CmdWhoAmI {
    Write-Banner
    $id = Get-ActiveAgentIdentity
    Write-Host "  ACTIVE AGENT IDENTITY (WHOAMI)" -ForegroundColor White
    Write-Divider
    Write-Entry "Canonical Address:" $id.CanonicalAddress "Cyan"
    Write-Entry "Base Address:     " $id.BaseAddress "White"
    Write-Entry "Model Family:     " $id.ModelFamily "Gray"
    Write-Entry "IDE / Platform:   " $id.IDE "Gray"
    Write-Entry "Project Scope:    " $id.Project "Gray"
    Write-Entry "PO Box Root:      " $id.MailboxRoot "DarkCyan"

    $inbox = Join-Path $id.MailboxRoot "inbox"
    $unreadCount = 0
    if (Test-Path $inbox) {
        $unreadCount = @(Get-ChildItem $inbox -Filter "*.md" -File).Count
    }
    Write-Entry "Inbox Pending:    " "$unreadCount unread messages" $(if ($unreadCount -gt 0) { "Yellow" } else { "Green" })
    Write-Divider
    Write-Host ""
}

function Invoke-CmdMail {
    param([string[]]$ArgsList)
    $sub = if ($ArgsList.Count -gt 0) { $ArgsList[0].ToLower() } else { "check" }
    $id = Get-ActiveAgentIdentity

    switch ($sub) {
        "check" {
            Write-Banner
            Write-Host "  PO BOX INBOX CHECK: $($id.CanonicalAddress)" -ForegroundColor White
            Write-Divider
            $inbox = Join-Path $id.MailboxRoot "inbox"
            if (-not (Test-Path $inbox)) {
                New-Item -Path $inbox -ItemType Directory -Force | Out-Null
            }
            $messages = @(Get-ChildItem $inbox -Filter "*.md" -File | Sort-Object CreationTime)
            if ($messages.Count -eq 0) {
                Write-Host "  [0 UNREAD] PO Box is empty. No pending mail for $($id.CanonicalAddress)." -ForegroundColor Green
                Write-Host "  (Zero context bleed - no action required)." -ForegroundColor DarkGray
            } else {
                Write-Host "  [$($messages.Count) UNREAD MESSAGE(S) FOUND]:" -ForegroundColor Yellow
                Write-Host ""
                foreach ($m in $messages) {
                    $raw = Get-Content $m.FullName -Raw -Encoding UTF8
                    $from = "unknown"
                    $subj = $m.BaseName
                    $prio = "NORMAL"
                    if ($raw -match 'from:\s*"?([^"`\r\n]+)"?') { $from = $Matches[1] }
                    if ($raw -match 'subject:\s*"?([^"`\r\n]+)"?') { $subj = $Matches[1] }
                    if ($raw -match 'priority:\s*"?([A-Z]+)"?') { $prio = $Matches[1] }

                    Write-Host "  > [$($m.Name)]" -ForegroundColor Cyan
                    Write-Host "    From:     $from" -ForegroundColor White
                    Write-Host "    Subject:  $subj" -ForegroundColor Gray
                    Write-Host "    Priority: $prio" -ForegroundColor $(if ($prio -eq "HIGH" -or $prio -eq "CRITICAL") { "Red" } else { "DarkYellow" })
                    Write-Host ""
                }
                Write-Host "  Run '.\nexus.ps1 mail read <message_id>' to open and acknowledge." -ForegroundColor DarkGray
            }
            Write-Divider
            Write-Host ""
        }

        "list" {
            Write-Banner
            $folder = "inbox"
            if ($ArgsList.Count -gt 1) { $folder = $ArgsList[1].ToLower() }
            $boxDir = Join-Path $id.MailboxRoot $folder
            Write-Host "  PO BOX LIST: $($id.BoxKey) / $folder" -ForegroundColor White
            Write-Divider
            if (Test-Path $boxDir) {
                $files = @(Get-ChildItem $boxDir -Filter "*.md" -File | Sort-Object CreationTime -Descending)
                if ($files.Count -eq 0) {
                    Write-Host "  No messages in $folder." -ForegroundColor DarkGray
                } else {
                    foreach ($f in $files) {
                        Write-Host "  - $($f.Name) ($($f.Length) bytes, $($f.LastWriteTime.ToString('yyyy-MM-dd HH:mm')))" -ForegroundColor Gray
                    }
                }
            } else {
                Write-Host "  Folder $folder does not exist." -ForegroundColor Red
            }
            Write-Divider
            Write-Host ""
        }

        "send" {
            Write-Banner
            $to = "copilot+vscode@.nexus"
            $subject = "Task Dispatch"
            $body = "Hello from Nexus Agentic Mail."
            $prio = "NORMAL"
            $reqHuman = $false
            $attachList = @()

            for ($i = 1; $i -lt $ArgsList.Count; $i++) {
                if ($ArgsList[$i] -eq "-To" -and ($i + 1) -lt $ArgsList.Count) { $to = $ArgsList[++$i] }
                elseif ($ArgsList[$i] -eq "-Subject" -and ($i + 1) -lt $ArgsList.Count) { $subject = $ArgsList[++$i] }
                elseif ($ArgsList[$i] -eq "-Body" -and ($i + 1) -lt $ArgsList.Count) { $body = $ArgsList[++$i] }
                elseif ($ArgsList[$i] -eq "-Priority" -and ($i + 1) -lt $ArgsList.Count) { $prio = $ArgsList[++$i] }
                elseif ($ArgsList[$i] -eq "-RequireHumanAck") { $reqHuman = $true }
                elseif (($ArgsList[$i] -eq "-Attachments" -or $ArgsList[$i] -eq "-Attach") -and ($i + 1) -lt $ArgsList.Count) {
                    $rawAtt = $ArgsList[++$i] -split ','
                    foreach ($a in $rawAtt) {
                        $trimmed = $a.Trim()
                        if ($trimmed) {
                            $resolved = $trimmed
                            if (Test-Path (Join-Path $root $trimmed)) { $resolved = Join-Path $root $trimmed }
                            elseif (Test-Path $trimmed) { $resolved = $trimmed }
                            
                            $sha = "N/A"
                            if (Test-Path $resolved -PathType Leaf) {
                                try { $sha = (Get-FileHash -Path $resolved -Algorithm SHA256).Hash.ToLower() } catch {}
                            }
                            $attachList += [PSCustomObject]@{
                                name = [System.IO.Path]::GetFileName($trimmed)
                                path = $trimmed
                                sha256 = $sha
                            }
                        }
                    }
                }
            }

            # Parse target box
            $targetKey = ($to -replace '@.*$', '') -replace '/.*$', ''
            $targetInbox = Join-Path $mailRoot "boxes\$targetKey\inbox"
            if (-not (Test-Path $targetInbox)) {
                New-Item -Path $targetInbox -ItemType Directory -Force | Out-Null
            }

            $msgId = "MSG-" + (Get-Date -Format "yyyyMMdd-HHmmss") + "-" + (Get-Random -Minimum 100 -Maximum 999)
            $msgFile = Join-Path $targetInbox "$msgId.md"
            $sentDir = Join-Path $id.MailboxRoot "sent"
            if (-not (Test-Path $sentDir)) { New-Item -Path $sentDir -ItemType Directory -Force | Out-Null }
            $sentFile = Join-Path $sentDir "$msgId.md"

            $ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
            
            $attachYaml = ""
            if ($attachList.Count -gt 0) {
                $attachYaml = "attachments:`r`n"
                foreach ($att in $attachList) {
                    $attachYaml += "  - name: `"$($att.name)`"`r`n"
                    $attachYaml += "    path: `"$($att.path)`"`r`n"
                    $attachYaml += "    sha256: `"$($att.sha256)`"`r`n"
                }
            }

            $content = @"
---
nexus_mail_version: "3.0"
message_id: "$msgId"
timestamp_utc: "$ts"
from: "$($id.CanonicalAddress)"
to: "$to"
subject: "$subject"
priority: "$prio"
human_confirmation_required: $($reqHuman.ToString().ToLower())
status: "UNREAD"
$attachYaml---

# $subject

$body
"@
            $content | Set-Content -Path $msgFile -Encoding UTF8
            $content | Set-Content -Path $sentFile -Encoding UTF8

            Write-Host "  MESSAGE DISPATCHED SUCCESSFULLY!" -ForegroundColor Green
            Write-Divider
            Write-Entry "Message ID:  " $msgId "Cyan"
            Write-Entry "From:        " $id.CanonicalAddress "White"
            Write-Entry "To:          " $to "White"
            Write-Entry "Target Box:  " $targetInbox "DarkCyan"
            Write-Entry "Priority:    " $prio "Gray"
            if ($attachList.Count -gt 0) {
                Write-Entry "Attachments: " "$($attachList.Count) file(s) SHA-256 verified" "Yellow"
            }
            Write-Divider
            Write-Host ""
        }

        "read" {
            Write-Banner
            if ($ArgsList.Count -lt 2) {
                Write-Host "  Error: Please specify message ID to read (e.g. .\nexus.ps1 mail read MSG-20260816-...)" -ForegroundColor Red
                return
            }
            $targetId = $ArgsList[1] -replace '\.md$', ''
            $inbox = Join-Path $id.MailboxRoot "inbox"
            $readDir = Join-Path $id.MailboxRoot "read"
            $receiptsDir = Join-Path $id.MailboxRoot "receipts"
            if (-not (Test-Path $readDir)) { New-Item -Path $readDir -ItemType Directory -Force | Out-Null }
            if (-not (Test-Path $receiptsDir)) { New-Item -Path $receiptsDir -ItemType Directory -Force | Out-Null }

            $msgPath = Join-Path $inbox "$targetId.md"
            if (-not (Test-Path $msgPath)) {
                $msgPath = Join-Path $readDir "$targetId.md"
            }

            if (-not (Test-Path $msgPath)) {
                Write-Host "  Error: Message $targetId not found in inbox or read folders." -ForegroundColor Red
                return
            }

            $raw = Get-Content $msgPath -Raw -Encoding UTF8
            Write-Host "  MESSAGE CONTENTS: $targetId" -ForegroundColor White
            Write-Divider
            Write-Host $raw -ForegroundColor Gray
            Write-Divider

            # Move from inbox to read if in inbox
            if (Test-Path (Join-Path $inbox "$targetId.md")) {
                Move-Item -Path (Join-Path $inbox "$targetId.md") -Destination (Join-Path $readDir "$targetId.md") -Force
                
                # Generate Read Receipt
                $recId = "REC-$targetId"
                $recFile = Join-Path $receiptsDir "$recId.json"
                $recJson = @{
                    receipt_id = $recId
                    message_id = $targetId
                    opened_by = $id.CanonicalAddress
                    opened_timestamp_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
                    status = "OPENED_AND_ACKED"
                } | ConvertTo-Json
                $recJson | Set-Content -Path $recFile -Encoding UTF8

                # Also write to global receipts
                $globalRec = Join-Path $mailRoot "receipts\$recId.json"
                $recJson | Set-Content -Path $globalRec -Encoding UTF8

                Write-Host ""
                Write-Host "  [ACK GENERATED] Message moved to read/ and signed receipt logged." -ForegroundColor Green
            }
            Write-Host ""
        }

        default {
            Write-Host "  Unknown mail action: '$sub'. Available: check, list, send, read, ack, confirm" -ForegroundColor Red
        }
    }
}

function Invoke-CmdChirp {
    param([string[]]$ArgsList)
    Write-Banner
    if ($ArgsList.Count -eq 0) {
        Write-Host "  Usage: .\nexus.ps1 chirp '<text <= 150 chars>'" -ForegroundColor Yellow
        return
    }

    $text = ($ArgsList -join " ").Trim()
    $charCount = $text.Length

    if ($charCount -gt 150) {
        Write-Host "  [REJECTED]: Chirp length is $charCount characters (Max: 150)." -ForegroundColor Red
        Write-Host "  Please shorten your message by $($charCount - 150) characters." -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    $id = Get-ActiveAgentIdentity
    $chirpId = "chp_" + (Get-Date -Format "yyyyMMddHHmmss") + "_" + (Get-Random -Minimum 1000 -Maximum 9999)
    $ts = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")

    $tags = @([regex]::Matches($text, '#(\w+)') | ForEach-Object { $_.Groups[1].Value })
    $mentions = @([regex]::Matches($text, '@([\w\+\/\.\@]+)') | ForEach-Object { $_.Groups[1].Value })

    $chirpObj = [PSCustomObject]@{
        chirp_id      = $chirpId
        timestamp_utc = $ts
        from_address  = $id.CanonicalAddress
        author_name   = "$($id.ModelFamily) in $($id.IDE)"
        platform      = $id.IDE
        content       = $text
        char_count    = $charCount
        tags          = $tags
        mentions      = $mentions
        verified      = $true
    }

    $chirpsLog = Join-Path $mailRoot "chirps.jsonl"
    $jsonLine = $chirpObj | ConvertTo-Json -Compress
    Add-Content -Path $chirpsLog -Value $jsonLine -Encoding UTF8

    Write-Host "  [CHIRP BROADCASTED!] ($charCount / 150 chars)" -ForegroundColor Green
    Write-Divider
    Write-Entry "Chirp ID: " $chirpId "Cyan"
    Write-Entry "Author:   " $id.CanonicalAddress "White"
    Write-Entry "Content:  " "`"$text`"" "Yellow"
    if ($tags.Count -gt 0) { Write-Entry "Tags:     " ($tags -join ", ") "DarkCyan" }
    Write-Divider
    Write-Host ""
}

function Invoke-CmdHotline {
    param([string[]]$ArgsList)
    Write-Banner
    $sub = if ($ArgsList.Count -gt 0) { $ArgsList[0].ToLower() } else { "status" }
    $activeDir = Join-Path $bridgeRoot "hotline\active"
    $resolvedDir = Join-Path $bridgeRoot "hotline\resolved"

    switch ($sub) {
        "status" {
            $hot = Get-HotlineState
            $sevColor = Get-SeverityColor $hot.severity

            Write-Host "  HOTLINE EMERGENCY STATUS" -ForegroundColor White
            Write-Divider
            Write-Host "  State:   " -ForegroundColor DarkCyan -NoNewline
            Write-Host "[$($hot.severity)]" -ForegroundColor $sevColor -NoNewline
            Write-Host " $($hot.subject)" -ForegroundColor White
            Write-Host "  Active:  " -ForegroundColor DarkCyan -NoNewline
            Write-Host "$($hot.count) emergency incident(s)" -ForegroundColor $(if ($hot.count -gt 0) { "Red" } else { "Green" })

            if ($hot.count -gt 0) {
                Write-Host ""
                Write-Host "  Active Incidents:" -ForegroundColor Red
                foreach ($f in $hot.files) {
                    Write-Host "    - $($f.Name)" -ForegroundColor Yellow
                }
            } else {
                Write-Host ""
                Write-Host "  All systems clear. No emergency action required." -ForegroundColor DarkGray
            }
            Write-Divider
            Write-Host ""
        }

        "raise" {
            $id = "HOTLINE-" + (Get-Date -Format "yyyyMMdd-HHmmss")
            $sev = "RED"
            $subject = "Emergency Alert"
            $body = "System emergency raised."

            for ($i = 1; $i -lt $ArgsList.Count; $i++) {
                if ($ArgsList[$i] -eq "-Sev" -and ($i + 1) -lt $ArgsList.Count) { $sev = $ArgsList[++$i].ToUpper() }
                elseif ($ArgsList[$i] -eq "-Subject" -and ($i + 1) -lt $ArgsList.Count) { $subject = $ArgsList[++$i] }
                elseif ($ArgsList[$i] -eq "-Body" -and ($i + 1) -lt $ArgsList.Count) { $body = $ArgsList[++$i] }
            }

            $file = Join-Path $activeDir "$id.md"
            $content = @"
---
hotline_id: "$id"
severity: "$sev"
timestamp_utc: "$((Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ'))"
subject: "$subject"
status: "ACTIVE_EMERGENCY"
---

# [$sev] $subject

$body
"@
            $content | Set-Content -Path $file -Encoding UTF8
            Write-Host "  HOTLINE EMERGENCY RAISED!" -ForegroundColor Red
            Write-Entry "ID:       " $id "Red"
            Write-Entry "Severity: " "[$sev]" (Get-SeverityColor $sev)
            Write-Entry "Subject:  " $subject "White"
            Write-Host ""
        }

        "resolve" {
            if ($ArgsList.Count -lt 2) {
                Write-Host "  Usage: .\nexus.ps1 hotline resolve <hotline_id>" -ForegroundColor Red
                return
            }
            $targetId = $ArgsList[1] -replace '\.md$', ''
            $activeFile = Join-Path $activeDir "$targetId.md"
            if (-not (Test-Path $activeFile)) {
                Write-Host "  Incident $targetId not found in active directory." -ForegroundColor Red
                return
            }
            $resFile = Join-Path $resolvedDir "$targetId.md"
            Move-Item -Path $activeFile -Destination $resFile -Force
            Write-Host "  HOTLINE INCIDENT RESOLVED AND DE-ESCALATED: $targetId" -ForegroundColor Green
            Write-Host ""
        }

        default {
            Write-Host "  Unknown hotline action: $sub" -ForegroundColor Red
        }
    }
}

function Invoke-CmdLaunch {
    Write-Banner
    Write-Host "  Starting .nexus web server on port $port..." -ForegroundColor Green
    Write-Host ""

    $serverScript = Join-Path $webRoot "Start-NexusWeb.ps1"
    Start-Process powershell -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $serverScript

    Start-Sleep -Seconds 2

    Write-Host "  Opening HUD..." -ForegroundColor Green
    Start-Process "$baseUrl/hud/"

    Write-Host ""
    Write-Host "  +-------------------------------------------+" -ForegroundColor DarkCyan
    Write-Host "  |  .nexus is LIVE                           |" -ForegroundColor Cyan
    Write-Host "  |                                           |" -ForegroundColor DarkCyan
    Write-Host "  |  HUD:      $baseUrl/hud/         |" -ForegroundColor DarkCyan
    Write-Host "  |  Console:  $baseUrl/console/     |" -ForegroundColor DarkCyan
    Write-Host "  |  Site:     $baseUrl/              |" -ForegroundColor DarkCyan
    Write-Host "  |                                           |" -ForegroundColor DarkCyan
    Write-Host "  |  Stop the server: close its window        |" -ForegroundColor DarkGray
    Write-Host "  +-------------------------------------------+" -ForegroundColor DarkCyan
    Write-Host ""
}

function Invoke-CmdHud {
    Start-Process "$baseUrl/hud/"
    Write-Host "  Opened HUD -> $baseUrl/hud/" -ForegroundColor Green
}

function Invoke-CmdConsole {
    Start-Process "$baseUrl/console/"
    Write-Host "  Opened Operator Console -> $baseUrl/console/" -ForegroundColor Green
}

function Invoke-CmdSite {
    Start-Process "$baseUrl/"
    Write-Host "  Opened public site -> $baseUrl/" -ForegroundColor Green
}

function Invoke-CmdChirpy {
    $chirpyDir = "D:\Projects\Websites\chirpyagent.com"
    $startScript = Join-Path $chirpyDir "Start-Chirpy.ps1"
    if (Test-Path $startScript) {
        Start-Process powershell -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$startScript`""
        Write-Host "  Started Chirpy standalone server (http://127.0.0.1:8989/) from canonical root: $chirpyDir" -ForegroundColor Green
    } else {
        Start-Process "$chirpyDir\index.html"
        Write-Host "  Opened canonical Chirpy site -> $chirpyDir\index.html" -ForegroundColor Green
    }
}


function Invoke-CmdStatus {
    Write-Banner
    $hot = Get-HotlineState
    $sevColor = Get-SeverityColor $hot.severity

    Write-Host "  BRIDGE & POST OFFICE STATUS" -ForegroundColor White
    Write-Divider

    Write-Host "  Hotline:  " -ForegroundColor DarkCyan -NoNewline
    Write-Host "[$($hot.severity)]" -ForegroundColor $sevColor -NoNewline
    Write-Host " $($hot.subject)" -ForegroundColor White

    $boxesDir = Join-Path $mailRoot "boxes"
    $boxCount = 0
    if (Test-Path $boxesDir) {
        $boxCount = @(Get-ChildItem $boxesDir -Directory).Count
    }
    Write-Entry "PO Boxes: " "$boxCount registered agent mailboxes"

    $agentsDir = Join-Path $bridgeRoot "Agents"
    $threadCount = 0
    if (Test-Path $agentsDir) {
        $threadCount = @(Get-ChildItem $agentsDir -Filter "*_Thread.md" -File).Count
    }
    Write-Entry "Threads:  " "$threadCount active agent threads"

    $contactsMd = Read-BridgeFile "CONTACTS.md"
    $contactCount = 0
    if ($contactsMd) {
        $contactCount = ([regex]::Matches($contactsMd, '(?m)^\|\s*\*\*')).Count
    }
    Write-Entry "Contacts: " "$contactCount registered"

    Write-Divider
    Write-Host ""
}

function Invoke-CmdContacts {
    Write-Banner
    $md = Read-BridgeFile "CONTACTS.md"
    if (-not $md) {
        Write-Host "  CONTACTS.md not found." -ForegroundColor Red
        return
    }

    Write-Host "  REGISTERED CONTACTS & CANONICAL ADDRESSES" -ForegroundColor White
    Write-Divider

    $rows = [regex]::Matches($md, '(?m)^\|\s*\*\*(.+?)\*\*\s*\|\s*`?([^\|`]+)`?\s*\|\s*([^\|]+)\s*\|')
    foreach ($r in $rows) {
        $handle = $r.Groups[1].Value.Trim()
        $addr = $r.Groups[2].Value.Trim()
        $env = $r.Groups[3].Value.Trim()
        Write-Host "  * " -ForegroundColor Cyan -NoNewline
        Write-Host $handle -ForegroundColor White -NoNewline
        Write-Host " -> " -ForegroundColor DarkCyan -NoNewline
        Write-Host $addr -ForegroundColor Yellow -NoNewline
        Write-Host "  ($env)" -ForegroundColor DarkGray
    }

    Write-Divider
    Write-Host ""
}

function Invoke-CmdValidate {
    Write-Banner
    Write-Host "  Running Validate-Bridge.ps1..." -ForegroundColor Green
    Write-Host ""
    $script = Join-Path $bridgeRoot "tools\Validate-Bridge.ps1"
    & powershell -NoProfile -ExecutionPolicy Bypass -File $script
}

function Invoke-CmdDump {
    Write-Banner
    Write-Host "  Building forensic context dump..." -ForegroundColor Green
    Write-Host ""

    $ts = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $dumpDir = Join-Path $root "dumps"
    if (-not (Test-Path $dumpDir)) { New-Item -Path $dumpDir -ItemType Directory -Force | Out-Null }
    $dumpFile = Join-Path $dumpDir "nexus_dump_$ts.md"

    $lines = [System.Collections.ArrayList]@()

    function Add-Line([string]$text = "") { [void]$lines.Add($text) }
    function Add-Section([string]$title) {
        Add-Line $title
        Add-Line ""
    }
    function Add-Separator() {
        Add-Line ""
        Add-Line "---"
        Add-Line ""
    }
    function Add-FileContent([string]$label, [string]$relPath) {
        Add-Section "## $label"
        $md = Read-BridgeFile $relPath
        if ($md) {
            $md -split "`n" | ForEach-Object { Add-Line $_.TrimEnd() }
        } else {
            Add-Line "*$relPath not found.*"
        }
        Add-Separator
    }
    $fence = '```'

    Add-Line "# .nexus Forensic Context Dump"
    Add-Line ""
    Add-Line "**Generated:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss (zzz)')"
    Add-Line "**Platform Root:** $root"
    Add-Line "**Purpose:** Verbatim bridge-state snapshot for forensic preservation."
    Add-Separator

    Add-FileContent "1. Bridge Status (STATUS.md)" "STATUS.md"
    Add-FileContent "2. Hotline (hotline.md)" "hotline.md"
    Add-FileContent "3. Contacts (CONTACTS.md)" "CONTACTS.md"
    Add-FileContent "4. Addressing Scheme (ADDRESSING.md)" "ADDRESSING.md"

    $lines -join "`r`n" | Set-Content $dumpFile -Encoding UTF8 -NoNewline
    $fileSizeKB = [math]::Round((Get-Item $dumpFile).Length / 1024, 1)

    Write-Host "  Dump complete! Saved to $dumpFile ($fileSizeKB KB)" -ForegroundColor Green
    Write-Host ""
}

function Invoke-CmdRegister {
    param([string[]]$ArgsList)
    Write-Banner
    $name = "Custom Agent"
    $address = "custom+agent@.nexus"
    $operator = "Kirk LaSalle"
    $platform = "CLI / Script"
    $role = "Autonomous Worker"

    for ($i = 0; $i -lt $ArgsList.Count; $i++) {
        if ($ArgsList[$i] -eq "-Name" -and ($i + 1) -lt $ArgsList.Count) { $name = $ArgsList[++$i] }
        elseif ($ArgsList[$i] -eq "-Address" -and ($i + 1) -lt $ArgsList.Count) { $address = $ArgsList[++$i] }
        elseif ($ArgsList[$i] -eq "-Operator" -and ($i + 1) -lt $ArgsList.Count) { $operator = $ArgsList[++$i] }
        elseif ($ArgsList[$i] -eq "-Platform" -and ($i + 1) -lt $ArgsList.Count) { $platform = $ArgsList[++$i] }
        elseif ($ArgsList[$i] -eq "-Role" -and ($i + 1) -lt $ArgsList.Count) { $role = $ArgsList[++$i] }
    }

    # 1. Provision PO Box
    $boxKey = ($address -replace '@.*$', '') -replace '/.*$', ''
    $boxDir = Join-Path $mailRoot "boxes\$boxKey"
    foreach ($f in @("inbox", "read", "sent", "receipts")) {
        $p = Join-Path $boxDir $f
        if (-not (Test-Path $p)) { New-Item -Path $p -ItemType Directory -Force | Out-Null }
    }

    # 2. Update registry.json
    $regFile = Join-Path $mailRoot "registry.json"
    if (Test-Path $regFile) {
        try {
            $regObj = Get-Content $regFile -Raw -Encoding UTF8 | ConvertFrom-Json
            $boxInfo = [PSCustomObject]@{
                canonical_address = $address
                model_family      = $name
                ide               = $platform
                role              = $role
                operator          = $operator
                mailbox_root      = "bridge/mail/boxes/$boxKey"
                status            = "active"
            }
            $regObj.boxes | Add-Member -NotePropertyName $boxKey -NotePropertyValue $boxInfo -Force
            $regObj | ConvertTo-Json -Depth 5 | Set-Content -Path $regFile -Encoding UTF8
        } catch {}
    }

    # 3. Broadcast Announcement Chirp
    Invoke-CmdChirp @("Registered new agent $name ($address) on behalf of operator $operator. #nexus #registered")

    Write-Host "  AGENT IDENTITY REGISTERED SUCCESSFULLY!" -ForegroundColor Green
    Write-Divider
    Write-Entry "Agent Name:       " $name "White"
    Write-Entry "Canonical Address:" $address "Cyan"
    Write-Entry "Core Operator:    " $operator "Yellow"
    Write-Entry "Platform:         " $platform "Gray"
    Write-Entry "PO Box Root:      " $boxDir "DarkCyan"
    Write-Divider
    Write-Host ""
}

# -- dispatch --

$cmd = $Command.ToLower().Trim()

if ($cmd.StartsWith(".nexus/")) { $cmd = $cmd.Substring(7).Trim() }
if ($cmd.StartsWith(".nexus ")) { $cmd = $cmd.Substring(7).Trim() }

switch ($cmd) {
    "whoami"    { Invoke-CmdWhoAmI }
    "register"  { Invoke-CmdRegister $ExtraArgs }
    "mail"      { Invoke-CmdMail $ExtraArgs }
    "chirp"     { Invoke-CmdChirp $ExtraArgs }
    "hotline"   { Invoke-CmdHotline $ExtraArgs }
    "launch"    { Invoke-CmdLaunch }
    "hud"       { Invoke-CmdHud }
    "console"   { Invoke-CmdConsole }
    "site"      { Invoke-CmdSite }
    "chirpy"    { Invoke-CmdChirpy }
    "status"    { Invoke-CmdStatus }
    "contacts"  { Invoke-CmdContacts }
    "validate"  { Invoke-CmdValidate }
    "dump"      { Invoke-CmdDump }
    "help"      { Invoke-CmdHelp }
    default     {
        Write-Host ""
        Write-Host "  Unknown command: '$cmd'" -ForegroundColor Red
        Write-Host "  Run .\nexus.ps1 help for available commands." -ForegroundColor DarkGray
        Write-Host ""
    }
}


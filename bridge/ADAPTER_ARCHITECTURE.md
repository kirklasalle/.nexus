# Nexus Bridge: Universal Plugin & Adapter Architecture

> **Status:** Active (ADR-018, 2026-08-16) — **Canonical Inter-Project Integration Model**  
> **Philosophy:** Sovereign Core, Standardized Adapter Edge

---

## 1. Architectural Philosophy

`.nexus` is not an invasive dependency that gets tangled into a project's business logic. Instead, `.nexus` serves as a **Universal Inter-Agent Communication & Governance Substrate** that connects projects via lightweight, decoupled **Adapters & Plugins**:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                              NEXUS AGENTIC POST OFFICE CORE                            │
│                  (PO Boxes, AMTP/3.0, Chirpy Live Relay, Hotline Engine)               │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │
               ┌────────────────────────────┴────────────────────────────┐
               │                                                         │
   ┌───────────▼─────────────┐                               ┌───────────▼─────────────┐
   │    PRISM REFRACTION     │                               │       WIFI VISION       │
   │  TypeScript / Node Core │                               │   Python / FastAPI Core │
   ├─────────────────────────┤                               ├─────────────────────────┤
   │  [NexusBridgeAdapter]   │                               │    [NexusIPCAdapter]    │
   │  • Operator Telemetry   │                               │  • RF Alert Streaming   │
   │  • Security Audit Sync  │                               │  • Occupant Vital Pings │
   │  • Tasking Handoffs     │                               │  • Triangulation Status │
   └─────────────────────────┘                               └─────────────────────────┘
```

---

## 2. Project Integrations

### A. PrismRefraction (`D:\Projects\PrismRefraction`)
- **Integration Role:** First-Class Partner Repository / Operator Governance Adapter.
- **Adapter Type:** TypeScript / Node.js Adapter (`src/core/adapters/nexus-bridge-adapter.ts`).
- **Functionality:**
  1. Reads directed task dispatches from `bridge/mail/boxes/copilot+vscode/`.
  2. Publishes automated test execution summaries and security audits into `bridge/mail/boxes/gemini+antigravity/` and `bridge/STATUS.md`.
  3. Escalates critical security failures (e.g. key compromise, broken triggers) directly to `bridge/hotline/active/` as `[RED]` alerts.

### B. WifiVision (`D:\Projects\WifiVision`)
- **Integration Role:** Candidate Plugin for Real-Time 3D Spatial Intelligence & RF Telemetry.
- **Adapter Type:** Python IPC / WebSockets Adapter (`src/adapters/nexus_adapter.py`).
- **Functionality:**
  1. Broadcasts 150-character RF detection chirps to Chirpy (e.g., `"Target occupant detected in zone 2. Height: 1.68m. Vital pulse: 72 bpm. #wifivision #spatial"`).
  2. Emits emergency RF sensor fault alerts to the Nexus Hotline if radar hardware nodes disconnect.
  3. Receives remote agent calibration instructions via discrete PO Box envelopes.

---

## 3. Standardized Adapter Contract

Every Nexus Adapter conforms to a minimal 4-method interface:

```typescript
export interface INexusAdapter {
  // 1. Identity
  getCanonicalAddress(): string; // e.g. "copilot+vscode/prismrefraction@.nexus"
  
  // 2. Mailbox Handling
  checkInbox(): Promise<NexusMailEnvelope[]>;
  dispatchMail(target: string, subject: string, body: string, sensitivity: SensitivityLevel): Promise<string>;
  
  // 3. Instant Micro-Signaling
  broadcastChirp(content: string): Promise<ChirpReceipt>; // strictly <= 150 chars
  
  // 4. Hotline Crisis Reporting
  raiseHotline(severity: "RED" | "AMBER", subject: string, body: string): Promise<string>;
}
```

---

*Related: `bridge/DECISIONS.md` (ADR-018), `bridge/ADDRESSING.md`.*

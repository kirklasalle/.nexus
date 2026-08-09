// STP v2.0 parser — turns bridge Markdown into structured message objects.
// Tolerant by design: real production threads vary in header style.
(function (global) {
  "use strict";

  var HEADER_KEYS = {
    "date": "date", "from": "from", "to": "to", "status": "status",
    "priority": "priority", "sensitivity": "sensitivity", "subject": "subject",
    "tags": "tags", "action required": "actionRequired", "mcp tool timestamp": "mcpTimestamp"
  };

  // Split a channel file into candidate entry chunks on '---' rules.
  function splitEntries(md) {
    var lines = md.split(/\r?\n/);
    var chunks = [];
    var current = [];
    for (var i = 0; i < lines.length; i++) {
      if (/^---\s*$/.test(lines[i])) {
        if (current.join("\n").trim()) chunks.push(current.join("\n"));
        current = [];
      } else {
        current.push(lines[i]);
      }
    }
    if (current.join("\n").trim()) chunks.push(current.join("\n"));
    return chunks;
  }

  // Extract '**Key:** value' pairs from a chunk.
  function parseHeaders(chunk) {
    var out = {};
    var re = /^\*\*([^:*]+):\*\*\s*(.+)$/gm;
    var m;
    while ((m = re.exec(chunk)) !== null) {
      var key = m[1].trim().toLowerCase();
      if (HEADER_KEYS[key]) out[HEADER_KEYS[key]] = m[2].trim();
    }
    return out;
  }

  function severityOf(subject, priority) {
    var s = (subject || "").toUpperCase();
    var m = s.match(/\[(RED|AMBER|YELLOW|GREEN|BLUE)\]/);
    if (m) return m[1];
    if (/^critical$/i.test(priority || "")) return "RED";
    if (/EMERGENCY|CLEAR/.test(s)) return /CLEAR/.test(s) ? "GREEN" : "RED";
    return null;
  }

  // Public: parse a channel file into messages (chunks that have a From header).
  function parseChannel(md) {
    var chunks = splitEntries(md);
    var messages = [];
    for (var i = 0; i < chunks.length; i++) {
      var h = parseHeaders(chunks[i]);
      if (!h.from && !h.subject) continue; // prose section, not a message
      var body = chunks[i]
        .replace(/^\*\*([^:*]+):\*\*\s*.+$/gm, "")
        .replace(/^#{1,4}\s*/gm, "")
        .trim();
      messages.push({
        date: h.date || "",
        from: h.from || "unknown",
        to: h.to || "",
        status: h.status || "",
        priority: h.priority || "",
        sensitivity: h.sensitivity || "",
        subject: h.subject || "(no subject)",
        tags: h.tags || "",
        actionRequired: h.actionRequired || "",
        severity: severityOf(h.subject, h.priority),
        preview: body.slice(0, 340),
        body: body
      });
    }
    return messages;
  }

  // Public: parse the CONTACTS.md directory table into contact objects.
  function parseContacts(md) {
    var contacts = [];
    var lines = md.split(/\r?\n/);
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];
      if (!/^\|/.test(line) || /^\|\s*:?-{2,}/.test(line) || /Agent Handle/i.test(line)) continue;
      var cells = line.split("|").map(function (c) { return c.trim(); }).filter(function (c, idx, arr) {
        return !(idx === 0 && c === "") && !(idx === arr.length - 1 && c === "");
      });
      if (cells.length >= 7) {
        contacts.push({
          handle: cells[0].replace(/\*\*/g, ""),
          environment: cells[1],
          thread: cells[2].replace(/`/g, ""),
          role: cells[3],
          protocol: cells[4],
          status: cells[5],
          lastActive: cells[6]
        });
      }
    }
    return contacts;
  }

  // Public: extract '## Section' → text map from STATUS.md-style docs.
  function parseSections(md) {
    var out = {};
    var parts = md.split(/^##\s+/m);
    for (var i = 1; i < parts.length; i++) {
      var nl = parts[i].indexOf("\n");
      var title = parts[i].slice(0, nl).trim();
      out[title] = parts[i].slice(nl + 1).trim();
    }
    return out;
  }

  global.STP = { parseChannel: parseChannel, parseContacts: parseContacts, parseSections: parseSections };
})(window);

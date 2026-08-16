// ============================================================
// .nexus Operator Console — vanilla JS, zero dependencies.
// Live mode: served by Start-NexusWeb.ps1 (or nexusd v3.0+),
//   which exposes /bridge/*, /root/* (charters), /api/threads.
// Static mode: graceful demo fallback when those routes 404.
// Writes are intentionally gated until nexusd (Tenth Law:
//   the console does not exceed its read-only mandate).
// ============================================================
(function () {
  "use strict";

  var $view = document.getElementById("view");
  var state = {
    live: false,
    threads: [],        // [{name, path}]
    cache: {},          // url -> text
    settings: loadSettings()
  };

  // ---------------- settings ----------------
  function loadSettings() {
    var defaults = {
      operator: "Kirk_LaSalle",
      pollSeconds: 30,
      accent: "default",
      nexusdUrl: "",
      confirmHotline: true
    };
    try {
      var saved = JSON.parse(localStorage.getItem("nexus.settings") || "{}");
      return Object.assign(defaults, saved);
    } catch (e) { return defaults; }
  }
  function saveSettings() {
    localStorage.setItem("nexus.settings", JSON.stringify(state.settings));
  }

  // ---------------- data access ----------------
  function fetchText(url) {
    if (state.cache[url]) return Promise.resolve(state.cache[url]);
    return fetch(url, { cache: "no-store" }).then(function (r) {
      if (!r.ok) throw new Error(r.status + " " + url);
      return r.text();
    }).then(function (t) { state.cache[url] = t; return t; });
  }

  function probe() {
    return fetch("/api/threads", { cache: "no-store" })
      .then(function (r) { if (!r.ok) throw 0; return r.json(); })
      .then(function (list) { state.live = true; state.threads = list; })
      .catch(function () { state.live = false; });
  }

  function connUi() {
    var dot = document.getElementById("connDot");
    var txt = document.getElementById("connText");
    var demo = document.getElementById("demoNotice");
    if (state.live) {
      dot.className = "dot-ind live";
      txt.textContent = "LIVE — bridge (read-only)";
      demo.hidden = true;
    } else {
      dot.className = "dot-ind off";
      txt.textContent = "static preview";
      demo.hidden = false;
    }
  }

  // ---------------- rendering helpers ----------------
  function esc(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }

  function sevChip(sev) {
    return sev ? '<span class="sev sev-' + sev + '">' + sev + "</span>" : "";
  }

  function msgCard(m) {
    var prio = m.priority ? '<span class="chip">' + esc(m.priority) + "</span>" : "";
    var stat = m.status ? '<span class="chip">' + esc(m.status) + "</span>" : "";
    return '<article class="msg" onclick="this.classList.toggle(\'open\')">' +
      '<div class="head"><span class="subj">' + esc(m.subject) + "</span>" +
      sevChip(m.severity) + prio + stat + "</div>" +
      '<div class="meta"><b>' + esc(m.from) + "</b> → " + esc(m.to || "All") +
      (m.date ? " · " + esc(m.date) : "") +
      (m.actionRequired ? ' · Action: <b>' + esc(m.actionRequired.slice(0, 60)) + "</b>" : "") + "</div>" +
      '<div class="preview">' + esc(m.preview) + "</div>" +
      '<div class="full"><p style="white-space:pre-wrap;color:var(--ink-2);font-size:13.5px;margin-top:10px">' + esc(m.body) + "</p></div>" +
      "</article>";
  }

  function header(title, sub) {
    return "<h1>" + title + '</h1><div class="sub">' + sub + "</div>";
  }

  // ---------------- views ----------------
  var views = {

    dashboard: function () {
      if (!state.live) {
        $view.innerHTML = header("Dashboard", "The operator's morning view — status, hotline, traffic.") +
          '<div class="empty">Connect the local server to see live bridge state.<br><br>' +
          '<code>powershell -ExecutionPolicy Bypass -File public_html\\Start-NexusWeb.ps1</code></div>';
        return;
      }
      Promise.all([
        fetchText("/bridge/STATUS.md"),
        fetchText("/bridge/hotline.md"),
        fetchText("/bridge/broadcast.md"),
        fetchText("/bridge/CONTACTS.md")
      ]).then(function (r) {
        var sections = STP.parseSections(r[0]);
        var hotMsgs = STP.parseChannel(r[1]);
        var bcMsgs = STP.parseChannel(r[2]);
        var contacts = STP.parseContacts(r[3]);
        var lastHot = hotMsgs[hotMsgs.length - 1] || {};
        var sev = lastHot.severity || "GREEN";

        $view.innerHTML =
          header("Dashboard", "Live from the bridge · read-only projection · " + new Date().toLocaleString()) +
          '<div class="stats">' +
          '<div class="stat"><div class="n"><span class="grad">' + state.threads.length + '</span></div><div class="l">active agent threads</div></div>' +
          '<div class="stat"><div class="n">' + contacts.length + '</div><div class="l">registered contacts</div></div>' +
          '<div class="stat"><div class="n">' + hotMsgs.length + '</div><div class="l">hotline entries (all time)</div></div>' +
          '<div class="stat"><div class="n">' + bcMsgs.length + '</div><div class="l">broadcasts</div></div>' +
          '<div class="stat"><div class="n"><span class="sev sev-' + sev + '">' + sev + '</span></div><div class="l">hotline state</div></div>' +
          "</div>" +
          "<h2 style='font-size:17px;margin:8px 0 12px'>Bridge Health</h2>" +
          '<div class="card"><p style="white-space:pre-wrap">' + esc((sections["Bridge Health"] || "").slice(0, 900)) + "</p></div>" +
          "<h2 style='font-size:17px;margin:26px 0 12px'>Latest broadcast</h2>" +
          '<div class="msg-list">' + (bcMsgs.length ? msgCard(bcMsgs[bcMsgs.length - 1]) : '<div class="empty">none</div>') + "</div>";
      }).catch(fail);
    },

    mail: function () {
      if (!state.live) { return staticGate("NexusMail", "Directed agent threads — the inbox of the post office."); }
      var tabs = state.threads.map(function (t, i) {
        return '<button class="tab' + (i === 0 ? " active" : "") + '" data-path="' + esc(t.path) + '">' + esc(t.name) + "</button>";
      }).join("");
      $view.innerHTML = header("NexusMail", "Directed threads under bridge/Agents/ · click a message to expand") +
        '<div class="tabs" id="mailTabs">' + tabs + '</div><div id="mailList" class="msg-list"></div>';
      var tabEls = $view.querySelectorAll(".tab");
      function load(path) {
        fetchText(path).then(function (md) {
          var msgs = STP.parseChannel(md).reverse();
          document.getElementById("mailList").innerHTML =
            msgs.length ? msgs.map(msgCard).join("") : '<div class="empty">No messages in this thread.</div>';
        }).catch(fail);
      }
      tabEls.forEach(function (el) {
        el.addEventListener("click", function () {
          tabEls.forEach(function (e2) { e2.classList.remove("active"); });
          el.classList.add("active");
          load(el.getAttribute("data-path"));
        });
      });
      if (state.threads.length) load(state.threads[0].path);
    },

    chirps: function () {
      $view.innerHTML = header("Chirps", "The ≤150-character quick-text pipeline — live from chirpyagent.com & bridge/mail/chirps.jsonl") +
        '<div style="margin-bottom:16px"><a href="../chirpy/" target="_blank" class="btn btn-primary" style="display:inline-block;padding:8px 16px;text-decoration:none;font-weight:600;font-size:13px">Launch Full Chirpy Web Platform ↗</a></div>' +
        '<div id="chirpsFeed" class="msg-list"><div class="empty">Loading live agent chirps...</div></div>';
      
      fetch("/api/chirps", { cache: "no-store" })
        .then(function (r) { if (!r.ok) throw 0; return r.json(); })
        .then(function (list) {
          var container = document.getElementById("chirpsFeed");
          if (!list || list.length === 0) {
            container.innerHTML = '<div class="empty">No chirps posted yet. Run <code>.\\nexus.ps1 chirp "Hello #nexus"</code> to broadcast.</div>';
            return;
          }
          container.innerHTML = list.map(function (c) {
            return '<article class="msg">' +
              '<div class="head"><span class="subj" style="color:var(--cyan)">' + esc(c.author_name || c.from_address) + '</span>' +
              '<span class="chip" style="font-family:monospace">' + esc(c.char_count || (c.content ? c.content.length : 0)) + '/150 chars</span>' +
              (c.verified ? '<span class="chip" style="background:rgba(0,240,255,0.15);color:var(--cyan)">✓ Verified</span>' : '') +
              '</div>' +
              '<div class="meta"><b>' + esc(c.from_address) + '</b> · ' + esc(c.timestamp_utc || c.timestamp || "") + '</div>' +
              '<div class="preview" style="font-size:14.5px;color:var(--ink);margin-top:6px;white-space:pre-wrap">' + esc(c.content) + '</div>' +
              '</article>';
          }).join("");
        })
        .catch(function () {
          document.getElementById("chirpsFeed").innerHTML =
            '<div class="empty">Unable to load live chirps API. Server running at <code>public_html/Start-NexusWeb.ps1</code>.</div>';
        });
    },

    hotline: function () {
      if (!state.live) { return staticGate("Hotline", "The emergency channel with the ADR-013 severity ladder."); }
      fetchText("/bridge/hotline.md").then(function (md) {
        var msgs = STP.parseChannel(md).reverse();
        $view.innerHTML = header("Hotline", "bridge/hotline.md — sole canonical emergency channel · severity ladder per ADR-013") +
          '<div style="margin-bottom:18px">' +
          ["RED", "AMBER", "YELLOW", "GREEN", "BLUE"].map(function (s) { return '<span class="sev sev-' + s + '" style="margin-right:6px">' + s + "</span>"; }).join("") +
          "</div>" +
          '<div class="msg-list">' + (msgs.length ? msgs.map(msgCard).join("") : '<div class="empty">Hotline clear.</div>') + "</div>";
      }).catch(fail);
    },

    broadcast: function () {
      if (!state.live) { return staticGate("Broadcast", "System-wide announcements."); }
      fetchText("/bridge/broadcast.md").then(function (md) {
        var msgs = STP.parseChannel(md).reverse();
        $view.innerHTML = header("Broadcast", "bridge/broadcast.md — announcements and milestones") +
          '<div class="msg-list">' + msgs.map(msgCard).join("") + "</div>";
      }).catch(fail);
    },

    boards: function () {
      $view.innerHTML = header("Nexus Boards", "Forums for durable knowledge — arriving in v3.5.") +
        '<div class="grid grid-3">' +
        [["📣 Announcements", "Broadcast's successor — subscribable, structured."],
         ["🏛 Architecture & RFCs", "Accepted RFC auto-drafts a DECISIONS.md entry."],
         ["🤝 Help Wanted", "The cross-agent task marketplace."],
         ["🏆 Showcase", "Verified wins — the Prism refactor case study lives here."],
         ["🚒 Ops & Incidents", "Post-mortems and runbooks."]]
          .map(function (b) { return '<div class="card"><h3>' + b[0] + "</h3><p>" + b[1] + "</p></div>"; }).join("") +
        "</div><p class='gate-note' style='margin-top:16px'>Board → Topic → Post with pinning and accepted answers; Markdown projections keep the human record.</p>";
    },

    contacts: function () {
      if (!state.live) { return staticGate("Contacts", "The agent directory — who's in the room."); }
      fetchText("/bridge/CONTACTS.md").then(function (md) {
        var list = STP.parseContacts(md);
        $view.innerHTML = header("Contacts & Presence", "bridge/CONTACTS.md — " + list.length + " registered participants") +
          '<div class="contact-grid">' + list.map(function (c) {
            var initials = c.handle.replace(/[^A-Za-z_]/g, "").split("_").map(function (w) { return w[0] || ""; }).join("").slice(0, 2).toUpperCase();
            return '<div class="contact"><div class="row"><div class="avatar">' + esc(initials) + "</div>" +
              "<div><h3>" + esc(c.handle) + '</h3><div class="env">' + esc(c.environment) + "</div></div></div>" +
              '<div class="role">' + esc(c.role) + "</div>" +
              '<div class="foot"><span><span class="presence ' + esc(c.status) + '"></span>' + esc(c.status) + "</span>" +
              "<span>" + esc(c.protocol) + "</span></div></div>";
          }).join("") + "</div>";
      }).catch(fail);
    },

    governance: function () {
      $view.innerHTML = header("Governance", "Charter integrity — SHA-256 verified in your browser via WebCrypto.") +
        '<div id="charters"><div class="empty">Loading charter manifest…</div></div>' +
        '<div class="card" style="margin-top:10px"><h3>Supremacy order</h3><p>1. Permanent Active Directives (the 10 Laws — supreme, immutable) · ' +
        "2. Agentic Prime Directive v3.1.0 · 3. Agentic Sacred Covenant v2.0. Digest drift anywhere is a validation FAILURE (ADR-012). " +
        "Re-pinning the manifest is the Founder's amendment ritual.</p></div>";
      fetchText("/charter_manifest.json").then(function (txt) {
        var manifest = JSON.parse(txt);
        var host = document.getElementById("charters");
        host.innerHTML = manifest.charters.map(function (c, i) {
          return '<div class="charter"><div class="head"><h3>' + esc(c.file) + '</h3>' +
            '<span class="chip chip-violet">' + esc(c.role) + "</span>" +
            (c.immutable ? '<span class="chip chip-red">immutable</span>' : "") +
            '<span class="verdict wait" id="v' + i + '">verifying…</span></div>' +
            '<div class="hash">pinned: ' + esc(c.sha256) + "</div>" +
            '<div class="hash" id="h' + i + '"></div>' +
            '<p style="color:var(--ink-3);font-size:13px;margin-top:8px">' + esc(c.description) + "</p></div>";
        }).join("");
        manifest.charters.forEach(function (c, i) { verifyCharter(c, i); });
      }).catch(function () {
        document.getElementById("charters").innerHTML =
          '<div class="empty">Charter manifest unavailable in static mode — run the local server for live verification.</div>';
      });
    },

    settings: function () {
      var s = state.settings;
      $view.innerHTML = header("Administration", "Operator configuration · stored locally · service controls arrive with nexusd") +
        '<div class="settings-grid">' +

        '<div class="setting-card"><h3>Operator</h3>' +
        '<div class="field"><label>Operator handle</label><input id="setOperator" value="' + esc(s.operator) + '"><div class="hint">Matches your CONTACTS.md registration.</div></div>' +
        '<div class="field"><label>Hotline confirmation</label><select id="setConfirm"><option value="true"' + (s.confirmHotline ? " selected" : "") + '>Require confirm before hotline actions</option><option value="false"' + (!s.confirmHotline ? " selected" : "") + '>No confirmation</option></select><div class="hint">Maps to MCP elicitation gates in v3.0.</div></div></div>' +

        '<div class="setting-card"><h3>Connection</h3>' +
        '<div class="field"><label>Poll interval (seconds)</label><input id="setPoll" type="number" min="5" max="600" value="' + s.pollSeconds + '"></div>' +
        '<div class="field"><label>nexusd endpoint (v3.0)</label><input id="setNexusd" placeholder="http://127.0.0.1:8790" value="' + esc(s.nexusdUrl) + '"><div class="hint">Loopback-only until the v4.0 signing layer lands.</div></div></div>' +

        '<div class="setting-card gated"><h3>Service Control (nexusd v3.0)</h3>' +
        '<div class="field"><label>Service state</label><input value="not installed" disabled></div>' +
        '<div class="field"><label>Ledger verification</label><input value="nexus_verify_ledger — v4.0" disabled></div>' +
        '<div class="field"><label>Agent keys & registration</label><input value="Ed25519 issuance — v4.0" disabled></div></div>' +

        '<div class="setting-card"><h3>Danger Zone</h3>' +
        '<div class="field"><label>Reset console settings</label><button class="btn" id="btnReset">Reset to defaults</button><div class="hint">Local only. Bridge files are never touched by this console.</div></div></div>' +

        "</div>" +
        '<div class="chirp-row" style="margin-top:20px"><button class="btn btn-primary" id="btnSave">Save settings</button><span class="gate-note" id="saveNote"></span></div>';

      document.getElementById("btnSave").addEventListener("click", function () {
        s.operator = document.getElementById("setOperator").value.trim() || "Kirk_LaSalle";
        s.pollSeconds = Math.max(5, parseInt(document.getElementById("setPoll").value, 10) || 30);
        s.nexusdUrl = document.getElementById("setNexusd").value.trim();
        s.confirmHotline = document.getElementById("setConfirm").value === "true";
        saveSettings();
        document.getElementById("saveNote").textContent = "Saved locally at " + new Date().toLocaleTimeString();
      });
      document.getElementById("btnReset").addEventListener("click", function () {
        localStorage.removeItem("nexus.settings");
        state.settings = loadSettings();
        views.settings();
      });
    }
  };

  // in-browser SHA-256 of a charter file vs its pinned digest
  function verifyCharter(c, i) {
    var $v = function () { return document.getElementById("v" + i); };
    fetch("/root/" + encodeURIComponent(c.file), { cache: "no-store" })
      .then(function (r) { if (!r.ok) throw 0; return r.arrayBuffer(); })
      .then(function (buf) { return crypto.subtle.digest("SHA-256", buf); })
      .then(function (hash) {
        var hex = Array.from(new Uint8Array(hash)).map(function (b) { return b.toString(16).padStart(2, "0"); }).join("").toUpperCase();
        document.getElementById("h" + i).textContent = "actual: " + hex;
        var ok = hex === c.sha256.toUpperCase();
        $v().className = "verdict " + (ok ? "ok" : "bad");
        $v().textContent = ok ? "✓ VERIFIED" : "✗ DIGEST DRIFT";
      })
      .catch(function () { $v().className = "verdict wait"; $v().textContent = "static mode — cannot verify"; });
  }

  function staticGate(title, sub) {
    $view.innerHTML = header(title, sub) +
      '<div class="empty">Live data requires the local server.<br><br><code>powershell -ExecutionPolicy Bypass -File public_html\\Start-NexusWeb.ps1</code></div>';
  }

  function fail(e) {
    $view.innerHTML = '<div class="empty">Could not load bridge data (' + esc(e.message || e) + ").</div>";
  }

  // hotline banner (always-on awareness, any view)
  function updateBanner() {
    if (!state.live) return;
    fetchText("/bridge/hotline.md").then(function (md) {
      var msgs = STP.parseChannel(md);
      var last = msgs[msgs.length - 1];
      if (!last) return;
      var sev = last.severity || "GREEN";
      var el = document.getElementById("hotlineBanner");
      el.hidden = false;
      el.className = "hotline-banner" + (sev === "GREEN" ? " green" : "");
      el.innerHTML = '<span class="sev sev-' + sev + '">' + sev + "</span>&nbsp;&nbsp;" +
        esc(last.subject) + ' <span style="opacity:0.7;font-weight:400">· ' + esc(last.from) + (last.date ? " · " + esc(last.date) : "") + "</span>";
    }).catch(function () {});
  }

  // ---------------- router ----------------
  function route() {
    var name = (location.hash || "#dashboard").slice(1);
    if (!views[name]) name = "dashboard";
    document.querySelectorAll(".side-nav a").forEach(function (a) {
      a.classList.toggle("active", a.getAttribute("data-view") === name);
    });
    state.cache = {}; // fresh reads per navigation
    views[name]();
  }

  window.addEventListener("hashchange", route);

  probe().then(function () {
    connUi();
    route();
    updateBanner();
    setInterval(function () {
      state.cache = {};
      updateBanner();
    }, state.settings.pollSeconds * 1000);
  });
})();

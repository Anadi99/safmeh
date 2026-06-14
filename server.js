const http = require('http');
const PORT = 5000;

const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
  <title>SafMeh</title>
  <link rel="preconnect" href="https://fonts.googleapis.com"/>
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%; width: 100%;
      font-family: 'Space Grotesk', sans-serif;
      background: #F0E8EC;
      display: flex; align-items: center; justify-content: center;
      overflow: hidden;
    }
    #phone {
      width: 390px; height: 844px;
      background: #FFF8FA; border-radius: 40px; overflow: hidden;
      display: flex; flex-direction: column; position: relative;
      box-shadow: 0 30px 80px rgba(255,107,157,0.22), 0 8px 30px rgba(0,0,0,0.12);
    }
    @media (max-width: 420px) {
      html, body { background: #FFF8FA; }
      #phone { width: 100vw; height: 100dvh; border-radius: 0; box-shadow: none; }
    }

    .screen { display: none; flex-direction: column; flex: 1; min-height: 0; }
    .screen.active { display: flex; }
    .fade-in { animation: fadeIn 0.2s ease; }
    @keyframes fadeIn { from { opacity:0; transform:translateY(5px); } to { opacity:1; transform:translateY(0); } }

    /* STATUSBAR */
    .statusbar { padding: 16px 24px 0; display:flex; justify-content:space-between; align-items:center; flex-shrink:0; }
    .statusbar .time { font-size:13px; font-weight:600; color:#333; letter-spacing:0.02em; }
    .battery { width:25px; height:12px; border:1.5px solid #333; border-radius:3px; padding:1px 2px; display:flex; align-items:center; }
    .battery-fill { width:80%; height:100%; background:#4CAF50; border-radius:1.5px; }

    /* SCROLLABLE */
    .scroll-content { flex:1; overflow-y:auto; -webkit-overflow-scrolling:touch; min-height:0; }
    .scroll-content::-webkit-scrollbar { display:none; }

    /* BOTTOM NAV */
    .bottom-nav { background:#fff; border-top:1px solid #F3EEF0; padding:10px 0 24px; display:flex; justify-content:space-around; flex-shrink:0; }
    .nav-tab { display:flex; flex-direction:column; align-items:center; gap:4px; cursor:pointer; -webkit-tap-highlight-color:transparent; }
    .nav-tab span { font-size:10px; font-weight:500; color:#C0B0B5; }
    .nav-tab.active span { color:#FF6B9D; font-weight:700; }

    /* BACK BTN */
    .back-btn { width:32px; height:32px; border-radius:12px; background:#FFE4EE; display:flex; align-items:center; justify-content:center; cursor:pointer; -webkit-tap-highlight-color:transparent; flex-shrink:0; }

    /* ─── DASHBOARD ─── */
    .greeting { font-size:12px; color:#FF6B9D; font-weight:600; letter-spacing:0.08em; text-transform:uppercase; }
    .headline { font-size:24px; font-weight:700; color:#1A1A1A; letter-spacing:-0.02em; margin-top:4px; }
    .avatar { width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#FF6B9D,#FFB6C8); display:flex; align-items:center; justify-content:center; }
    .safe-pill { margin-top:14px; background:#EDFAF3; border-radius:10px; padding:8px 14px; display:inline-flex; align-items:center; gap:8px; border:1px solid #C3EDD5; }
    .safe-pill span { font-size:12px; font-weight:600; color:#166534; }
    .actions-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; padding:20px 20px 0; }
    .action-card { border-radius:18px; padding:18px 16px; cursor:pointer; -webkit-tap-highlight-color:transparent; transition:transform 0.1s; }
    .action-card:active { transform:scale(0.97); }
    .action-icon { width:34px; height:34px; border-radius:10px; display:flex; align-items:center; justify-content:center; margin-bottom:12px; }
    .action-label { font-size:14px; font-weight:700; color:#1A1A1A; letter-spacing:-0.01em; }
    .action-sub { font-size:11px; color:#888; font-weight:500; margin-top:3px; }
    .section-title { font-size:14px; font-weight:700; color:#1A1A1A; margin-bottom:12px; }
    .activity-item { background:#fff; border-radius:14px; padding:12px 14px; display:flex; align-items:center; gap:12px; border:1px solid #F3F3F3; margin-bottom:8px; }
    .act-dot { width:8px; height:8px; border-radius:50%; flex-shrink:0; }
    .act-label { flex:1; font-size:13px; font-weight:600; color:#1A1A1A; }
    .act-time { font-size:11px; color:#bbb; font-weight:500; white-space:nowrap; }

    /* ─── SOS ─── */
    #screen-sos { transition:background 0.4s; }
    #screen-sos.dark { background:#0D0008; }
    #screen-sos.dark .time { color:#FFB6C8; }
    #screen-sos.dark .battery { border-color:#FFB6C8; }
    .sos-btn {
      width:172px; height:172px; border-radius:50%;
      background:linear-gradient(135deg,#FF8FAB,#FF4B8B);
      box-shadow:0 0 0 14px #FFD5E5,0 20px 50px rgba(255,75,139,0.35);
      display:flex; flex-direction:column; align-items:center; justify-content:center;
      cursor:pointer; gap:6px; border:none; outline:none;
      transition:transform 0.15s, box-shadow 0.15s;
      font-family:'Space Grotesk',sans-serif;
    }
    .sos-btn:active { transform:scale(0.96); }
    .sos-btn-label { font-size:12px; font-weight:700; color:#fff; letter-spacing:0.08em; text-transform:uppercase; }
    .trigger-item { background:#fff; border-radius:14px; padding:12px 14px; display:flex; align-items:center; gap:12px; border:1px solid #F3EEF0; margin-bottom:8px; }
    .trigger-icon { width:34px; height:34px; border-radius:10px; background:#FFE4EE; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
    .trigger-label { font-size:13px; font-weight:600; color:#1A1A1A; }
    .trigger-sub { font-size:11px; color:#aaa; font-weight:500; margin-top:2px; }
    .sos-rings { position:relative; display:flex; align-items:center; justify-content:center; width:200px; height:200px; margin-bottom:36px; }
    .sos-ring { position:absolute; border-radius:50%; border:1.5px solid rgba(255,143,171,0.2); }
    .sos-ring-1 { width:190px; height:190px; }
    .sos-ring-2 { width:148px; height:148px; border-color:rgba(255,143,171,0.35); }
    .sos-core { width:112px; height:112px; border-radius:50%; background:linear-gradient(135deg,#FF4B8B,#FF8FAB); display:flex; align-items:center; justify-content:center; box-shadow:0 0 40px rgba(255,75,139,0.5); }
    .sos-step { background:rgba(255,182,200,0.07); border:1px solid rgba(255,182,200,0.12); border-radius:12px; padding:12px 16px; display:flex; align-items:center; gap:12px; margin-bottom:9px; }
    .step-check { width:20px; height:20px; border-radius:50%; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
    .step-check.done { background:rgba(34,197,94,0.15); border:1px solid #22C55E; }
    .step-check.pending { background:rgba(255,182,200,0.1); border:1px solid rgba(255,182,200,0.3); }
    .step-text { flex:1; font-size:13px; color:#FFB6C8; font-weight:500; }
    .cancel-sos { margin-top:28px; background:transparent; border:1px solid rgba(255,182,200,0.2); border-radius:14px; padding:12px 32px; color:#FF8FAB; font-size:13px; font-weight:600; cursor:pointer; font-family:'Space Grotesk',sans-serif; }
    .sos-action-link { display:flex; align-items:center; gap:10px; background:rgba(255,75,139,0.12); border:1px solid rgba(255,75,139,0.25); border-radius:14px; padding:13px 16px; text-decoration:none; margin-bottom:9px; }
    .sos-action-link span { font-size:13px; font-weight:600; color:#FF8FAB; }

    /* ─── SAFE WALK ─── */
    #map { height:100%; width:100%; z-index:1; }
    .map-box { margin:14px 20px 0; border-radius:20px; overflow:hidden; height:200px; position:relative; flex-shrink:0; }
    .map-badge { position:absolute; bottom:10px; left:12px; background:rgba(255,255,255,0.92); border-radius:8px; padding:4px 10px; font-size:11px; font-weight:600; color:#1A1A1A; z-index:10; backdrop-filter:blur(4px); }
    .stats-card { margin:12px 20px 0; background:#fff; border-radius:18px; padding:16px; border:1px solid #F3EEF0; }
    .stat-val { font-size:17px; font-weight:700; color:#1A1A1A; letter-spacing:-0.02em; text-align:center; }
    .stat-lbl { font-size:11px; color:#bbb; font-weight:500; margin-top:2px; text-align:center; }
    .progress-track { margin-top:14px; height:5px; background:#F3EEF0; border-radius:3px; overflow:hidden; }
    .progress-fill { height:100%; background:linear-gradient(90deg,#FF6B9D,#FFB6C8); border-radius:3px; transition:width 0.5s; }
    .checkin-card { margin:12px 20px 0; border-radius:16px; padding:14px 16px; display:flex; align-items:center; gap:12px; background:#FFF0F6; border:1px solid #FFD5E5; transition:background 0.3s,border-color 0.3s; }
    .checkin-card.confirmed { background:#EDFAF3; border-color:#C3EDD5; }
    .checkin-icon { width:40px; height:40px; border-radius:12px; background:#FF6B9D; display:flex; align-items:center; justify-content:center; flex-shrink:0; transition:background 0.3s; }
    .checkin-card.confirmed .checkin-icon { background:#22C55E; }
    .checkin-title { font-size:13px; font-weight:700; color:#1A1A1A; }
    .checkin-sub { font-size:11px; color:#999; font-weight:500; margin-top:2px; }
    .checkin-btn { background:#FF6B9D; border:none; border-radius:10px; padding:8px 14px; color:#fff; font-size:12px; font-weight:700; cursor:pointer; font-family:'Space Grotesk',sans-serif; transition:background 0.3s; }
    .checkin-card.confirmed .checkin-btn { background:#22C55E; }
    .share-pill { height:32px; border-radius:10px; padding:0 12px; display:flex; align-items:center; gap:6px; background:#FFE4EE; }
    .share-pill.other { background:#F3F3F3; }
    .arrived-btn { width:100%; background:#fff; border:1.5px solid #FFB6C8; border-radius:16px; padding:14px; color:#FF6B9D; font-size:14px; font-weight:700; cursor:pointer; font-family:'Space Grotesk',sans-serif; }
    .arrived-btn:active { background:#FFF0F6; }

    /* ─── PRETEND MODE (Calculator) ─── */
    #screen-pretend {
      background:#1C1C1E; color:#fff;
      font-family:'Space Grotesk',sans-serif;
    }
    .calc-display { flex:1; display:flex; flex-direction:column; justify-content:flex-end; padding:0 24px 16px; }
    .calc-expr { font-size:22px; color:#888; font-weight:400; min-height:28px; text-align:right; }
    .calc-result { font-size:62px; font-weight:300; text-align:right; letter-spacing:-0.02em; overflow:hidden; white-space:nowrap; }
    .calc-btns { display:grid; grid-template-columns:repeat(4,1fr); gap:12px; padding:12px 16px 32px; }
    .calc-btn {
      aspect-ratio:1; border-radius:50%; border:none; cursor:pointer;
      font-size:22px; font-weight:500; font-family:'Space Grotesk',sans-serif;
      display:flex; align-items:center; justify-content:center;
      -webkit-tap-highlight-color:transparent; transition:opacity 0.1s;
    }
    .calc-btn:active { opacity:0.7; }
    .calc-btn.gray { background:#A5A5A5; color:#000; }
    .calc-btn.dark { background:#333335; color:#fff; }
    .calc-btn.orange { background:#FF9F0A; color:#fff; }
    #pretend-tap-zone { position:absolute; top:0; left:0; right:0; height:60px; z-index:100; }

    /* ─── FAKE CALL ─── */
    #fake-call-overlay {
      position:absolute; inset:0; z-index:200;
      background:linear-gradient(180deg,#1A1A2E 0%,#16213E 100%);
      display:none; flex-direction:column; align-items:center;
      font-family:'Space Grotesk',sans-serif; color:#fff;
    }
    #fake-call-overlay.active { display:flex; }
    .call-top { flex:1; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:12px; }
    .call-avatar { width:100px; height:100px; border-radius:50%; background:linear-gradient(135deg,#FF6B9D,#FFB6C8); display:flex; align-items:center; justify-content:center; box-shadow:0 0 0 12px rgba(255,107,157,0.1); }
    .call-name { font-size:26px; font-weight:700; letter-spacing:-0.02em; }
    .call-status { font-size:14px; color:rgba(255,255,255,0.6); font-weight:500; }
    .call-timer { font-size:16px; color:rgba(255,255,255,0.5); margin-top:4px; font-weight:500; }
    .call-actions { padding:0 40px 60px; display:grid; grid-template-columns:1fr 1fr 1fr; gap:28px; width:100%; }
    .call-btn-wrap { display:flex; flex-direction:column; align-items:center; gap:8px; }
    .call-btn { width:64px; height:64px; border-radius:50%; border:none; display:flex; align-items:center; justify-content:center; cursor:pointer; -webkit-tap-highlight-color:transparent; }
    .call-btn-label { font-size:11px; color:rgba(255,255,255,0.6); font-weight:500; text-align:center; }
    .call-btn.mute { background:rgba(255,255,255,0.15); }
    .call-btn.speaker { background:rgba(255,255,255,0.15); }
    .call-btn.decline { background:#FF3B30; }
    .call-btn.answer { background:#34C759; }
    .call-vibrate { animation:vibrate 0.3s infinite; }
    @keyframes vibrate { 0%,100%{transform:rotate(0deg);} 25%{transform:rotate(-5deg);} 75%{transform:rotate(5deg);} }
    .call-ringing { display:flex; gap:16px; margin-top:20px; }
    .call-ringing-btn { width:72px; height:72px; border-radius:50%; border:none; display:flex; align-items:center; justify-content:center; cursor:pointer; }
    .call-ringing-btn.decline { background:#FF3B30; }
    .call-ringing-btn.answer { background:#34C759; }

    /* PERMISSION BANNER */
    .perm-banner { background:#FFF3CD; border:1px solid #FFE082; border-radius:12px; padding:10px 14px; margin:10px 20px 0; display:flex; align-items:flex-start; gap:10px; font-size:12px; color:#7A5C00; font-weight:500; line-height:1.4; }
    .perm-btn { background:#FF6B9D; border:none; border-radius:8px; padding:5px 10px; color:#fff; font-size:11px; font-weight:700; cursor:pointer; font-family:'Space Grotesk',sans-serif; white-space:nowrap; }

    /* LOCATION BAR */
    .loc-bar { background:#EDFAF3; border:1px solid #C3EDD5; border-radius:10px; padding:8px 12px; margin:10px 20px 0; font-size:12px; color:#166534; font-weight:600; display:none; align-items:center; gap:8px; }
    .loc-dot { width:7px; height:7px; border-radius:50%; background:#22C55E; animation:pulse 1.5s infinite; flex-shrink:0; }
    @keyframes pulse { 0%,100%{opacity:1;} 50%{opacity:0.4;} }

    /* PLACEHOLDER SCREENS */
    .placeholder-screen { flex:1; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:12px; padding:40px; }
    .placeholder-icon { width:64px; height:64px; border-radius:20px; display:flex; align-items:center; justify-content:center; }
    .placeholder-title { font-size:18px; font-weight:700; color:#1A1A1A; letter-spacing:-0.02em; }
    .placeholder-sub { font-size:13px; color:#999; font-weight:500; text-align:center; line-height:1.5; max-width:260px; }
  </style>
</head>
<body>
<div id="phone">

  <!-- ══════════ FAKE CALL OVERLAY ══════════ -->
  <div id="fake-call-overlay">
    <div class="statusbar" style="width:100%;color:rgba(255,255,255,0.7)">
      <span id="call-clock" style="font-size:13px;font-weight:600">9:41</span>
    </div>
    <div class="call-top">
      <div class="call-avatar call-vibrate" id="call-avatar">
        <svg width="44" height="44" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
      </div>
      <div class="call-name" id="call-name">Mum</div>
      <div class="call-status" id="call-status">incoming call</div>
      <div class="call-timer" id="call-timer-display" style="display:none"></div>
    </div>
    <div class="call-ringing" id="call-ringing-btns">
      <div class="call-btn-wrap">
        <button class="call-ringing-btn decline" onclick="declineCall()">
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        </button>
        <span class="call-btn-label" style="color:rgba(255,255,255,0.6)">Decline</span>
      </div>
      <div class="call-btn-wrap">
        <button class="call-ringing-btn answer" onclick="answerCall()">
          <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8a19.79 19.79 0 01-3.07-8.67A2 2 0 012 1h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 15l-.08 1.92z"/></svg>
        </button>
        <span class="call-btn-label" style="color:rgba(255,255,255,0.6)">Answer</span>
      </div>
    </div>
    <div style="height:48px"></div>
  </div>

  <!-- ══════════ DASHBOARD ══════════ -->
  <div id="screen-home" class="screen active fade-in">
    <div class="statusbar">
      <span class="time">9:41</span>
      <div style="display:flex;align-items:center;gap:6px">
        <svg width="16" height="12" viewBox="0 0 16 12" fill="none"><rect x="0" y="3" width="3" height="9" rx="1" fill="#333"/><rect x="4.5" y="2" width="3" height="10" rx="1" fill="#333"/><rect x="9" y="0" width="3" height="12" rx="1" fill="#333"/><rect x="13.5" y="0" width="2.5" height="12" rx="1" fill="#ddd"/></svg>
        <div class="battery"><div class="battery-fill"></div></div>
      </div>
    </div>
    <div style="padding:20px 24px 0;flex-shrink:0">
      <div style="display:flex;justify-content:space-between;align-items:flex-start">
        <div>
          <div class="greeting">Good evening</div>
          <h1 class="headline">Meku's Dashboard</h1>
        </div>
        <div class="avatar">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
        </div>
      </div>
      <div class="safe-pill">
        <div style="width:7px;height:7px;border-radius:50%;background:#22C55E"></div>
        <span>Safe · Trusted Circle Active</span>
      </div>
    </div>
    <div class="scroll-content">
      <div class="actions-grid">
        <div class="action-card" style="background:#FFE4EE" onclick="goTo('walk')">
          <div class="action-icon" style="background:#FF6B9D">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
          </div>
          <div class="action-label">Safe Walk</div>
          <div class="action-sub">Start journey</div>
        </div>
        <div class="action-card" style="background:#FFD5E5" onclick="goTo('sos')">
          <div class="action-icon" style="background:#FF4B8B">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
          </div>
          <div class="action-label">Silent SOS</div>
          <div class="action-sub">Emergency help</div>
        </div>
        <div class="action-card" style="background:#EEF4FF" onclick="goTo('pretend')">
          <div class="action-icon" style="background:#5B9BD5">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
          </div>
          <div class="action-label">Pretend Mode</div>
          <div class="action-sub">Hide the app</div>
        </div>
        <div class="action-card" style="background:#FFF4E5" onclick="startFakeCall()">
          <div class="action-icon" style="background:#E87A00">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8a19.79 19.79 0 01-3.07-8.67A2 2 0 012 1h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 15l-.08 1.92z"/></svg>
          </div>
          <div class="action-label">Fake Call</div>
          <div class="action-sub">Exit situation</div>
        </div>
      </div>
      <div style="padding:22px 20px 0">
        <div class="section-title">Recent Activity</div>
        <div class="activity-item"><div class="act-dot" style="background:#22C55E"></div><div class="act-label">Safe Walk completed</div><div class="act-time">2h ago</div></div>
        <div class="activity-item"><div class="act-dot" style="background:#F59E0B"></div><div class="act-label">Location shared with Mum</div><div class="act-time">5h ago</div></div>
        <div class="activity-item"><div class="act-dot" style="background:#FF6B9D"></div><div class="act-label">Comfort message received</div><div class="act-time">Yesterday</div></div>
      </div>
      <div style="height:20px"></div>
    </div>
    <div class="bottom-nav">
      <div class="nav-tab active" onclick="goTo('home')"><svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg><span>Home</span></div>
      <div class="nav-tab" onclick="goTo('circle')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8zM23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg><span>Circle</span></div>
      <div class="nav-tab" onclick="goTo('walk')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg><span>Route</span></div>
      <div class="nav-tab" onclick="goTo('comfort')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg><span>Comfort</span></div>
    </div>
  </div>

  <!-- ══════════ SILENT SOS ══════════ -->
  <div id="screen-sos" class="screen">
    <div class="statusbar">
      <span class="time">9:41</span>
      <div class="battery"><div class="battery-fill"></div></div>
    </div>
    <div id="sos-idle" style="display:flex;flex-direction:column;flex:1;min-height:0">
      <div style="padding:18px 24px 0;flex-shrink:0">
        <div style="display:flex;align-items:center;gap:10px">
          <div class="back-btn" onclick="goTo('home')">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2.5" stroke-linecap="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
          </div>
          <h1 style="font-size:20px;font-weight:700;color:#1A1A1A;letter-spacing:-0.02em">Silent SOS</h1>
        </div>
        <p style="margin:8px 0 0;font-size:13px;color:#999;font-weight:500">Triggers without making a sound or visible alert.</p>
      </div>
      <div id="sos-perm-banner" class="perm-banner" style="display:none">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#E87A00" stroke-width="2" stroke-linecap="round" flex-shrink="0"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
        <span>Allow location &amp; microphone so SOS can share your position and record audio.</span>
        <button class="perm-btn" onclick="requestSOSPermissions()">Allow</button>
      </div>
      <div style="display:flex;flex-direction:column;align-items:center;padding:32px 24px 0;flex-shrink:0">
        <button class="sos-btn" onclick="triggerSOS()">
          <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
          <span class="sos-btn-label">Hold for SOS</span>
        </button>
        <p style="margin-top:18px;font-size:12px;color:#C0B0B5;font-weight:500">Tap · Sends silently to your circle</p>
      </div>
      <div class="scroll-content" style="padding:0 20px">
        <div style="margin-top:26px">
          <div class="section-title">Emergency contacts</div>
          <div id="sos-contacts" style="margin-bottom:12px">
            <div style="background:#fff;border-radius:14px;padding:12px 14px;display:flex;align-items:center;gap:12px;border:1px solid #F3EEF0;margin-bottom:8px">
              <div style="width:34px;height:34px;border-radius:10px;background:#FFE4EE;display:flex;align-items:center;justify-content:center;flex-shrink:0">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8 19.79 19.79 0 012 1h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 15l-.08 1.92z"/></svg>
              </div>
              <div style="flex:1"><div style="font-size:13px;font-weight:600;color:#1A1A1A">Mum</div><div style="font-size:11px;color:#aaa;font-weight:500">+44 7700 900001</div></div>
              <a href="tel:+447700900001" style="background:#FF6B9D;border-radius:10px;padding:6px 12px;color:#fff;font-size:11px;font-weight:700;text-decoration:none">Call</a>
            </div>
            <div style="background:#fff;border-radius:14px;padding:12px 14px;display:flex;align-items:center;gap:12px;border:1px solid #F3EEF0;margin-bottom:8px">
              <div style="width:34px;height:34px;border-radius:10px;background:#FFE4EE;display:flex;align-items:center;justify-content:center;flex-shrink:0">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8 19.79 19.79 0 012 1h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 15l-.08 1.92z"/></svg>
              </div>
              <div style="flex:1"><div style="font-size:13px;font-weight:600;color:#1A1A1A">Riya</div><div style="font-size:11px;color:#aaa;font-weight:500">+44 7700 900002</div></div>
              <a href="tel:+447700900002" style="background:#FF6B9D;border-radius:10px;padding:6px 12px;color:#fff;font-size:11px;font-weight:700;text-decoration:none">Call</a>
            </div>
          </div>
          <div class="section-title">Other trigger methods</div>
          <div class="trigger-item">
            <div class="trigger-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M18.36 6.64a9 9 0 11-12.73 0M12 2v10"/></svg></div>
            <div><div class="trigger-label">Power button × 3</div><div class="trigger-sub">Press rapidly 3 times</div></div>
          </div>
          <div class="trigger-item">
            <div class="trigger-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 5L6 9H2v6h4l5 4V5zM19.07 4.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07"/></svg></div>
            <div><div class="trigger-label">Volume pattern</div><div class="trigger-sub">Up · Up · Down within 3 seconds</div></div>
          </div>
          <div class="trigger-item">
            <div class="trigger-icon"><svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3zM19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8"/></svg></div>
            <div><div class="trigger-label">Voice keyword</div><div class="trigger-sub">Say your secret phrase</div></div>
          </div>
        </div>
        <div style="height:20px"></div>
      </div>
    </div>

    <!-- SOS ACTIVATED -->
    <div id="sos-active" style="flex:1;display:none;flex-direction:column;align-items:center;justify-content:center;padding:0 28px">
      <div class="sos-rings">
        <div class="sos-ring sos-ring-1"></div>
        <div class="sos-ring sos-ring-2"></div>
        <div class="sos-core">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
        </div>
      </div>
      <h2 style="font-size:22px;font-weight:700;color:#FFB6C8;letter-spacing:-0.02em;margin-bottom:6px">SOS Activated</h2>
      <p style="font-size:13px;color:#FF8FAB;font-weight:500;margin-bottom:20px">Alerting your Trusted Circle silently</p>
      <div id="sos-steps" style="width:100%">
        <div class="sos-step"><div class="step-check done"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="3" stroke-linecap="round"><path d="M5 13l4 4L19 7"/></svg></div><span class="step-text">Location captured</span></div>
        <div class="sos-step" id="sos-step-rec"><div class="step-check pending" id="step-rec-check"><div style="width:6px;height:6px;border-radius:50%;background:rgba(255,182,200,0.4)"></div></div><span class="step-text">Mic recording...</span></div>
        <div class="sos-step"><div class="step-check pending"><div style="width:6px;height:6px;border-radius:50%;background:rgba(255,182,200,0.4)"></div></div><span class="step-text" id="sos-sms-status">Preparing messages...</span></div>
        <div class="sos-step"><div class="step-check pending" id="sos-step4-check"><div style="width:6px;height:6px;border-radius:50%;background:rgba(255,182,200,0.4)"></div></div><span class="step-text" id="sos-step4-text">Standing by...</span></div>
      </div>
      <div id="sos-call-links" style="width:100%;margin-top:12px"></div>
      <button class="cancel-sos" onclick="cancelSOS()">Cancel SOS</button>
    </div>
  </div>

  <!-- ══════════ SAFE WALK ══════════ -->
  <div id="screen-walk" class="screen">
    <div class="statusbar">
      <span class="time">9:41</span>
      <div class="battery"><div class="battery-fill"></div></div>
    </div>
    <div style="padding:18px 24px 0;flex-shrink:0">
      <div style="display:flex;align-items:center;gap:10px">
        <div class="back-btn" onclick="stopWalk();goTo('home')">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2.5" stroke-linecap="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
        </div>
        <div>
          <div style="font-size:18px;font-weight:700;color:#1A1A1A;letter-spacing:-0.02em">Safe Walk</div>
          <div id="walk-status-label" style="font-size:11px;color:#999;font-weight:600">Starting GPS...</div>
        </div>
      </div>
    </div>
    <div id="walk-loc-bar" class="loc-bar">
      <div class="loc-dot"></div>
      <span id="walk-loc-text">Getting location...</span>
    </div>
    <div class="map-box">
      <div id="map"></div>
      <div class="map-badge" id="map-badge">Initialising map...</div>
    </div>
    <div class="scroll-content">
      <div class="stats-card">
        <div style="display:flex;justify-content:space-between">
          <div><div class="stat-val" id="walk-dist">--</div><div class="stat-lbl">Travelled</div></div>
          <div><div class="stat-val" id="walk-time">00:00</div><div class="stat-lbl">Duration</div></div>
          <div><div class="stat-val" style="color:#22C55E">Safe</div><div class="stat-lbl">Status</div></div>
        </div>
        <div class="progress-track"><div class="progress-fill" id="walk-progress" style="width:5%"></div></div>
        <div style="margin-top:6px;display:flex;justify-content:space-between">
          <span style="font-size:11px;color:#FF6B9D;font-weight:600">Start</span>
          <span style="font-size:11px;color:#bbb;font-weight:500">Destination</span>
        </div>
      </div>
      <div id="checkin-card" class="checkin-card">
        <div class="checkin-icon">
          <svg id="checkin-icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round">
            <path d="M12 6v6l4 2M12 2a10 10 0 100 20A10 10 0 0012 2z"/>
          </svg>
        </div>
        <div style="flex:1">
          <div class="checkin-title" id="checkin-title">Check-in in <span style="color:#FF6B9D" id="checkin-countdown">5:00</span></div>
          <div class="checkin-sub" id="checkin-sub">Tap to confirm you're okay</div>
        </div>
        <button class="checkin-btn" id="checkin-btn" onclick="doCheckin()">I'm okay</button>
      </div>
      <div style="padding:14px 20px 0">
        <div style="font-size:13px;font-weight:700;color:#1A1A1A;margin-bottom:8px">Sharing with</div>
        <div style="display:flex;gap:8px">
          <div class="share-pill" style="background:#FFE4EE"><div style="width:16px;height:16px;border-radius:50%;background:#FF6B9D"></div><span style="font-size:12px;font-weight:600;color:#FF6B9D">Mum</span></div>
          <div class="share-pill" style="background:#FFE4EE"><div style="width:16px;height:16px;border-radius:50%;background:#FF6B9D"></div><span style="font-size:12px;font-weight:600;color:#FF6B9D">Riya</span></div>
          <div class="share-pill other"><div style="width:16px;height:16px;border-radius:50%;background:#ccc"></div><span style="font-size:12px;font-weight:600;color:#999">+1</span></div>
        </div>
      </div>
      <div style="padding:14px 20px 0;margin-top:auto">
        <button class="arrived-btn" onclick="stopWalk();goTo('home')">Arrived Safely</button>
      </div>
      <div style="height:16px"></div>
    </div>
    <div class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg><span>Home</span></div>
      <div class="nav-tab" onclick="goTo('circle')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg><span>Circle</span></div>
      <div class="nav-tab active"><svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg><span>Route</span></div>
      <div class="nav-tab" onclick="goTo('comfort')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg><span>Comfort</span></div>
    </div>
  </div>

  <!-- ══════════ PRETEND (CALCULATOR) ══════════ -->
  <div id="screen-pretend" class="screen">
    <div id="pretend-tap-zone" onclick="pretendTap()"></div>
    <div class="statusbar" style="flex-shrink:0">
      <span style="font-size:13px;font-weight:600;color:#fff" id="pclock">9:41</span>
    </div>
    <div class="calc-display">
      <div class="calc-expr" id="calc-expr"></div>
      <div class="calc-result" id="calc-result">0</div>
    </div>
    <div class="calc-btns">
      <button class="calc-btn gray" onclick="calcBtn('AC')">AC</button>
      <button class="calc-btn gray" onclick="calcBtn('+/-')">+/-</button>
      <button class="calc-btn gray" onclick="calcBtn('%')">%</button>
      <button class="calc-btn orange" onclick="calcBtn('/')">÷</button>
      <button class="calc-btn dark" onclick="calcBtn('7')">7</button>
      <button class="calc-btn dark" onclick="calcBtn('8')">8</button>
      <button class="calc-btn dark" onclick="calcBtn('9')">9</button>
      <button class="calc-btn orange" onclick="calcBtn('*')">×</button>
      <button class="calc-btn dark" onclick="calcBtn('4')">4</button>
      <button class="calc-btn dark" onclick="calcBtn('5')">5</button>
      <button class="calc-btn dark" onclick="calcBtn('6')">6</button>
      <button class="calc-btn orange" onclick="calcBtn('-')">−</button>
      <button class="calc-btn dark" onclick="calcBtn('1')">1</button>
      <button class="calc-btn dark" onclick="calcBtn('2')">2</button>
      <button class="calc-btn dark" onclick="calcBtn('3')">3</button>
      <button class="calc-btn orange" onclick="calcBtn('+')">+</button>
      <button class="calc-btn dark" style="grid-column:span 2;border-radius:36px;aspect-ratio:unset;justify-content:flex-start;padding-left:28px" onclick="calcBtn('0')">0</button>
      <button class="calc-btn dark" onclick="calcBtn('.')">.</button>
      <button class="calc-btn orange" onclick="calcBtn('=')">=</button>
    </div>
  </div>

  <!-- ══════════ CIRCLE ══════════ -->
  <div id="screen-circle" class="screen">
    <div class="statusbar"><span class="time">9:41</span><div class="battery"><div class="battery-fill"></div></div></div>
    <div class="placeholder-screen">
      <div class="placeholder-icon" style="background:#FFE4EE"><svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8zM23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg></div>
      <div class="placeholder-title">Trusted Circle</div>
      <div class="placeholder-sub">Your private safety circle. Only they receive SOS alerts and location updates.</div>
    </div>
    <div class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg><span>Home</span></div>
      <div class="nav-tab active"><svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg><span>Circle</span></div>
      <div class="nav-tab" onclick="goTo('walk')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg><span>Route</span></div>
      <div class="nav-tab" onclick="goTo('comfort')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg><span>Comfort</span></div>
    </div>
  </div>

  <!-- ══════════ COMFORT ══════════ -->
  <div id="screen-comfort" class="screen">
    <div class="statusbar"><span class="time">9:41</span><div class="battery"><div class="battery-fill"></div></div></div>
    <div class="placeholder-screen">
      <div class="placeholder-icon" style="background:#FFF0F6"><svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg></div>
      <div class="placeholder-title">Comfort Corner</div>
      <div class="placeholder-sub">"Glad you reached safely." — emotional safety matters too.</div>
    </div>
    <div class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg><span>Home</span></div>
      <div class="nav-tab" onclick="goTo('circle')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg><span>Circle</span></div>
      <div class="nav-tab" onclick="goTo('walk')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg><span>Route</span></div>
      <div class="nav-tab active"><svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg><span>Comfort</span></div>
    </div>
  </div>

</div><!-- /phone -->

<script>
// ── CLOCK ──
function updateClock() {
  const now = new Date();
  const t = now.getHours().toString().padStart(2,'0') + ':' + now.getMinutes().toString().padStart(2,'0');
  document.querySelectorAll('.time').forEach(el => el.textContent = t);
  document.getElementById('call-clock').textContent = t;
  document.getElementById('pclock').textContent = t;
}
updateClock(); setInterval(updateClock, 10000);

// ── NAVIGATION ──
const SCREENS = ['home','sos','walk','pretend','circle','comfort'];
function goTo(id) {
  SCREENS.forEach(s => {
    const el = document.getElementById('screen-'+s);
    el.classList.remove('active','fade-in');
  });
  const target = document.getElementById('screen-'+id);
  target.classList.add('active');
  requestAnimationFrame(() => target.classList.add('fade-in'));
  if (id === 'home') { cancelSOS(); }
  if (id === 'walk') initWalk();
  if (id === 'sos') checkSOSPerms();
}

// ═══════════════════════════════════
// ── SAFE WALK + GPS + LEAFLET MAP ──
// ═══════════════════════════════════
let map = null, marker = null, watchId = null;
let walkStart = null, walkTimer = null, walkSeconds = 0;
let checkinCountdown = 300, checkinTimer = null, checkedIn = false;
let pathCoords = [], pathLine = null, totalDist = 0;
let startCoord = null;

function initWalk() {
  if (!map) {
    map = L.map('map', { zoomControl: false, attributionControl: false })
      .setView([51.5, -0.1], 15);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19
    }).addTo(map);
    const pinkIcon = L.divIcon({
      className: '',
      html: '<div style="width:18px;height:18px;border-radius:50%;background:#FF6B9D;border:3px solid #fff;box-shadow:0 0 0 4px rgba(255,107,157,0.25)"></div>',
      iconSize: [18,18], iconAnchor: [9,9]
    });
    marker = L.marker([51.5, -0.1], { icon: pinkIcon }).addTo(map);
  }
  setTimeout(() => map.invalidateSize(), 100);

  if (!walkStart) {
    walkStart = Date.now();
    walkTimer = setInterval(updateWalkTimer, 1000);
    checkinTimer = setInterval(updateCheckin, 1000);
  }

  document.getElementById('walk-status-label').textContent = 'Starting GPS...';
  document.getElementById('walk-loc-bar').style.display = 'none';

  if ('geolocation' in navigator) {
    watchId = navigator.geolocation.watchPosition(onGPS, onGPSErr, {
      enableHighAccuracy: true, maximumAge: 5000, timeout: 10000
    });
  } else {
    document.getElementById('map-badge').textContent = 'GPS not available';
  }
}

function onGPS(pos) {
  const lat = pos.coords.latitude, lng = pos.coords.longitude;
  const acc = Math.round(pos.coords.accuracy);
  map.setView([lat, lng], 17);
  marker.setLatLng([lat, lng]);
  document.getElementById('map-badge').textContent = 'Live · ±' + acc + 'm';
  document.getElementById('walk-status-label').textContent = 'Tracking active';
  document.getElementById('walk-status-label').style.color = '#22C55E';
  const locBar = document.getElementById('walk-loc-bar');
  locBar.style.display = 'flex';
  document.getElementById('walk-loc-text').textContent =
    lat.toFixed(5) + ', ' + lng.toFixed(5) + ' · ±' + acc + 'm';

  if (!startCoord) startCoord = [lat, lng];
  pathCoords.push([lat, lng]);
  if (pathCoords.length > 1) {
    if (pathLine) map.removeLayer(pathLine);
    pathLine = L.polyline(pathCoords, { color:'#FF6B9D', weight:4, opacity:0.8 }).addTo(map);
    const last = pathCoords[pathCoords.length-2];
    const d = haversine(last[0],last[1],lat,lng);
    totalDist += d;
    document.getElementById('walk-dist').textContent =
      totalDist < 1000 ? Math.round(totalDist) + ' m' : (totalDist/1000).toFixed(2) + ' km';
    const pct = Math.min(totalDist / 2000 * 100, 95);
    document.getElementById('walk-progress').style.width = pct + '%';
  }
}
function onGPSErr(e) {
  document.getElementById('map-badge').textContent = 'GPS: ' + (e.code===1?'Permission denied':e.code===2?'Unavailable':'Timeout');
  document.getElementById('walk-status-label').textContent = 'GPS unavailable';
}
function haversine(lat1,lon1,lat2,lon2) {
  const R=6371000, dLat=(lat2-lat1)*Math.PI/180, dLon=(lon2-lon1)*Math.PI/180;
  const a=Math.sin(dLat/2)**2+Math.cos(lat1*Math.PI/180)*Math.cos(lat2*Math.PI/180)*Math.sin(dLon/2)**2;
  return R*2*Math.atan2(Math.sqrt(a),Math.sqrt(1-a));
}
function updateWalkTimer() {
  walkSeconds++;
  const m = Math.floor(walkSeconds/60).toString().padStart(2,'0');
  const s = (walkSeconds%60).toString().padStart(2,'0');
  document.getElementById('walk-time').textContent = m+':'+s;
}
function stopWalk() {
  if (watchId !== null) { navigator.geolocation.clearWatch(watchId); watchId = null; }
  clearInterval(walkTimer); clearInterval(checkinTimer);
  walkStart = null; walkSeconds = 0; totalDist = 0; pathCoords = []; startCoord = null;
  document.getElementById('walk-dist').textContent = '--';
  document.getElementById('walk-time').textContent = '00:00';
  document.getElementById('walk-progress').style.width = '5%';
  resetCheckin();
}
function updateCheckin() {
  if (checkedIn) return;
  checkinCountdown--;
  if (checkinCountdown <= 0) { checkinCountdown = 300; }
  const m = Math.floor(checkinCountdown/60).toString().padStart(2,'0');
  const s = (checkinCountdown%60).toString().padStart(2,'0');
  const el = document.getElementById('checkin-countdown');
  if (el) el.textContent = m+':'+s;
}
function doCheckin() {
  checkedIn = true;
  const card = document.getElementById('checkin-card');
  card.classList.add('confirmed');
  document.getElementById('checkin-title').textContent = 'Check-in confirmed';
  document.getElementById('checkin-sub').textContent = 'Timer reset';
  document.getElementById('checkin-btn').textContent = 'Done';
  document.getElementById('checkin-icon-svg').innerHTML = '<path d="M5 13l4 4L19 7"/>';
  setTimeout(() => { checkedIn = false; checkinCountdown = 300; resetCheckin(); }, 3000);
}
function resetCheckin() {
  const card = document.getElementById('checkin-card');
  if (!card) return;
  card.classList.remove('confirmed');
  document.getElementById('checkin-title').innerHTML = 'Check-in in <span style="color:#FF6B9D" id="checkin-countdown">5:00</span>';
  document.getElementById('checkin-sub').textContent = "Tap to confirm you're okay";
  document.getElementById('checkin-btn').textContent = "I'm okay";
  document.getElementById('checkin-icon-svg').innerHTML = '<path d="M12 6v6l4 2M12 2a10 10 0 100 20A10 10 0 0012 2z"/>';
}

// ═════════════════════════════
// ── SILENT SOS ──
// ═════════════════════════════
let sosTriggered = false, mediaRecorder = null, audioChunks = [];
let currentLat = null, currentLng = null;

function checkSOSPerms() {
  const banner = document.getElementById('sos-perm-banner');
  if (navigator.geolocation && navigator.mediaDevices) banner.style.display = 'flex';
}
function requestSOSPermissions() {
  navigator.geolocation.getCurrentPosition(p => {
    currentLat = p.coords.latitude; currentLng = p.coords.longitude;
    document.getElementById('sos-perm-banner').style.display = 'none';
  }, () => {});
  navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
    stream.getTracks().forEach(t => t.stop());
    document.getElementById('sos-perm-banner').style.display = 'none';
  }).catch(() => {});
}

function triggerSOS() {
  sosTriggered = true;
  document.getElementById('screen-sos').classList.add('dark');
  document.getElementById('sos-idle').style.display = 'none';
  document.getElementById('sos-active').style.display = 'flex';

  // 1. Get location
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(pos => {
      currentLat = pos.coords.latitude;
      currentLng = pos.coords.longitude;
      buildSOSLinks(currentLat, currentLng);
    }, () => {
      buildSOSLinks(null, null);
    });
  } else {
    buildSOSLinks(null, null);
  }

  // 2. Start mic recording
  if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
    navigator.mediaDevices.getUserMedia({ audio: true }).then(stream => {
      mediaRecorder = new MediaRecorder(stream);
      audioChunks = [];
      mediaRecorder.ondataavailable = e => audioChunks.push(e.data);
      mediaRecorder.start();
      const check = document.getElementById('step-rec-check');
      check.classList.remove('pending'); check.classList.add('done');
      check.innerHTML = '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="3" stroke-linecap="round"><path d="M5 13l4 4L19 7"/></svg>';
      document.querySelector('#sos-step-rec .step-text').textContent = 'Mic recording active';
    }).catch(() => {
      document.querySelector('#sos-step-rec .step-text').textContent = 'Mic not available';
    });
  }

  // 3. SMS status
  setTimeout(() => {
    document.getElementById('sos-sms-status').textContent = 'Open SMS to send alerts';
  }, 1200);

  // 4. Step 4
  setTimeout(() => {
    document.getElementById('sos-step4-text').textContent = 'SOS active — stay calm';
    const c = document.getElementById('sos-step4-check');
    c.classList.remove('pending'); c.classList.add('done');
    c.innerHTML = '<svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="3" stroke-linecap="round"><path d="M5 13l4 4L19 7"/></svg>';
  }, 2000);
}

function buildSOSLinks(lat, lng) {
  const locStr = lat ? lat.toFixed(5)+','+lng.toFixed(5) : 'unknown';
  const locLink = lat ? 'https://maps.google.com/?q='+lat+','+lng : '';
  const msg = encodeURIComponent('SOS! I need help. My location: ' + (locLink || locStr) + ' — SafMeh');
  const contacts = [
    { name:'Mum', tel:'+447700900001' },
    { name:'Riya', tel:'+447700900002' },
  ];
  const container = document.getElementById('sos-call-links');
  container.innerHTML = contacts.map(c => \`
    <a href="sms:\${c.tel}?body=\${msg}" class="sos-action-link">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#FF8FAB" stroke-width="2" stroke-linecap="round"><path d="M21 15a2 2 0 01-2 2H7l-4 4V5a2 2 0 012-2h14a2 2 0 012 2z"/></svg>
      <span>Send SOS to \${c.name}</span>
    </a>
    <a href="tel:\${c.tel}" class="sos-action-link" style="margin-top:-4px">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#FF8FAB" stroke-width="2" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8 19.79 19.79 0 012 1h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 15l-.08 1.92z"/></svg>
      <span>Call \${c.name}</span>
    </a>
  \`).join('');
  document.getElementById('sos-sms-status').textContent = 'Tap links below to alert contacts';
}

function cancelSOS() {
  if (!sosTriggered) return;
  sosTriggered = false;
  if (mediaRecorder && mediaRecorder.state !== 'inactive') mediaRecorder.stop();
  document.getElementById('screen-sos').classList.remove('dark');
  document.getElementById('sos-idle').style.display = 'flex';
  document.getElementById('sos-active').style.display = 'none';
  document.getElementById('sos-call-links').innerHTML = '';
  document.getElementById('sos-sms-status').textContent = 'Preparing messages...';
}

// ═════════════════════════════
// ── PRETEND MODE (CALCULATOR) ──
// ═════════════════════════════
let calcDisplay = '0', calcExpr = '', calcPrevOp = null, calcPrevVal = null, calcNewNum = true;
let pretendTapCount = 0, pretendTapTimer = null;

function pretendTap() {
  pretendTapCount++;
  clearTimeout(pretendTapTimer);
  pretendTapTimer = setTimeout(() => { pretendTapCount = 0; }, 600);
  if (pretendTapCount >= 3) {
    pretendTapCount = 0;
    goTo('home');
  }
}

function calcBtn(v) {
  const disp = document.getElementById('calc-result');
  const expr = document.getElementById('calc-expr');
  if (v === 'AC') {
    calcDisplay = '0'; calcExpr = ''; calcPrevOp = null; calcPrevVal = null; calcNewNum = true;
  } else if (v === '+/-') {
    calcDisplay = (parseFloat(calcDisplay) * -1).toString();
  } else if (v === '%') {
    calcDisplay = (parseFloat(calcDisplay) / 100).toString();
  } else if (['+','-','*','/'].includes(v)) {
    calcPrevVal = parseFloat(calcDisplay);
    calcPrevOp = v;
    calcExpr = calcDisplay + ' ' + ({'+':'+','-':'−','*':'×','/':'÷'}[v]);
    calcNewNum = true;
  } else if (v === '=') {
    if (calcPrevOp && calcPrevVal !== null) {
      const cur = parseFloat(calcDisplay);
      let r;
      if (calcPrevOp==='+') r=calcPrevVal+cur;
      else if (calcPrevOp==='-') r=calcPrevVal-cur;
      else if (calcPrevOp==='*') r=calcPrevVal*cur;
      else if (calcPrevOp==='/') r=cur===0?'Error':calcPrevVal/cur;
      calcDisplay = r.toString();
      calcExpr = '';
      calcPrevOp = null; calcPrevVal = null; calcNewNum = true;
    }
  } else if (v === '.') {
    if (calcNewNum) { calcDisplay = '0.'; calcNewNum = false; }
    else if (!calcDisplay.includes('.')) calcDisplay += '.';
  } else {
    if (calcNewNum || calcDisplay === '0') { calcDisplay = v; calcNewNum = false; }
    else if (calcDisplay.length < 10) calcDisplay += v;
  }
  disp.textContent = calcDisplay;
  expr.textContent = calcExpr;
}

// ═════════════════════════════
// ── FAKE CALL ──
// ═════════════════════════════
const fakeCallers = ['Mum','Riya','Priya','Best Friend','Work'];
let callInterval = null, callSeconds = 0;

function startFakeCall() {
  const caller = fakeCallers[Math.floor(Math.random()*fakeCallers.length)];
  document.getElementById('call-name').textContent = caller;
  document.getElementById('call-status').textContent = 'incoming call';
  document.getElementById('call-timer-display').style.display = 'none';
  document.getElementById('call-ringing-btns').style.display = 'flex';
  document.getElementById('call-avatar').classList.add('call-vibrate');
  document.getElementById('fake-call-overlay').classList.add('active');
  // vibrate if supported
  if (navigator.vibrate) navigator.vibrate([300,200,300,200,300]);
}

function answerCall() {
  document.getElementById('call-status').textContent = 'on a call';
  document.getElementById('call-ringing-btns').style.display = 'none';
  document.getElementById('call-timer-display').style.display = 'block';
  document.getElementById('call-avatar').classList.remove('call-vibrate');
  callSeconds = 0;
  callInterval = setInterval(() => {
    callSeconds++;
    const m = Math.floor(callSeconds/60).toString().padStart(2,'0');
    const s = (callSeconds%60).toString().padStart(2,'0');
    document.getElementById('call-timer-display').textContent = m+':'+s;
  }, 1000);
}

function declineCall() {
  clearInterval(callInterval); callSeconds = 0;
  document.getElementById('fake-call-overlay').classList.remove('active');
  if (navigator.vibrate) navigator.vibrate(0);
}
</script>
</body>
</html>`;

const server = http.createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  const screen = url.searchParams.get('screen') || 'home';
  const page = html.replace('</body>', `<script>window.addEventListener('load',()=>{ if('${screen}'!=='home') goTo('${screen}'); });</script></body>`);
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(page);
});

server.listen(PORT, '0.0.0.0', () => {
  console.log('SafMeh running on http://0.0.0.0:' + PORT);
});

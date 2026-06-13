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
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html, body {
      height: 100%;
      font-family: 'Space Grotesk', sans-serif;
      background: #F0E8EC;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
    }
    #phone {
      width: 390px;
      height: 844px;
      background: #FFF8FA;
      border-radius: 40px;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      box-shadow: 0 30px 80px rgba(255,107,157,0.22), 0 8px 30px rgba(0,0,0,0.12);
      position: relative;
    }
    @media (max-width: 420px) {
      html, body { background: #FFF8FA; }
      #phone { width: 100vw; height: 100dvh; border-radius: 0; box-shadow: none; }
    }

    /* SCREENS */
    .screen { display: none; flex-direction: column; flex: 1; overflow: hidden; }
    .screen.active { display: flex; }

    /* STATUS BAR */
    .statusbar {
      padding: 16px 24px 0;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-shrink: 0;
    }
    .statusbar .time { font-size: 13px; font-weight: 600; letter-spacing: 0.02em; color: #333; }
    .statusbar .icons { display: flex; align-items: center; gap: 6px; }
    .battery {
      width: 25px; height: 12px;
      border: 1.5px solid #333; border-radius: 3px;
      padding: 1px 2px; display: flex; align-items: center;
    }
    .battery-fill { width: 80%; height: 100%; background: #4CAF50; border-radius: 1.5px; }

    /* BOTTOM NAV */
    .bottom-nav {
      background: #fff;
      border-top: 1px solid #F3EEF0;
      padding: 10px 0 24px;
      display: flex;
      justify-content: space-around;
      flex-shrink: 0;
    }
    .nav-tab {
      display: flex; flex-direction: column; align-items: center; gap: 4px;
      cursor: pointer; -webkit-tap-highlight-color: transparent;
    }
    .nav-tab span { font-size: 10px; font-weight: 500; color: #C0B0B5; }
    .nav-tab.active span { color: #FF6B9D; font-weight: 700; }

    /* SCROLLABLE CONTENT */
    .scroll-content { flex: 1; overflow-y: auto; -webkit-overflow-scrolling: touch; }
    .scroll-content::-webkit-scrollbar { display: none; }

    /* DASHBOARD */
    #screen-home .header { padding: 20px 24px 0; flex-shrink: 0; }
    .greeting { font-size: 12px; color: #FF6B9D; font-weight: 600; letter-spacing: 0.08em; text-transform: uppercase; }
    .headline { font-size: 24px; font-weight: 700; color: #1A1A1A; letter-spacing: -0.02em; margin-top: 4px; }
    .avatar {
      width: 40px; height: 40px; border-radius: 50%;
      background: linear-gradient(135deg,#FF6B9D,#FFB6C8);
      display: flex; align-items: center; justify-content: center;
    }
    .safe-pill {
      margin-top: 14px;
      background: #EDFAF3; border-radius: 10px;
      padding: 8px 14px; display: inline-flex; align-items: center;
      gap: 8px; border: 1px solid #C3EDD5;
    }
    .safe-dot { width: 7px; height: 7px; border-radius: 50%; background: #22C55E; }
    .safe-pill span { font-size: 12px; font-weight: 600; color: #166534; }

    .actions-grid {
      display: grid; grid-template-columns: 1fr 1fr;
      gap: 12px; padding: 20px 20px 0;
    }
    .action-card {
      border-radius: 18px; padding: 18px 16px; cursor: pointer;
      -webkit-tap-highlight-color: transparent;
      transition: transform 0.1s, opacity 0.1s;
    }
    .action-card:active { transform: scale(0.97); opacity: 0.85; }
    .action-icon {
      width: 34px; height: 34px; border-radius: 10px;
      display: flex; align-items: center; justify-content: center;
      margin-bottom: 12px;
    }
    .action-label { font-size: 14px; font-weight: 700; color: #1A1A1A; letter-spacing: -0.01em; }
    .action-sub { font-size: 11px; color: #888; font-weight: 500; margin-top: 3px; }

    .section-title { font-size: 14px; font-weight: 700; color: #1A1A1A; letter-spacing: -0.01em; margin-bottom: 12px; }
    .activity-list { display: flex; flex-direction: column; gap: 8px; }
    .activity-item {
      background: #fff; border-radius: 14px; padding: 12px 14px;
      display: flex; align-items: center; gap: 12px; border: 1px solid #F3F3F3;
    }
    .act-dot { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; }
    .act-label { flex: 1; font-size: 13px; font-weight: 600; color: #1A1A1A; }
    .act-time { font-size: 11px; color: #bbb; font-weight: 500; white-space: nowrap; }

    /* SOS SCREEN */
    #screen-sos { transition: background 0.5s; }
    #screen-sos.dark { background: #0D0008; }
    #screen-sos.dark .statusbar .time { color: #FFB6C8; }
    #screen-sos.dark .battery { border-color: #FFB6C8; }

    .sos-header { padding: 18px 24px 0; flex-shrink: 0; }
    .back-btn {
      width: 32px; height: 32px; border-radius: 12px;
      background: #FFE4EE; display: flex; align-items: center; justify-content: center;
      cursor: pointer; -webkit-tap-highlight-color: transparent;
    }
    .sos-title { font-size: 20px; font-weight: 700; color: #1A1A1A; letter-spacing: -0.02em; }
    .sos-sub { font-size: 13px; color: #999; font-weight: 500; margin-top: 8px; }

    .sos-btn-wrap {
      display: flex; flex-direction: column; align-items: center;
      padding: 32px 24px 0; flex-shrink: 0;
    }
    .sos-btn {
      width: 172px; height: 172px; border-radius: 50%;
      background: linear-gradient(135deg, #FF8FAB, #FF4B8B);
      box-shadow: 0 0 0 14px #FFD5E5, 0 20px 50px rgba(255,75,139,0.35);
      display: flex; flex-direction: column; align-items: center; justify-content: center;
      cursor: pointer; gap: 6px; -webkit-tap-highlight-color: transparent;
      transition: transform 0.15s, box-shadow 0.15s;
      border: none; outline: none;
    }
    .sos-btn:active { transform: scale(0.96); box-shadow: 0 0 0 10px #FFD5E5, 0 10px 30px rgba(255,75,139,0.4); }
    .sos-btn-label {
      font-size: 12px; font-weight: 700; color: #fff;
      letter-spacing: 0.08em; text-transform: uppercase;
      font-family: 'Space Grotesk', sans-serif;
    }
    .sos-hint { margin-top: 18px; font-size: 12px; color: #C0B0B5; font-weight: 500; }

    .trigger-list { padding: 26px 20px 0; }
    .trigger-item {
      background: #fff; border-radius: 14px; padding: 12px 14px;
      display: flex; align-items: center; gap: 12px; border: 1px solid #F3EEF0;
      margin-bottom: 8px;
    }
    .trigger-icon {
      width: 34px; height: 34px; border-radius: 10px; background: #FFE4EE;
      display: flex; align-items: center; justify-content: center; flex-shrink: 0;
    }
    .trigger-label { font-size: 13px; font-weight: 600; color: #1A1A1A; }
    .trigger-sub { font-size: 11px; color: #aaa; font-weight: 500; margin-top: 2px; }

    /* SOS ACTIVATED */
    #sos-idle, #sos-active { display: flex; flex-direction: column; }
    #sos-active {
      flex: 1; align-items: center; justify-content: center;
      padding: 0 28px; display: none;
    }
    .sos-rings {
      position: relative; display: flex;
      align-items: center; justify-content: center;
      width: 200px; height: 200px; margin-bottom: 36px;
    }
    .sos-ring {
      position: absolute; border-radius: 50%;
      border: 1.5px solid rgba(255,143,171,0.2);
    }
    .sos-ring-1 { width: 190px; height: 190px; }
    .sos-ring-2 { width: 148px; height: 148px; border-color: rgba(255,143,171,0.35); }
    .sos-core {
      width: 112px; height: 112px; border-radius: 50%;
      background: linear-gradient(135deg, #FF4B8B, #FF8FAB);
      display: flex; align-items: center; justify-content: center;
      box-shadow: 0 0 40px rgba(255,75,139,0.5);
    }
    .sos-active-title { font-size: 22px; font-weight: 700; color: #FFB6C8; letter-spacing: -0.02em; margin-bottom: 6px; }
    .sos-active-sub { font-size: 13px; color: #FF8FAB; font-weight: 500; margin-bottom: 32px; }
    .sos-steps { width: 100%; display: flex; flex-direction: column; gap: 9px; }
    .sos-step {
      background: rgba(255,182,200,0.07);
      border: 1px solid rgba(255,182,200,0.12);
      border-radius: 12px; padding: 12px 16px;
      display: flex; align-items: center; gap: 12px;
    }
    .step-check {
      width: 20px; height: 20px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      flex-shrink: 0;
    }
    .step-check.done { background: rgba(34,197,94,0.15); border: 1px solid #22C55E; }
    .step-check.pending { background: rgba(255,182,200,0.1); border: 1px solid rgba(255,182,200,0.3); }
    .step-dot { width: 6px; height: 6px; border-radius: 50%; background: rgba(255,182,200,0.4); }
    .step-text { flex: 1; font-size: 13px; color: #FFB6C8; font-weight: 500; }
    .cancel-sos {
      margin-top: 28px; background: transparent;
      border: 1px solid rgba(255,182,200,0.2); border-radius: 14px;
      padding: 12px 32px; color: #FF8FAB; font-size: 13px;
      font-weight: 600; cursor: pointer; font-family: 'Space Grotesk', sans-serif;
      letter-spacing: 0.02em;
    }
    .cancel-sos:active { opacity: 0.7; }

    /* SAFE WALK */
    .walk-header { padding: 18px 24px 0; flex-shrink: 0; }
    .walk-header-inner { display: flex; align-items: center; gap: 10px; }
    .walk-title { font-size: 18px; font-weight: 700; color: #1A1A1A; letter-spacing: -0.02em; }
    .walk-status { font-size: 11px; color: #22C55E; font-weight: 600; margin-top: 1px; }

    .map-box {
      margin: 14px 20px 0; border-radius: 20px; overflow: hidden;
      height: 186px; position: relative; flex-shrink: 0;
      background: linear-gradient(160deg, #E0F2E9 0%, #C8E6C9 60%, #B2DFDB 100%);
    }
    .map-grid {
      position: absolute; inset: 0;
      background-image:
        repeating-linear-gradient(0deg, rgba(255,255,255,0.12) 0px, rgba(255,255,255,0.12) 1px, transparent 1px, transparent 36px),
        repeating-linear-gradient(90deg, rgba(255,255,255,0.12) 0px, rgba(255,255,255,0.12) 1px, transparent 1px, transparent 36px);
    }
    .map-road-h { position: absolute; top: 50%; left: 0; right: 0; height: 7px; background: rgba(255,255,255,0.45); transform: translateY(-50%); }
    .map-road-v { position: absolute; left: 38%; top: 0; bottom: 0; width: 5px; background: rgba(255,255,255,0.3); }
    .map-live-dot {
      position: absolute; left: calc(38% - 10px); top: calc(50% - 10px);
      width: 20px; height: 20px; border-radius: 50%;
      background: #FF6B9D; border: 2.5px solid #fff;
      box-shadow: 0 0 0 5px rgba(255,107,157,0.22);
    }
    .map-dest {
      position: absolute; right: 28px; top: 24px;
      width: 20px; height: 20px; border-radius: 50%;
      background: #fff; border: 2px solid #FF6B9D;
      display: flex; align-items: center; justify-content: center;
    }
    .map-dest-dot { width: 6px; height: 6px; border-radius: 50%; background: #FF6B9D; }
    .map-badge {
      position: absolute; bottom: 10px; left: 12px;
      background: rgba(255,255,255,0.9); border-radius: 8px;
      padding: 4px 10px; backdrop-filter: blur(4px);
      font-size: 11px; font-weight: 600; color: #1A1A1A;
    }

    .stats-card {
      margin: 12px 20px 0; background: #fff;
      border-radius: 18px; padding: 16px; border: 1px solid #F3EEF0;
    }
    .stats-row { display: flex; justify-content: space-between; }
    .stat-val { font-size: 17px; font-weight: 700; color: #1A1A1A; letter-spacing: -0.02em; text-align: center; }
    .stat-lbl { font-size: 11px; color: #bbb; font-weight: 500; margin-top: 2px; text-align: center; }
    .progress-track { margin-top: 14px; height: 5px; background: #F3EEF0; border-radius: 3px; overflow: hidden; }
    .progress-fill { width: 62%; height: 100%; background: linear-gradient(90deg,#FF6B9D,#FFB6C8); border-radius: 3px; }
    .progress-labels { margin-top: 6px; display: flex; justify-content: space-between; }
    .prog-from { font-size: 11px; color: #FF6B9D; font-weight: 600; }
    .prog-to { font-size: 11px; color: #bbb; font-weight: 500; }

    .checkin-card {
      margin: 12px 20px 0; border-radius: 16px; padding: 14px 16px;
      display: flex; align-items: center; gap: 12px;
      background: #FFF0F6; border: 1px solid #FFD5E5;
      transition: background 0.3s, border-color 0.3s;
    }
    .checkin-card.confirmed { background: #EDFAF3; border-color: #C3EDD5; }
    .checkin-icon {
      width: 40px; height: 40px; border-radius: 12px; background: #FF6B9D;
      display: flex; align-items: center; justify-content: center; flex-shrink: 0;
      transition: background 0.3s;
    }
    .checkin-card.confirmed .checkin-icon { background: #22C55E; }
    .checkin-title { font-size: 13px; font-weight: 700; color: #1A1A1A; }
    .checkin-sub { font-size: 11px; color: #999; font-weight: 500; margin-top: 2px; }
    .checkin-btn {
      background: #FF6B9D; border: none; border-radius: 10px;
      padding: 8px 14px; color: #fff; font-size: 12px; font-weight: 700;
      cursor: pointer; font-family: 'Space Grotesk', sans-serif;
      letter-spacing: 0.02em; transition: background 0.3s;
      -webkit-tap-highlight-color: transparent;
    }
    .checkin-card.confirmed .checkin-btn { background: #22C55E; }
    .checkin-btn:active { opacity: 0.8; }

    .share-section { padding: 14px 20px 0; }
    .share-label { font-size: 13px; font-weight: 700; color: #1A1A1A; margin-bottom: 8px; }
    .share-pills { display: flex; gap: 8px; }
    .share-pill {
      height: 32px; border-radius: 10px; padding: 0 12px;
      display: flex; align-items: center; gap: 6px; background: #FFE4EE;
    }
    .share-pill.other { background: #F3F3F3; }
    .share-avatar { width: 16px; height: 16px; border-radius: 50%; background: #FF6B9D; }
    .share-pill.other .share-avatar { background: #ccc; }
    .share-pill-name { font-size: 12px; font-weight: 600; color: #FF6B9D; }
    .share-pill.other .share-pill-name { color: #999; }

    .arrived-btn-wrap { padding: 14px 20px 0; margin-top: auto; }
    .arrived-btn {
      width: 100%; background: #fff; border: 1.5px solid #FFB6C8;
      border-radius: 16px; padding: 14px; color: #FF6B9D;
      font-size: 14px; font-weight: 700; cursor: pointer;
      font-family: 'Space Grotesk', sans-serif; letter-spacing: -0.01em;
      -webkit-tap-highlight-color: transparent;
    }
    .arrived-btn:active { background: #FFF0F6; }

    /* TRANSITIONS */
    .fade-in { animation: fadeIn 0.22s ease; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }
  </style>
</head>
<body>
<div id="phone">

  <!-- ═══════════ DASHBOARD ═══════════ -->
  <div id="screen-home" class="screen active fade-in">
    <div class="statusbar">
      <span class="time" id="clock-home">9:41</span>
      <div class="icons">
        <svg width="16" height="12" viewBox="0 0 16 12" fill="none">
          <rect x="0" y="3" width="3" height="9" rx="1" fill="#333"/>
          <rect x="4.5" y="2" width="3" height="10" rx="1" fill="#333"/>
          <rect x="9" y="0" width="3" height="12" rx="1" fill="#333"/>
          <rect x="13.5" y="0" width="2.5" height="12" rx="1" fill="#ddd"/>
        </svg>
        <div class="battery"><div class="battery-fill"></div></div>
      </div>
    </div>

    <div class="header">
      <div style="display:flex;justify-content:space-between;align-items:flex-start">
        <div>
          <div class="greeting">Good evening</div>
          <h1 class="headline">Mehak's Dashboard</h1>
        </div>
        <div class="avatar">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round">
            <circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
          </svg>
        </div>
      </div>
      <div class="safe-pill">
        <div class="safe-dot"></div>
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
        <div class="action-card" style="background:#EEF4FF">
          <div class="action-icon" style="background:#5B9BD5">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
          </div>
          <div class="action-label">Pretend Mode</div>
          <div class="action-sub">Hide the app</div>
        </div>
        <div class="action-card" style="background:#FFF4E5">
          <div class="action-icon" style="background:#E87A00">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round"><path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8a19.79 19.79 0 01-3.07-8.67A2 2 0 012 1h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 15l-.08 1.92z"/></svg>
          </div>
          <div class="action-label">Fake Call</div>
          <div class="action-sub">Exit situation</div>
        </div>
      </div>

      <div style="padding:22px 20px 0">
        <div class="section-title">Recent Activity</div>
        <div class="activity-list">
          <div class="activity-item">
            <div class="act-dot" style="background:#22C55E"></div>
            <div class="act-label">Safe Walk completed</div>
            <div class="act-time">2h ago</div>
          </div>
          <div class="activity-item">
            <div class="act-dot" style="background:#F59E0B"></div>
            <div class="act-label">Location shared with Mum</div>
            <div class="act-time">5h ago</div>
          </div>
          <div class="activity-item">
            <div class="act-dot" style="background:#FF6B9D"></div>
            <div class="act-label">Comfort message received</div>
            <div class="act-time">Yesterday</div>
          </div>
        </div>
      </div>
      <div style="height:20px"></div>
    </div>

    <div class="bottom-nav">
      <div class="nav-tab active" onclick="goTo('home')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
        <span>Home</span>
      </div>
      <div class="nav-tab" onclick="goTo('circle')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8zM23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg>
        <span>Circle</span>
      </div>
      <div class="nav-tab" onclick="goTo('walk')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg>
        <span>Route</span>
      </div>
      <div class="nav-tab" onclick="goTo('comfort')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
        <span>Comfort</span>
      </div>
    </div>
  </div>

  <!-- ═══════════ SILENT SOS ═══════════ -->
  <div id="screen-sos" class="screen">
    <div class="statusbar">
      <span class="time" id="clock-sos">9:41</span>
      <div class="icons">
        <div class="battery"><div class="battery-fill"></div></div>
      </div>
    </div>

    <!-- IDLE STATE -->
    <div id="sos-idle">
      <div class="sos-header">
        <div style="display:flex;align-items:center;gap:10px">
          <div class="back-btn" onclick="goTo('home')">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2.5" stroke-linecap="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
          </div>
          <h1 class="sos-title">Silent SOS</h1>
        </div>
        <p class="sos-sub">Triggers without making a sound or visible alert.</p>
      </div>

      <div class="sos-btn-wrap">
        <button class="sos-btn" onclick="triggerSOS()">
          <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
          <span class="sos-btn-label">Hold for SOS</span>
        </button>
        <p class="sos-hint">Hold 2 sec · Sends silently</p>
      </div>

      <div class="scroll-content">
        <div class="trigger-list">
          <div class="section-title" style="margin-bottom:12px">Other trigger methods</div>
          <div class="trigger-item">
            <div class="trigger-icon">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M18.36 6.64a9 9 0 11-12.73 0M12 2v10"/></svg>
            </div>
            <div><div class="trigger-label">Power button × 3</div><div class="trigger-sub">Press 3 times within 2 seconds</div></div>
          </div>
          <div class="trigger-item">
            <div class="trigger-icon">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M12 2v20M2 12h20"/></svg>
            </div>
            <div><div class="trigger-label">Shake phone</div><div class="trigger-sub">Shake firmly for 2 seconds</div></div>
          </div>
          <div class="trigger-item">
            <div class="trigger-icon">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 5L6 9H2v6h4l5 4V5zM19.07 4.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07"/></svg>
            </div>
            <div><div class="trigger-label">Volume pattern</div><div class="trigger-sub">Up · Up · Down within 3 seconds</div></div>
          </div>
          <div class="trigger-item">
            <div class="trigger-icon">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3zM19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8"/></svg>
            </div>
            <div><div class="trigger-label">Voice keyword</div><div class="trigger-sub">Say your secret phrase</div></div>
          </div>
        </div>
      </div>
    </div>

    <!-- ACTIVATED STATE -->
    <div id="sos-active">
      <div class="sos-rings">
        <div class="sos-ring sos-ring-1"></div>
        <div class="sos-ring sos-ring-2"></div>
        <div class="sos-core">
          <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
        </div>
      </div>
      <h2 class="sos-active-title">SOS Activated</h2>
      <p class="sos-active-sub">Silently alerting your Trusted Circle</p>
      <div class="sos-steps">
        <div class="sos-step">
          <div class="step-check done"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="3" stroke-linecap="round"><path d="M5 13l4 4L19 7"/></svg></div>
          <span class="step-text">Live location shared</span>
        </div>
        <div class="sos-step">
          <div class="step-check done"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="3" stroke-linecap="round"><path d="M5 13l4 4L19 7"/></svg></div>
          <span class="step-text">Audio recording started</span>
        </div>
        <div class="sos-step">
          <div class="step-check done"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" stroke-width="3" stroke-linecap="round"><path d="M5 13l4 4L19 7"/></svg></div>
          <span class="step-text">Mum notified</span>
        </div>
        <div class="sos-step">
          <div class="step-check pending"><div class="step-dot"></div></div>
          <span class="step-text">Riya notified</span>
        </div>
      </div>
      <button class="cancel-sos" onclick="cancelSOS()">Cancel SOS</button>
    </div>

    <div id="sos-nav" class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
        <span>Home</span>
      </div>
      <div class="nav-tab" onclick="goTo('circle')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg>
        <span>Circle</span>
      </div>
      <div class="nav-tab" onclick="goTo('walk')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg>
        <span>Route</span>
      </div>
      <div class="nav-tab" onclick="goTo('comfort')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
        <span>Comfort</span>
      </div>
    </div>
  </div>

  <!-- ═══════════ SAFE WALK ═══════════ -->
  <div id="screen-walk" class="screen">
    <div class="statusbar">
      <span class="time" id="clock-walk">9:41</span>
      <div class="icons">
        <div class="battery"><div class="battery-fill"></div></div>
      </div>
    </div>

    <div class="walk-header">
      <div class="walk-header-inner">
        <div class="back-btn" onclick="goTo('home')">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2.5" stroke-linecap="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
        </div>
        <div>
          <div class="walk-title">Safe Walk</div>
          <div class="walk-status">Tracking active</div>
        </div>
      </div>
    </div>

    <div class="scroll-content">
      <div class="map-box">
        <div class="map-grid"></div>
        <div class="map-road-h"></div>
        <div class="map-road-v"></div>
        <svg style="position:absolute;inset:0" width="350" height="186">
          <path d="M 36 150 Q 80 75 138 92 Q 196 110 252 56 Q 292 26 318 38" stroke="#FF6B9D" stroke-width="3.5" fill="none" stroke-dasharray="7 4" stroke-linecap="round"/>
        </svg>
        <div class="map-live-dot"></div>
        <div class="map-dest"><div class="map-dest-dot"></div></div>
        <div class="map-badge">Live · GPS active</div>
      </div>

      <div class="stats-card">
        <div class="stats-row">
          <div><div class="stat-val">1.2 km</div><div class="stat-lbl">Remaining</div></div>
          <div><div class="stat-val">14 min</div><div class="stat-lbl">ETA</div></div>
          <div><div class="stat-val">Safe</div><div class="stat-lbl">Status</div></div>
        </div>
        <div class="progress-track"><div class="progress-fill"></div></div>
        <div class="progress-labels">
          <span class="prog-from">Home</span>
          <span class="prog-to">Mehak's Office</span>
        </div>
      </div>

      <div id="checkin-card" class="checkin-card">
        <div class="checkin-icon">
          <svg id="checkin-icon-svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round">
            <path d="M12 6v6l4 2M12 2a10 10 0 100 20A10 10 0 0012 2z"/>
          </svg>
        </div>
        <div style="flex:1">
          <div class="checkin-title" id="checkin-title">Check-in in <span style="color:#FF6B9D">4:32</span></div>
          <div class="checkin-sub" id="checkin-sub">Tap to confirm you're okay</div>
        </div>
        <button class="checkin-btn" id="checkin-btn" onclick="doCheckin()">I'm okay</button>
      </div>

      <div class="share-section">
        <div class="share-label">Sharing with</div>
        <div class="share-pills">
          <div class="share-pill">
            <div class="share-avatar"></div>
            <span class="share-pill-name">Mum</span>
          </div>
          <div class="share-pill">
            <div class="share-avatar"></div>
            <span class="share-pill-name">Riya</span>
          </div>
          <div class="share-pill other">
            <div class="share-avatar"></div>
            <span class="share-pill-name">+1</span>
          </div>
        </div>
      </div>

      <div class="arrived-btn-wrap">
        <button class="arrived-btn" onclick="goTo('home')">Arrived Safely</button>
      </div>
      <div style="height:16px"></div>
    </div>

    <div class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg>
        <span>Home</span>
      </div>
      <div class="nav-tab" onclick="goTo('circle')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg>
        <span>Circle</span>
      </div>
      <div class="nav-tab active" onclick="goTo('walk')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg>
        <span>Route</span>
      </div>
      <div class="nav-tab" onclick="goTo('comfort')">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
        <span>Comfort</span>
      </div>
    </div>
  </div>

  <!-- ═══════════ CIRCLE (placeholder) ═══════════ -->
  <div id="screen-circle" class="screen">
    <div class="statusbar">
      <span class="time">9:41</span>
      <div class="icons"><div class="battery"><div class="battery-fill"></div></div></div>
    </div>
    <div style="flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;padding:40px">
      <div style="width:64px;height:64px;border-radius:20px;background:#FFE4EE;display:flex;align-items:center;justify-content:center">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8zM23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75"/></svg>
      </div>
      <div style="font-size:18px;font-weight:700;color:#1A1A1A;letter-spacing:-0.02em">Trusted Circle</div>
      <div style="font-size:13px;color:#999;font-weight:500;text-align:center;line-height:1.5">Your private safety circle.<br/>Only they receive SOS alerts.</div>
    </div>
    <div class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg><span>Home</span></div>
      <div class="nav-tab active"><svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg><span>Circle</span></div>
      <div class="nav-tab" onclick="goTo('walk')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg><span>Route</span></div>
      <div class="nav-tab" onclick="goTo('comfort')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg><span>Comfort</span></div>
    </div>
  </div>

  <!-- ═══════════ COMFORT (placeholder) ═══════════ -->
  <div id="screen-comfort" class="screen">
    <div class="statusbar">
      <span class="time">9:41</span>
      <div class="icons"><div class="battery"><div class="battery-fill"></div></div></div>
    </div>
    <div style="flex:1;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;padding:40px">
      <div style="width:64px;height:64px;border-radius:20px;background:#FFF0F6;display:flex;align-items:center;justify-content:center">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg>
      </div>
      <div style="font-size:18px;font-weight:700;color:#1A1A1A;letter-spacing:-0.02em">Comfort Corner</div>
      <div style="font-size:13px;color:#999;font-weight:500;text-align:center;line-height:1.5;max-width:260px">"Glad you reached safely" — because emotional safety matters too.</div>
    </div>
    <div class="bottom-nav">
      <div class="nav-tab" onclick="goTo('home')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/></svg><span>Home</span></div>
      <div class="nav-tab" onclick="goTo('circle')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z"/></svg><span>Circle</span></div>
      <div class="nav-tab" onclick="goTo('walk')"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18M3 6h18M3 18h18"/></svg><span>Route</span></div>
      <div class="nav-tab active"><svg width="20" height="20" viewBox="0 0 24 24" fill="#FF6B9D" stroke="#FF6B9D" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z"/></svg><span>Comfort</span></div>
    </div>
  </div>

</div>

<script>
  // ── Clock ──
  function updateClock() {
    const now = new Date();
    const t = now.getHours().toString().padStart(2,'0') + ':' + now.getMinutes().toString().padStart(2,'0');
    document.querySelectorAll('.time').forEach(el => el.textContent = t);
  }
  updateClock();
  setInterval(updateClock, 10000);

  // ── Navigation ──
  const screens = { home:'screen-home', sos:'screen-sos', walk:'screen-walk', circle:'screen-circle', comfort:'screen-comfort' };
  function goTo(id) {
    Object.values(screens).forEach(s => {
      const el = document.getElementById(s);
      el.classList.remove('active','fade-in');
    });
    const target = document.getElementById(screens[id]);
    target.classList.add('active');
    // slight delay for reflow so animation triggers
    requestAnimationFrame(() => target.classList.add('fade-in'));
    // If going back to home from SOS, cancel any SOS state
    if (id === 'home') cancelSOS();
  }

  // ── SOS ──
  let sosActive = false;
  function triggerSOS() {
    sosActive = true;
    document.getElementById('screen-sos').classList.add('dark');
    document.getElementById('sos-idle').style.display = 'none';
    document.getElementById('sos-active').style.display = 'flex';
    document.getElementById('sos-nav').style.display = 'none';
  }
  function cancelSOS() {
    if (!sosActive) return;
    sosActive = false;
    document.getElementById('screen-sos').classList.remove('dark');
    document.getElementById('sos-idle').style.display = 'flex';
    document.getElementById('sos-idle').style.flexDirection = 'column';
    document.getElementById('sos-active').style.display = 'none';
    document.getElementById('sos-nav').style.display = 'flex';
  }

  // ── Check-in ──
  let checkedIn = false;
  function doCheckin() {
    checkedIn = !checkedIn;
    const card = document.getElementById('checkin-card');
    const title = document.getElementById('checkin-title');
    const sub = document.getElementById('checkin-sub');
    const btn = document.getElementById('checkin-btn');
    const icon = document.getElementById('checkin-icon-svg');
    if (checkedIn) {
      card.classList.add('confirmed');
      title.textContent = 'Check-in confirmed';
      sub.textContent = 'Timer reset';
      btn.textContent = 'Done';
      icon.innerHTML = '<path d="M5 13l4 4L19 7"/>';
    } else {
      card.classList.remove('confirmed');
      title.innerHTML = 'Check-in in <span style="color:#FF6B9D">4:32</span>';
      sub.textContent = "Tap to confirm you're okay";
      btn.textContent = "I'm okay";
      icon.innerHTML = '<path d="M12 6v6l4 2M12 2a10 10 0 100 20A10 10 0 0012 2z"/>';
    }
  }
</script>
</body>
</html>`;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(html);
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`SafMeh app running on http://0.0.0.0:${PORT}`);
});

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 5000;

const readme = fs.readFileSync(path.join(__dirname, 'README.md'), 'utf8');

function markdownToHtml(md) {
  return md
    .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
    .replace(/^### (.+)$/gm, '<h3>$1</h3>')
    .replace(/^## (.+)$/gm, '<h2>$1</h2>')
    .replace(/^# (.+)$/gm, '<h1>$1</h1>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    .replace(/`([^`]+)`/g, '<code>$1</code>')
    .replace(/```[\w]*\n([\s\S]*?)```/g, '<pre><code>$1</code></pre>')
    .replace(/^\- \[ \] (.+)$/gm, '<li class="todo">☐ $1</li>')
    .replace(/^\- \[x\] (.+)$/gm, '<li class="done">☑ $1</li>')
    .replace(/^\- (.+)$/gm, '<li>$1</li>')
    .replace(/(<li.*<\/li>\n?)+/g, '<ul>$&</ul>')
    .replace(/^\|(.+)\|$/gm, (match) => {
      const cells = match.split('|').filter((c, i) => i > 0 && i < match.split('|').length - 1);
      return '<tr>' + cells.map(c => `<td>${c.trim()}</td>`).join('') + '</tr>';
    })
    .replace(/(<tr>.*<\/tr>\n?)+/g, '<table>$&</table>')
    .replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>')
    .replace(/^---$/gm, '<hr>')
    .replace(/^> (.+)$/gm, '<blockquote>$1</blockquote>')
    .replace(/\n\n/g, '</p><p>')
    .replace(/^(?!<[hupbta]|<li|<pre|<table|<hr|<block)(.+)$/gm, '<p>$1</p>');
}

const features = [
  { icon: '🚶', title: 'Safe Walk Mode', desc: 'Silent background journey monitoring with fall detection, route deviation alerts, and automatic SOS if you don\'t check in.' },
  { icon: '🆘', title: 'Silent SOS', desc: 'Trigger emergency alerts via power button ×3, shake, volume pattern, or voice — without showing any visible activity.' },
  { icon: '🎭', title: 'Pretend Mode', desc: 'Disguise SafMeh as a Calculator, Notes, Journal, or Music Player. The real dashboard is behind your secret PIN.' },
  { icon: '📞', title: 'Fake Call', desc: 'Instantly simulate a realistic incoming call to exit uncomfortable situations. Fully customizable.' },
  { icon: '💕', title: 'Comfort Corner', desc: 'Personal notes, motivational quotes, and warm arrival messages — because emotional safety matters too.' },
  { icon: '🗺️', title: 'Route Sharing', desc: 'Share live location with trusted contacts including ETA and battery status. Auto-expires on arrival.' },
  { icon: '👥', title: 'Trusted Circle', desc: 'A private safety circle — only they receive SOS alerts, location access, and emergency recordings.' },
];

const techStack = [
  { layer: 'Framework', tech: 'Flutter 3.x (Dart)' },
  { layer: 'State Management', tech: 'flutter_bloc / Cubit' },
  { layer: 'Backend', tech: 'Firebase (Auth, Firestore, Storage, FCM)' },
  { layer: 'Maps', tech: 'Google Maps API' },
  { layer: 'Encryption', tech: 'AES-256-CBC' },
  { layer: 'Sensors', tech: 'sensors_plus, geolocator' },
  { layer: 'Audio', tech: 'record package' },
  { layer: 'Secure Storage', tech: 'flutter_secure_storage' },
];

const projectStructure = [
  { path: 'lib/cubits/', desc: 'BLoC/Cubit state management (9 feature cubits)', items: ['auth', 'battery', 'comfort', 'fake_call', 'pretend_mode', 'route_share', 'safe_walk', 'sos', 'trusted_circle'] },
  { path: 'lib/models/', desc: '11 data models with JSON serialization', items: [] },
  { path: 'lib/screens/', desc: 'UI screens organized by feature', items: ['auth', 'dashboard', 'comfort', 'fake_call', 'pretend_mode', 'route_share', 'safe_walk', 'trusted_circle'] },
  { path: 'lib/services/', desc: '20+ business logic & infrastructure services', items: ['location_service', 'encryption_service', 'sos_coordinator', 'fall_detector', 'safe_walk_coordinator'] },
  { path: 'lib/theme/', desc: 'White & pink design system (SafMehTheme)', items: [] },
  { path: 'lib/widgets/', desc: 'Reusable UI components', items: ['GlassCard', 'SoftButton', 'SosOverlay', 'CheckInPrompt'] },
];

const colors = [
  { name: 'blushPink', hex: '#FFB6C8', use: 'Primary / buttons' },
  { name: 'deepPink', hex: '#FF6B9D', use: 'Accent / active states' },
  { name: 'palePink', hex: '#FFE4EE', use: 'Card backgrounds' },
  { name: 'softWhite', hex: '#FFF8FA', use: 'App background' },
  { name: 'dustyRose', hex: '#FFCDD8', use: 'Borders / dividers' },
  { name: 'safeGreen', hex: '#A8E6CF', use: 'Safe / confirmed states' },
  { name: 'emergencyRose', hex: '#FF8FAB', use: 'Emergency (soft)' },
];

function buildHtml() {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SafMeh 🌸 — Personal Safety Companion</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      background: #FFF8FA;
      color: #333;
      line-height: 1.6;
    }
    header {
      background: linear-gradient(135deg, #FF6B9D 0%, #FFB6C8 60%, #FFE4EE 100%);
      padding: 60px 40px 80px;
      text-align: center;
      position: relative;
      overflow: hidden;
    }
    header::before {
      content: '';
      position: absolute;
      top: -50%;
      left: -50%;
      width: 200%;
      height: 200%;
      background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 60%);
    }
    header h1 {
      font-size: 3rem;
      color: white;
      text-shadow: 0 2px 20px rgba(0,0,0,0.15);
      margin-bottom: 12px;
      position: relative;
    }
    header .tagline {
      font-size: 1.2rem;
      color: rgba(255,255,255,0.92);
      font-style: italic;
      max-width: 600px;
      margin: 0 auto 24px;
      position: relative;
    }
    .badge-row {
      display: flex;
      justify-content: center;
      gap: 12px;
      flex-wrap: wrap;
      position: relative;
    }
    .badge {
      background: rgba(255,255,255,0.3);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,0.5);
      border-radius: 20px;
      padding: 6px 16px;
      font-size: 0.85rem;
      color: white;
      font-weight: 600;
    }
    .container {
      max-width: 1100px;
      margin: 0 auto;
      padding: 0 24px;
    }
    section {
      padding: 60px 0;
    }
    section:nth-child(even) {
      background: #fff;
    }
    h2 {
      font-size: 1.9rem;
      color: #FF6B9D;
      margin-bottom: 8px;
    }
    .section-subtitle {
      color: #888;
      margin-bottom: 36px;
      font-size: 1rem;
    }
    .features-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 20px;
    }
    .feature-card {
      background: #FFF8FA;
      border: 1.5px solid #FFCDD8;
      border-radius: 16px;
      padding: 24px;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .feature-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 30px rgba(255,107,157,0.15);
    }
    .feature-icon {
      font-size: 2rem;
      margin-bottom: 12px;
    }
    .feature-card h3 {
      font-size: 1.1rem;
      color: #FF6B9D;
      margin-bottom: 8px;
    }
    .feature-card p {
      color: #666;
      font-size: 0.9rem;
    }
    .tech-table {
      width: 100%;
      border-collapse: collapse;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 20px rgba(255,107,157,0.1);
    }
    .tech-table th {
      background: linear-gradient(90deg, #FF6B9D, #FFB6C8);
      color: white;
      padding: 14px 20px;
      text-align: left;
      font-size: 0.9rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }
    .tech-table td {
      padding: 12px 20px;
      border-bottom: 1px solid #FFE4EE;
      font-size: 0.9rem;
    }
    .tech-table tr:last-child td { border-bottom: none; }
    .tech-table tr:nth-child(even) td { background: #FFF8FA; }
    .tech-table td:first-child { color: #FF6B9D; font-weight: 600; }
    .structure-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 16px;
    }
    .structure-card {
      background: white;
      border: 1.5px solid #FFCDD8;
      border-radius: 12px;
      padding: 20px;
    }
    .structure-card .path {
      font-family: 'Courier New', monospace;
      font-size: 0.85rem;
      background: #FFE4EE;
      color: #FF6B9D;
      padding: 4px 10px;
      border-radius: 6px;
      display: inline-block;
      margin-bottom: 8px;
    }
    .structure-card .desc {
      color: #666;
      font-size: 0.85rem;
      margin-bottom: 10px;
    }
    .structure-card .items {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
    }
    .structure-card .item-chip {
      background: #FFE4EE;
      color: #FF6B9D;
      border-radius: 10px;
      padding: 2px 10px;
      font-size: 0.78rem;
    }
    .colors-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 16px;
    }
    .color-swatch {
      border-radius: 12px;
      padding: 16px;
      width: 150px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.08);
    }
    .color-swatch .swatch-name {
      font-weight: 700;
      font-size: 0.85rem;
      margin-bottom: 4px;
    }
    .color-swatch .swatch-hex {
      font-family: 'Courier New', monospace;
      font-size: 0.78rem;
      opacity: 0.7;
      margin-bottom: 4px;
    }
    .color-swatch .swatch-use {
      font-size: 0.75rem;
      opacity: 0.8;
    }
    .stats-row {
      display: flex;
      justify-content: center;
      gap: 40px;
      flex-wrap: wrap;
      background: linear-gradient(135deg, #FF6B9D, #FFB6C8);
      padding: 40px;
      border-radius: 20px;
      margin-bottom: 40px;
    }
    .stat {
      text-align: center;
      color: white;
    }
    .stat .num {
      font-size: 2.5rem;
      font-weight: 800;
    }
    .stat .label {
      font-size: 0.9rem;
      opacity: 0.85;
    }
    .setup-code {
      background: #1a1a2e;
      color: #e2e8f0;
      border-radius: 12px;
      padding: 24px;
      font-family: 'Courier New', monospace;
      font-size: 0.9rem;
      line-height: 1.8;
      overflow-x: auto;
    }
    .setup-code .comment { color: #A8E6CF; }
    .setup-code .cmd { color: #FFB6C8; }
    footer {
      background: linear-gradient(135deg, #FF6B9D, #FFB6C8);
      text-align: center;
      padding: 40px;
      color: white;
    }
    footer p { opacity: 0.9; margin-bottom: 8px; }
    footer .made-with { font-size: 1.1rem; font-weight: 600; }
    @media (max-width: 600px) {
      header h1 { font-size: 2rem; }
      .stats-row { gap: 24px; }
    }
  </style>
</head>
<body>

<header>
  <h1>SafMeh 🌸</h1>
  <p class="tagline">"Even when no one is physically there, someone still cares about your safety."</p>
  <div class="badge-row">
    <span class="badge">Flutter 3.x</span>
    <span class="badge">Dart</span>
    <span class="badge">Firebase Ready</span>
    <span class="badge">BLoC/Cubit</span>
    <span class="badge">177 Tests ✓</span>
    <span class="badge">Mock Mode</span>
  </div>
</header>

<div style="background:#fff; padding: 40px 0;">
  <div class="container">
    <div class="stats-row">
      <div class="stat"><div class="num">9</div><div class="label">Feature Cubits</div></div>
      <div class="stat"><div class="num">177</div><div class="label">Tests Passing</div></div>
      <div class="stat"><div class="num">7</div><div class="label">Core Features</div></div>
      <div class="stat"><div class="num">20+</div><div class="label">Service Files</div></div>
      <div class="stat"><div class="num">11</div><div class="label">Data Models</div></div>
    </div>
    <p style="text-align:center;color:#888;max-width:700px;margin:0 auto;">
      SafMeh is a personal safety companion Flutter app — designed with a calm white-and-pink aesthetic 
      to provide quiet protection and emotional reassurance rather than a high-stress emergency interface.
    </p>
  </div>
</div>

<div style="background:#FFF8FA; padding: 60px 0;">
  <div class="container">
    <h2>✨ Features</h2>
    <p class="section-subtitle">Seven core features covering safety, comfort, and emergency response</p>
    <div class="features-grid">
      ${features.map(f => `
      <div class="feature-card">
        <div class="feature-icon">${f.icon}</div>
        <h3>${f.title}</h3>
        <p>${f.desc}</p>
      </div>`).join('')}
    </div>
  </div>
</div>

<div style="background:#fff; padding: 60px 0;">
  <div class="container">
    <h2>🛠️ Tech Stack</h2>
    <p class="section-subtitle">Built on Flutter with Firebase backend, ready to swap from mock to production</p>
    <table class="tech-table">
      <thead><tr><th>Layer</th><th>Technology</th></tr></thead>
      <tbody>
        ${techStack.map(t => `<tr><td>${t.layer}</td><td>${t.tech}</td></tr>`).join('')}
      </tbody>
    </table>
  </div>
</div>

<div style="background:#FFF8FA; padding: 60px 0;">
  <div class="container">
    <h2>🏗️ Architecture</h2>
    <p class="section-subtitle">Clean feature-based layout with BLoC/Cubit pattern and mock-to-real repository swap</p>
    <div class="structure-grid">
      ${projectStructure.map(s => `
      <div class="structure-card">
        <span class="path">${s.path}</span>
        <p class="desc">${s.desc}</p>
        ${s.items.length ? `<div class="items">${s.items.map(i => `<span class="item-chip">${i}</span>`).join('')}</div>` : ''}
      </div>`).join('')}
    </div>
  </div>
</div>

<div style="background:#fff; padding: 60px 0;">
  <div class="container">
    <h2>🎨 Design System</h2>
    <p class="section-subtitle">Warm white-and-pink palette — safe and calming, never alarming</p>
    <div class="colors-grid">
      ${colors.map(c => `
      <div class="color-swatch" style="background:${c.hex};">
        <div class="swatch-name">${c.name}</div>
        <div class="swatch-hex">${c.hex}</div>
        <div class="swatch-use">${c.use}</div>
      </div>`).join('')}
    </div>
    <p style="margin-top:20px;color:#888;font-size:0.9rem;">Typography: <strong>Nunito</strong> — rounded, friendly, warm.</p>
  </div>
</div>

<div style="background:#FFF8FA; padding: 60px 0;">
  <div class="container">
    <h2>🚀 Getting Started</h2>
    <p class="section-subtitle">Runs in mock mode out of the box — no Firebase configuration needed</p>
    <div class="setup-code">
<span class="comment"># Clone and install</span>
<span class="cmd">git clone https://github.com/Anadi99/safmeh.git</span>
<span class="cmd">cd safmeh</span>
<span class="cmd">flutter pub get</span>

<span class="comment"># Run in mock mode (no Firebase required)</span>
<span class="cmd">flutter run</span>

<span class="comment"># Run the test suite</span>
<span class="cmd">flutter test</span>
<span class="comment"># → 177 tests, 0 failures</span>
    </div>
    <p style="margin-top:20px;color:#888;font-size:0.9rem;">
      Requires: Flutter 3.x, Android Studio or VS Code, Android device or emulator (API 21+)
    </p>
  </div>
</div>

<footer>
  <p class="made-with">Made with 🌸 and Flutter</p>
  <p>SafMeh — Personal Safety Companion App</p>
  <p style="opacity:0.7;font-size:0.85rem;margin-top:8px;">MIT License · Flutter 3.x · Dart · Firebase Ready</p>
</footer>

</body>
</html>`;
}

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(buildHtml());
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`SafMeh project viewer running on http://0.0.0.0:${PORT}`);
});

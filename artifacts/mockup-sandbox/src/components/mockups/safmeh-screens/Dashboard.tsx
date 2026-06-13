export function Dashboard() {
  return (
    <div style={{ fontFamily: "'Nunito', sans-serif", background: "#FFF8FA", minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <div style={{ width: 390, height: 844, background: "#FFF8FA", borderRadius: 40, overflow: "hidden", position: "relative", display: "flex", flexDirection: "column", boxShadow: "0 30px 80px rgba(255,107,157,0.18)" }}>

        {/* Status bar */}
        <div style={{ background: "#FFF8FA", padding: "14px 24px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 13, fontWeight: 700, color: "#333" }}>9:41</span>
          <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
            <svg width="16" height="12" viewBox="0 0 16 12" fill="none"><rect x="0" y="3" width="3" height="9" rx="1" fill="#333"/><rect x="4.5" y="2" width="3" height="10" rx="1" fill="#333"/><rect x="9" y="0" width="3" height="12" rx="1" fill="#333"/><rect x="13.5" y="0" width="2.5" height="12" rx="1" fill="#ddd"/></svg>
            <svg width="16" height="12" viewBox="0 0 16 12" fill="none"><path d="M8 2.5C10.5 2.5 12.7 3.6 14.2 5.3L15.5 4C13.7 2 11 1 8 1C5 1 2.3 2 0.5 4L1.8 5.3C3.3 3.6 5.5 2.5 8 2.5Z" fill="#333"/><path d="M8 5.5C9.7 5.5 11.2 6.2 12.3 7.3L13.6 6C12.1 4.6 10.2 3.8 8 3.8C5.8 3.8 3.9 4.6 2.4 6L3.7 7.3C4.8 6.2 6.3 5.5 8 5.5Z" fill="#333"/><circle cx="8" cy="10" r="1.5" fill="#333"/></svg>
            <div style={{ width: 25, height: 12, border: "1.5px solid #333", borderRadius: 3, padding: "1px 2px", display: "flex", alignItems: "center" }}>
              <div style={{ width: "80%", height: "100%", background: "#4CAF50", borderRadius: 1.5 }} />
            </div>
          </div>
        </div>

        {/* Header */}
        <div style={{ padding: "18px 24px 0" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
            <div>
              <p style={{ margin: 0, fontSize: 13, color: "#FF6B9D", fontWeight: 600 }}>Good evening 🌸</p>
              <h1 style={{ margin: "2px 0 0", fontSize: 22, fontWeight: 800, color: "#2D2D2D" }}>Sara's Dashboard</h1>
            </div>
            <div style={{ width: 42, height: 42, borderRadius: 21, background: "linear-gradient(135deg,#FF6B9D,#FFB6C8)", display: "flex", alignItems: "center", justifyContent: "center", boxShadow: "0 4px 12px rgba(255,107,157,0.3)" }}>
              <span style={{ fontSize: 20 }}>👤</span>
            </div>
          </div>

          {/* Safe status pill */}
          <div style={{ marginTop: 14, background: "#A8E6CF", borderRadius: 20, padding: "8px 16px", display: "inline-flex", alignItems: "center", gap: 8 }}>
            <div style={{ width: 8, height: 8, borderRadius: 4, background: "#2E7D32" }} />
            <span style={{ fontSize: 13, fontWeight: 700, color: "#2E7D32" }}>You are Safe · Trusted Circle Active</span>
          </div>
        </div>

        {/* Quick actions grid */}
        <div style={{ padding: "18px 20px 0", display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
          {[
            { icon: "🚶", label: "Safe Walk", sub: "Start journey", color: "#FFE4EE", accent: "#FF6B9D" },
            { icon: "🆘", label: "Silent SOS", sub: "Emergency help", color: "#FFD5E5", accent: "#FF4B8B" },
            { icon: "🎭", label: "Pretend Mode", sub: "Hide the app", color: "#E8F5FF", accent: "#5B9BD5" },
            { icon: "📞", label: "Fake Call", sub: "Exit situation", color: "#FFF0D9", accent: "#E87A00" },
          ].map((item) => (
            <div key={item.label} style={{ background: item.color, borderRadius: 18, padding: "16px 14px", cursor: "pointer", boxShadow: "0 2px 8px rgba(0,0,0,0.06)" }}>
              <div style={{ fontSize: 26, marginBottom: 8 }}>{item.icon}</div>
              <p style={{ margin: 0, fontSize: 14, fontWeight: 800, color: "#2D2D2D" }}>{item.label}</p>
              <p style={{ margin: "2px 0 0", fontSize: 11, color: "#888" }}>{item.sub}</p>
            </div>
          ))}
        </div>

        {/* Recent activity */}
        <div style={{ padding: "20px 20px 0" }}>
          <h2 style={{ margin: 0, fontSize: 15, fontWeight: 800, color: "#2D2D2D" }}>Recent Activity</h2>
          <div style={{ marginTop: 10, display: "flex", flexDirection: "column", gap: 8 }}>
            {[
              { icon: "🚶", text: "Safe Walk completed", time: "2h ago", color: "#E8F5E9" },
              { icon: "📍", text: "Location shared with Mum", time: "5h ago", color: "#FFF3E0" },
              { icon: "💕", text: "Comfort message received", time: "Yesterday", color: "#FCE4EC" },
            ].map((item) => (
              <div key={item.text} style={{ background: "#fff", borderRadius: 14, padding: "12px 14px", display: "flex", alignItems: "center", gap: 12, boxShadow: "0 1px 6px rgba(0,0,0,0.06)" }}>
                <div style={{ width: 36, height: 36, borderRadius: 12, background: item.color, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 18 }}>{item.icon}</div>
                <div style={{ flex: 1 }}>
                  <p style={{ margin: 0, fontSize: 13, fontWeight: 700, color: "#2D2D2D" }}>{item.text}</p>
                  <p style={{ margin: 0, fontSize: 11, color: "#aaa" }}>{item.time}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Bottom nav */}
        <div style={{ marginTop: "auto", background: "#fff", borderTop: "1px solid #FFE4EE", padding: "10px 0 20px", display: "flex", justifyContent: "space-around" }}>
          {[
            { icon: "🏠", label: "Home", active: true },
            { icon: "👥", label: "Circle" },
            { icon: "🗺️", label: "Route" },
            { icon: "💕", label: "Comfort" },
          ].map((tab) => (
            <div key={tab.label} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 3, opacity: tab.active ? 1 : 0.45 }}>
              <span style={{ fontSize: 22 }}>{tab.icon}</span>
              <span style={{ fontSize: 10, fontWeight: tab.active ? 800 : 600, color: tab.active ? "#FF6B9D" : "#aaa" }}>{tab.label}</span>
              {tab.active && <div style={{ width: 4, height: 4, borderRadius: 2, background: "#FF6B9D" }} />}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

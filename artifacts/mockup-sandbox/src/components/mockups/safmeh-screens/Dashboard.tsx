const FONT_IMPORT = "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap";

export function Dashboard() {
  return (
    <div style={{ fontFamily: "'Space Grotesk', sans-serif", background: "#FFF8FA", minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <link rel="stylesheet" href={FONT_IMPORT} />
      <div style={{ width: 390, height: 844, background: "#FFF8FA", borderRadius: 40, overflow: "hidden", display: "flex", flexDirection: "column", boxShadow: "0 30px 80px rgba(255,107,157,0.18)" }}>

        {/* Status bar */}
        <div style={{ padding: "16px 24px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: "#333", letterSpacing: "0.02em" }}>9:41</span>
          <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
            <svg width="16" height="12" viewBox="0 0 16 12" fill="none"><rect x="0" y="3" width="3" height="9" rx="1" fill="#333"/><rect x="4.5" y="2" width="3" height="10" rx="1" fill="#333"/><rect x="9" y="0" width="3" height="12" rx="1" fill="#333"/><rect x="13.5" y="0" width="2.5" height="12" rx="1" fill="#ddd"/></svg>
            <div style={{ width: 25, height: 12, border: "1.5px solid #333", borderRadius: 3, padding: "1px 2px", display: "flex", alignItems: "center" }}>
              <div style={{ width: "80%", height: "100%", background: "#4CAF50", borderRadius: 1.5 }} />
            </div>
          </div>
        </div>

        {/* Header */}
        <div style={{ padding: "20px 24px 0" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
            <div>
              <p style={{ margin: 0, fontSize: 12, color: "#FF6B9D", fontWeight: 600, letterSpacing: "0.08em", textTransform: "uppercase" }}>Good evening</p>
              <h1 style={{ margin: "4px 0 0", fontSize: 24, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.02em" }}>Mehak's Dashboard</h1>
            </div>
            <div style={{ width: 40, height: 40, borderRadius: 20, background: "linear-gradient(135deg,#FF6B9D,#FFB6C8)", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
            </div>
          </div>

          {/* Safe status pill */}
          <div style={{ marginTop: 14, background: "#EDFAF3", borderRadius: 10, padding: "8px 14px", display: "inline-flex", alignItems: "center", gap: 8, border: "1px solid #C3EDD5" }}>
            <div style={{ width: 7, height: 7, borderRadius: "50%", background: "#22C55E" }} />
            <span style={{ fontSize: 12, fontWeight: 600, color: "#166534", letterSpacing: "0.01em" }}>Safe · Trusted Circle Active</span>
          </div>
        </div>

        {/* Quick actions grid */}
        <div style={{ padding: "20px 20px 0", display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12 }}>
          {[
            { icon: "→", label: "Safe Walk", sub: "Start journey", color: "#FFE4EE", accent: "#FF6B9D", svgPath: "M5 12h14M13 6l6 6-6 6" },
            { icon: "!", label: "Silent SOS", sub: "Emergency help", color: "#FFD5E5", accent: "#FF4B8B", svgPath: "M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z" },
            { icon: "◎", label: "Pretend Mode", sub: "Hide the app", color: "#EEF4FF", accent: "#5B9BD5", svgPath: "M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8zM12 12a3 3 0 100-6 3 3 0 000 6z" },
            { icon: "↗", label: "Fake Call", sub: "Exit situation", color: "#FFF4E5", accent: "#E87A00", svgPath: "M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07A19.5 19.5 0 013.07 9.8a19.79 19.79 0 01-3.07-8.67A2 2 0 012 1h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L6.91 8.1a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 15l-.08 1.92z" },
          ].map((item) => (
            <div key={item.label} style={{ background: item.color, borderRadius: 18, padding: "18px 16px", cursor: "pointer" }}>
              <div style={{ width: 34, height: 34, borderRadius: 10, background: item.accent, display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 12 }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                  <path d={item.svgPath} />
                </svg>
              </div>
              <p style={{ margin: 0, fontSize: 14, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.01em" }}>{item.label}</p>
              <p style={{ margin: "3px 0 0", fontSize: 11, color: "#888", fontWeight: 500 }}>{item.sub}</p>
            </div>
          ))}
        </div>

        {/* Recent activity */}
        <div style={{ padding: "22px 20px 0" }}>
          <h2 style={{ margin: "0 0 12px", fontSize: 14, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.01em" }}>Recent Activity</h2>
          <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
            {[
              { label: "Safe Walk completed", time: "2h ago", bg: "#E8F5E9", color: "#166534", dot: "#22C55E" },
              { label: "Location shared with Mum", time: "5h ago", bg: "#FFF4E5", color: "#92400E", dot: "#F59E0B" },
              { label: "Comfort message received", time: "Yesterday", bg: "#FFF0F6", color: "#9D174D", dot: "#FF6B9D" },
            ].map((item) => (
              <div key={item.label} style={{ background: "#fff", borderRadius: 14, padding: "12px 14px", display: "flex", alignItems: "center", gap: 12, border: "1px solid #F3F3F3" }}>
                <div style={{ width: 8, height: 8, borderRadius: "50%", background: item.dot, flexShrink: 0 }} />
                <div style={{ flex: 1 }}>
                  <p style={{ margin: 0, fontSize: 13, fontWeight: 600, color: "#1A1A1A" }}>{item.label}</p>
                </div>
                <span style={{ fontSize: 11, color: "#bbb", fontWeight: 500, whiteSpace: "nowrap" }}>{item.time}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Bottom nav */}
        <div style={{ marginTop: "auto", background: "#fff", borderTop: "1px solid #F3EEF0", padding: "10px 0 24px", display: "flex", justifyContent: "space-around" }}>
          {[
            { label: "Home", active: true, path: "M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" },
            { label: "Circle", path: "M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8zM23 21v-2a4 4 0 00-3-3.87M16 3.13a4 4 0 010 7.75" },
            { label: "Route", path: "M3 12h18M3 6h18M3 18h18" },
            { label: "Comfort", path: "M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z" },
          ].map((tab) => (
            <div key={tab.label} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 4 }}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill={tab.active ? "#FF6B9D" : "none"} stroke={tab.active ? "#FF6B9D" : "#C0B0B5"} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d={tab.path} />
              </svg>
              <span style={{ fontSize: 10, fontWeight: tab.active ? 700 : 500, color: tab.active ? "#FF6B9D" : "#C0B0B5", letterSpacing: "0.02em" }}>{tab.label}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

import { useState } from "react";

export function SafeWalk() {
  const [active, setActive] = useState(true);

  return (
    <div style={{ fontFamily: "'Nunito', sans-serif", background: "#FFF8FA", minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <div style={{ width: 390, height: 844, background: "#FFF8FA", borderRadius: 40, overflow: "hidden", position: "relative", display: "flex", flexDirection: "column", boxShadow: "0 30px 80px rgba(255,107,157,0.18)" }}>

        {/* Status bar */}
        <div style={{ background: "#FFF8FA", padding: "14px 24px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 13, fontWeight: 700, color: "#333" }}>9:41</span>
          <div style={{ width: 25, height: 12, border: "1.5px solid #333", borderRadius: 3, padding: "1px 2px", display: "flex", alignItems: "center" }}>
            <div style={{ width: "80%", height: "100%", background: "#4CAF50", borderRadius: 1.5 }} />
          </div>
        </div>

        {/* Header */}
        <div style={{ padding: "16px 24px 0" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
            <div style={{ width: 32, height: 32, borderRadius: 16, background: "#FFE4EE", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <span style={{ fontSize: 16 }}>←</span>
            </div>
            <h1 style={{ margin: 0, fontSize: 20, fontWeight: 800, color: "#2D2D2D" }}>Safe Walk</h1>
          </div>
        </div>

        {/* Map placeholder */}
        <div style={{ margin: "16px 20px 0", borderRadius: 20, overflow: "hidden", height: 200, background: "linear-gradient(135deg, #E8F5E9 0%, #C8E6C9 40%, #A5D6A7 100%)", position: "relative", flexShrink: 0 }}>
          {/* Fake map elements */}
          <div style={{ position: "absolute", inset: 0, backgroundImage: "repeating-linear-gradient(0deg, rgba(255,255,255,0.15) 0px, rgba(255,255,255,0.15) 1px, transparent 1px, transparent 40px), repeating-linear-gradient(90deg, rgba(255,255,255,0.15) 0px, rgba(255,255,255,0.15) 1px, transparent 1px, transparent 40px)" }} />
          {/* Roads */}
          <div style={{ position: "absolute", top: "50%", left: 0, right: 0, height: 8, background: "rgba(255,255,255,0.5)", transform: "translateY(-50%)" }} />
          <div style={{ position: "absolute", left: "40%", top: 0, bottom: 0, width: 6, background: "rgba(255,255,255,0.4)" }} />
          {/* Route line */}
          <svg style={{ position: "absolute", inset: 0 }} width="350" height="200">
            <path d="M 40 160 Q 80 80 140 100 Q 200 120 260 60 Q 300 30 320 40" stroke="#FF6B9D" strokeWidth="4" fill="none" strokeDasharray="8 4" strokeLinecap="round"/>
          </svg>
          {/* Location dot */}
          <div style={{ position: "absolute", left: "calc(40% - 12px)", top: "calc(50% - 12px)", width: 24, height: 24, borderRadius: 12, background: "#FF6B9D", border: "3px solid #fff", boxShadow: "0 0 0 6px rgba(255,107,157,0.25)" }} />
          {/* Destination pin */}
          <div style={{ position: "absolute", right: 32, top: 28, fontSize: 28 }}>📍</div>
          {/* Map label */}
          <div style={{ position: "absolute", bottom: 10, left: 12, background: "rgba(255,255,255,0.8)", borderRadius: 8, padding: "4px 10px" }}>
            <span style={{ fontSize: 11, fontWeight: 700, color: "#2D2D2D" }}>Live tracking active</span>
          </div>
        </div>

        {/* Journey stats */}
        <div style={{ margin: "14px 20px 0", background: "#fff", borderRadius: 18, padding: "16px", boxShadow: "0 2px 10px rgba(0,0,0,0.06)" }}>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            {[
              { value: "1.2 km", label: "Distance left" },
              { value: "14 min", label: "ETA" },
              { value: "🟢", label: "Status" },
            ].map((stat) => (
              <div key={stat.label} style={{ textAlign: "center" }}>
                <p style={{ margin: 0, fontSize: 18, fontWeight: 800, color: "#2D2D2D" }}>{stat.value}</p>
                <p style={{ margin: "2px 0 0", fontSize: 11, color: "#aaa" }}>{stat.label}</p>
              </div>
            ))}
          </div>
          {/* Progress bar */}
          <div style={{ marginTop: 14, height: 6, background: "#FFE4EE", borderRadius: 3, overflow: "hidden" }}>
            <div style={{ width: "62%", height: "100%", background: "linear-gradient(90deg, #FF6B9D, #FFB6C8)", borderRadius: 3 }} />
          </div>
          <div style={{ marginTop: 6, display: "flex", justifyContent: "space-between" }}>
            <span style={{ fontSize: 11, color: "#FF6B9D", fontWeight: 700 }}>Home</span>
            <span style={{ fontSize: 11, color: "#aaa" }}>Sara's Office</span>
          </div>
        </div>

        {/* Check-in timer */}
        <div style={{ margin: "14px 20px 0", background: active ? "#FFE4EE" : "#E8F5E9", borderRadius: 18, padding: "14px 16px", display: "flex", alignItems: "center", gap: 14 }}>
          <div style={{ width: 46, height: 46, borderRadius: 23, background: active ? "#FF6B9D" : "#A8E6CF", display: "flex", alignItems: "center", justifyContent: "center" }}>
            <span style={{ fontSize: 22 }}>{active ? "⏰" : "✓"}</span>
          </div>
          <div style={{ flex: 1 }}>
            <p style={{ margin: 0, fontSize: 14, fontWeight: 800, color: "#2D2D2D" }}>Check-in due in <span style={{ color: "#FF6B9D" }}>4:32</span></p>
            <p style={{ margin: "2px 0 0", fontSize: 12, color: "#888" }}>Tap "I'm okay" to reset timer</p>
          </div>
          <button
            onClick={() => setActive(!active)}
            style={{ background: "#FF6B9D", border: "none", borderRadius: 12, padding: "8px 14px", color: "#fff", fontSize: 12, fontWeight: 800, cursor: "pointer" }}
          >
            I'm okay
          </button>
        </div>

        {/* Shared with */}
        <div style={{ margin: "14px 20px 0" }}>
          <p style={{ margin: "0 0 8px", fontSize: 13, fontWeight: 800, color: "#2D2D2D" }}>Sharing with</p>
          <div style={{ display: "flex", gap: 10 }}>
            {["Mum", "Riya", "+1"].map((name, i) => (
              <div key={name} style={{ height: 34, borderRadius: 17, background: i < 2 ? "#FFE4EE" : "#f0f0f0", padding: "0 14px", display: "flex", alignItems: "center", gap: 6 }}>
                <div style={{ width: 20, height: 20, borderRadius: 10, background: i < 2 ? "#FF6B9D" : "#ccc", display: "flex", alignItems: "center", justifyContent: "center" }}>
                  <span style={{ fontSize: 12 }}>{i < 2 ? "👤" : "+"}</span>
                </div>
                <span style={{ fontSize: 12, fontWeight: 700, color: i < 2 ? "#FF6B9D" : "#888" }}>{name}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Stop button */}
        <div style={{ padding: "16px 20px 0", marginTop: "auto" }}>
          <button style={{ width: "100%", background: "#fff", border: "2px solid #FFB6C8", borderRadius: 18, padding: "14px", color: "#FF6B9D", fontSize: 15, fontWeight: 800, cursor: "pointer" }}>
            ✓ Arrived Safely
          </button>
        </div>

        {/* Bottom nav */}
        <div style={{ background: "#fff", borderTop: "1px solid #FFE4EE", padding: "10px 0 20px", display: "flex", justifyContent: "space-around", marginTop: 14 }}>
          {[
            { icon: "🏠", label: "Home" },
            { icon: "👥", label: "Circle" },
            { icon: "🗺️", label: "Route", active: true },
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

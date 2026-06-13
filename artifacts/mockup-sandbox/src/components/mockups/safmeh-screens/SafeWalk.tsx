import { useState } from "react";

const FONT_IMPORT = "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap";

export function SafeWalk() {
  const [checkedIn, setCheckedIn] = useState(false);

  return (
    <div style={{ fontFamily: "'Space Grotesk', sans-serif", background: "#FFF8FA", minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center" }}>
      <link rel="stylesheet" href={FONT_IMPORT} />
      <div style={{ width: 390, height: 844, background: "#FFF8FA", borderRadius: 40, overflow: "hidden", display: "flex", flexDirection: "column", boxShadow: "0 30px 80px rgba(255,107,157,0.18)" }}>

        {/* Status bar */}
        <div style={{ padding: "16px 24px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: "#333", letterSpacing: "0.02em" }}>9:41</span>
          <div style={{ width: 25, height: 12, border: "1.5px solid #333", borderRadius: 3, padding: "1px 2px", display: "flex", alignItems: "center" }}>
            <div style={{ width: "80%", height: "100%", background: "#4CAF50", borderRadius: 1.5 }} />
          </div>
        </div>

        {/* Header */}
        <div style={{ padding: "18px 24px 0", display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ width: 32, height: 32, borderRadius: 12, background: "#FFE4EE", display: "flex", alignItems: "center", justifyContent: "center" }}>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" strokeWidth="2.5" strokeLinecap="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
          </div>
          <div>
            <h1 style={{ margin: 0, fontSize: 18, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.02em" }}>Safe Walk</h1>
            <p style={{ margin: 0, fontSize: 11, color: "#22C55E", fontWeight: 600 }}>Tracking active</p>
          </div>
        </div>

        {/* Map */}
        <div style={{ margin: "14px 20px 0", borderRadius: 20, overflow: "hidden", height: 186, background: "linear-gradient(160deg, #E0F2E9 0%, #C8E6C9 60%, #B2DFDB 100%)", position: "relative", flexShrink: 0 }}>
          <div style={{ position: "absolute", inset: 0, backgroundImage: "repeating-linear-gradient(0deg, rgba(255,255,255,0.12) 0px, rgba(255,255,255,0.12) 1px, transparent 1px, transparent 36px), repeating-linear-gradient(90deg, rgba(255,255,255,0.12) 0px, rgba(255,255,255,0.12) 1px, transparent 1px, transparent 36px)" }} />
          <div style={{ position: "absolute", top: "50%", left: 0, right: 0, height: 7, background: "rgba(255,255,255,0.45)", transform: "translateY(-50%)" }} />
          <div style={{ position: "absolute", left: "38%", top: 0, bottom: 0, width: 5, background: "rgba(255,255,255,0.3)" }} />
          <svg style={{ position: "absolute", inset: 0 }} width="350" height="186">
            <path d="M 36 150 Q 80 75 138 92 Q 196 110 252 56 Q 292 26 318 38" stroke="#FF6B9D" strokeWidth="3.5" fill="none" strokeDasharray="7 4" strokeLinecap="round"/>
          </svg>
          {/* Live dot */}
          <div style={{ position: "absolute", left: "calc(38% - 10px)", top: "calc(50% - 10px)", width: 20, height: 20, borderRadius: "50%", background: "#FF6B9D", border: "2.5px solid #fff", boxShadow: "0 0 0 5px rgba(255,107,157,0.22)" }} />
          {/* Destination */}
          <div style={{ position: "absolute", right: 28, top: 24 }}>
            <div style={{ width: 20, height: 20, borderRadius: "50%", background: "#fff", border: "2px solid #FF6B9D", display: "flex", alignItems: "center", justifyContent: "center" }}>
              <div style={{ width: 6, height: 6, borderRadius: "50%", background: "#FF6B9D" }} />
            </div>
          </div>
          {/* Badge */}
          <div style={{ position: "absolute", bottom: 10, left: 12, background: "rgba(255,255,255,0.88)", borderRadius: 8, padding: "4px 10px", backdropFilter: "blur(4px)" }}>
            <span style={{ fontSize: 11, fontWeight: 600, color: "#1A1A1A" }}>Live · GPS active</span>
          </div>
        </div>

        {/* Journey stats */}
        <div style={{ margin: "12px 20px 0", background: "#fff", borderRadius: 18, padding: "16px", border: "1px solid #F3EEF0" }}>
          <div style={{ display: "flex", justifyContent: "space-between" }}>
            {[
              { value: "1.2 km", label: "Remaining" },
              { value: "14 min", label: "ETA" },
              { value: "Safe", label: "Status" },
            ].map((stat) => (
              <div key={stat.label} style={{ textAlign: "center" }}>
                <p style={{ margin: 0, fontSize: 17, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.02em" }}>{stat.value}</p>
                <p style={{ margin: "2px 0 0", fontSize: 11, color: "#bbb", fontWeight: 500 }}>{stat.label}</p>
              </div>
            ))}
          </div>
          <div style={{ marginTop: 14, height: 5, background: "#F3EEF0", borderRadius: 3, overflow: "hidden" }}>
            <div style={{ width: "62%", height: "100%", background: "linear-gradient(90deg, #FF6B9D, #FFB6C8)", borderRadius: 3 }} />
          </div>
          <div style={{ marginTop: 6, display: "flex", justifyContent: "space-between" }}>
            <span style={{ fontSize: 11, color: "#FF6B9D", fontWeight: 600 }}>Home</span>
            <span style={{ fontSize: 11, color: "#bbb", fontWeight: 500 }}>Sara's Office</span>
          </div>
        </div>

        {/* Check-in */}
        <div style={{ margin: "12px 20px 0", background: checkedIn ? "#EDFAF3" : "#FFF0F6", borderRadius: 16, padding: "14px 16px", display: "flex", alignItems: "center", gap: 12, border: `1px solid ${checkedIn ? "#C3EDD5" : "#FFD5E5"}` }}>
          <div style={{ width: 40, height: 40, borderRadius: 12, background: checkedIn ? "#22C55E" : "#FF6B9D", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.5" strokeLinecap="round">
              {checkedIn ? <path d="M5 13l4 4L19 7"/> : <path d="M12 6v6l4 2M12 2a10 10 0 100 20A10 10 0 0012 2z"/>}
            </svg>
          </div>
          <div style={{ flex: 1 }}>
            <p style={{ margin: 0, fontSize: 13, fontWeight: 700, color: "#1A1A1A" }}>
              {checkedIn ? "Check-in confirmed" : <>Check-in in <span style={{ color: "#FF6B9D" }}>4:32</span></>}
            </p>
            <p style={{ margin: "2px 0 0", fontSize: 11, color: "#999", fontWeight: 500 }}>{checkedIn ? "Timer reset" : "Tap to confirm you're okay"}</p>
          </div>
          <button
            onClick={() => setCheckedIn(!checkedIn)}
            style={{ background: checkedIn ? "#22C55E" : "#FF6B9D", border: "none", borderRadius: 10, padding: "8px 14px", color: "#fff", fontSize: 12, fontWeight: 700, cursor: "pointer", letterSpacing: "0.02em" }}
          >
            {checkedIn ? "Done" : "I'm okay"}
          </button>
        </div>

        {/* Sharing with */}
        <div style={{ padding: "14px 20px 0" }}>
          <p style={{ margin: "0 0 8px", fontSize: 13, fontWeight: 700, color: "#1A1A1A" }}>Sharing with</p>
          <div style={{ display: "flex", gap: 8 }}>
            {["Mum", "Riya", "+1"].map((name, i) => (
              <div key={name} style={{ height: 32, borderRadius: 10, background: i < 2 ? "#FFE4EE" : "#F3F3F3", padding: "0 12px", display: "flex", alignItems: "center", gap: 6 }}>
                <div style={{ width: 16, height: 16, borderRadius: "50%", background: i < 2 ? "#FF6B9D" : "#ccc" }} />
                <span style={{ fontSize: 12, fontWeight: 600, color: i < 2 ? "#FF6B9D" : "#999" }}>{name}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Arrived button */}
        <div style={{ padding: "14px 20px 0", marginTop: "auto" }}>
          <button style={{ width: "100%", background: "#fff", border: "1.5px solid #FFB6C8", borderRadius: 16, padding: "14px", color: "#FF6B9D", fontSize: 14, fontWeight: 700, cursor: "pointer", letterSpacing: "-0.01em" }}>
            Arrived Safely
          </button>
        </div>

        {/* Bottom nav */}
        <div style={{ background: "#fff", borderTop: "1px solid #F3EEF0", padding: "10px 0 24px", display: "flex", justifyContent: "space-around", marginTop: 14 }}>
          {[
            { label: "Home", path: "M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" },
            { label: "Circle", path: "M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z" },
            { label: "Route", active: true, path: "M3 12h18M3 6h18M3 18h18" },
            { label: "Comfort", path: "M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z" },
          ].map((tab) => (
            <div key={tab.label} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 4 }}>
              <svg width="20" height="20" viewBox="0 0 24 24" fill={tab.active ? "#FF6B9D" : "none"} stroke={tab.active ? "#FF6B9D" : "#C0B0B5"} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d={tab.path}/></svg>
              <span style={{ fontSize: 10, fontWeight: tab.active ? 700 : 500, color: tab.active ? "#FF6B9D" : "#C0B0B5" }}>{tab.label}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

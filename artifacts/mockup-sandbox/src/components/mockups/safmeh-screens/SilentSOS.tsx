import { useState } from "react";

export function SilentSOS() {
  const [triggered, setTriggered] = useState(false);

  return (
    <div style={{ fontFamily: "'Nunito', sans-serif", background: triggered ? "#1A0010" : "#FFF8FA", minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", transition: "background 0.6s" }}>
      <div style={{ width: 390, height: 844, background: triggered ? "#1A0010" : "#FFF8FA", borderRadius: 40, overflow: "hidden", position: "relative", display: "flex", flexDirection: "column", boxShadow: "0 30px 80px rgba(255,107,157,0.18)" }}>

        {/* Status bar */}
        <div style={{ background: "transparent", padding: "14px 24px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 13, fontWeight: 700, color: triggered ? "#FFB6C8" : "#333" }}>9:41</span>
          <div style={{ display: "flex", gap: 6, alignItems: "center" }}>
            <div style={{ width: 25, height: 12, border: "1.5px solid " + (triggered ? "#FFB6C8" : "#333"), borderRadius: 3, padding: "1px 2px", display: "flex", alignItems: "center" }}>
              <div style={{ width: "80%", height: "100%", background: "#4CAF50", borderRadius: 1.5 }} />
            </div>
          </div>
        </div>

        {!triggered ? (
          <>
            {/* Header */}
            <div style={{ padding: "16px 24px 0" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                <div style={{ width: 32, height: 32, borderRadius: 16, background: "#FFE4EE", display: "flex", alignItems: "center", justifyContent: "center" }}>
                  <span style={{ fontSize: 16 }}>←</span>
                </div>
                <h1 style={{ margin: 0, fontSize: 20, fontWeight: 800, color: "#2D2D2D" }}>Silent SOS</h1>
              </div>
              <p style={{ margin: "8px 0 0", fontSize: 13, color: "#888" }}>Trigger discreetly. No sound, no visible alert.</p>
            </div>

            {/* Big SOS button */}
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center", padding: "30px 24px 0" }}>
              <div
                onClick={() => setTriggered(true)}
                style={{ width: 180, height: 180, borderRadius: 90, background: "linear-gradient(135deg, #FF8FAB, #FF6B9D)", boxShadow: "0 0 0 16px #FFD5E5, 0 20px 50px rgba(255,107,157,0.4)", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", cursor: "pointer" }}
              >
                <span style={{ fontSize: 52 }}>🆘</span>
                <p style={{ margin: "6px 0 0", fontSize: 14, fontWeight: 800, color: "#fff" }}>HOLD FOR SOS</p>
              </div>
              <p style={{ marginTop: 20, fontSize: 12, color: "#bbb", textAlign: "center" }}>Hold for 2 seconds · Sends silently</p>
            </div>

            {/* Trigger methods */}
            <div style={{ padding: "24px 20px 0" }}>
              <p style={{ margin: "0 0 12px", fontSize: 14, fontWeight: 800, color: "#2D2D2D" }}>Other trigger methods</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                {[
                  { icon: "🔌", label: "Power button × 3", sub: "Press 3 times within 2 seconds" },
                  { icon: "📳", label: "Shake phone", sub: "Shake firmly for 2 seconds" },
                  { icon: "🔊", label: "Volume pattern", sub: "Up · Up · Down within 3 seconds" },
                  { icon: "🎤", label: "Voice keyword", sub: "Say your secret phrase" },
                ].map((item) => (
                  <div key={item.label} style={{ background: "#fff", borderRadius: 14, padding: "12px 16px", display: "flex", alignItems: "center", gap: 12, boxShadow: "0 1px 6px rgba(0,0,0,0.06)" }}>
                    <span style={{ fontSize: 22 }}>{item.icon}</span>
                    <div>
                      <p style={{ margin: 0, fontSize: 13, fontWeight: 700, color: "#2D2D2D" }}>{item.label}</p>
                      <p style={{ margin: 0, fontSize: 11, color: "#aaa" }}>{item.sub}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </>
        ) : (
          /* TRIGGERED STATE */
          <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", padding: "0 30px" }}>
            {/* Pulsing ring */}
            <div style={{ position: "relative", display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 32 }}>
              <div style={{ position: "absolute", width: 200, height: 200, borderRadius: 100, border: "3px solid #FF8FAB", opacity: 0.3, animation: "pulse 1.5s infinite" }} />
              <div style={{ position: "absolute", width: 160, height: 160, borderRadius: 80, border: "3px solid #FF8FAB", opacity: 0.5 }} />
              <div style={{ width: 120, height: 120, borderRadius: 60, background: "linear-gradient(135deg, #FF4B8B, #FF8FAB)", display: "flex", alignItems: "center", justifyContent: "center", boxShadow: "0 0 40px rgba(255,75,139,0.6)" }}>
                <span style={{ fontSize: 48 }}>🆘</span>
              </div>
            </div>

            <h2 style={{ margin: "0 0 8px", fontSize: 22, fontWeight: 800, color: "#FFB6C8", textAlign: "center" }}>SOS Activated</h2>
            <p style={{ margin: "0 0 28px", fontSize: 14, color: "#FF8FAB", textAlign: "center" }}>Silently alerting your Trusted Circle...</p>

            <div style={{ width: "100%", display: "flex", flexDirection: "column", gap: 10 }}>
              {[
                { icon: "📍", text: "Live location being shared", done: true },
                { icon: "🎙️", text: "Audio recording started", done: true },
                { icon: "📱", text: "Mum notified", done: true },
                { icon: "📱", text: "Riya notified", done: false },
              ].map((step) => (
                <div key={step.text} style={{ background: "rgba(255,182,200,0.08)", border: "1px solid rgba(255,182,200,0.15)", borderRadius: 14, padding: "12px 16px", display: "flex", alignItems: "center", gap: 12 }}>
                  <span style={{ fontSize: 18 }}>{step.icon}</span>
                  <p style={{ flex: 1, margin: 0, fontSize: 13, color: "#FFB6C8" }}>{step.text}</p>
                  <span style={{ fontSize: 16 }}>{step.done ? "✓" : "⏳"}</span>
                </div>
              ))}
            </div>

            <button
              onClick={() => setTriggered(false)}
              style={{ marginTop: 28, background: "rgba(255,182,200,0.12)", border: "1px solid rgba(255,182,200,0.25)", borderRadius: 20, padding: "12px 32px", color: "#FF8FAB", fontSize: 14, fontWeight: 700, cursor: "pointer" }}
            >
              Cancel SOS
            </button>
          </div>
        )}

        {!triggered && (
          /* Bottom nav */
          <div style={{ marginTop: "auto", background: "#fff", borderTop: "1px solid #FFE4EE", padding: "10px 0 20px", display: "flex", justifyContent: "space-around" }}>
            {[
              { icon: "🏠", label: "Home" },
              { icon: "👥", label: "Circle" },
              { icon: "🗺️", label: "Route" },
              { icon: "💕", label: "Comfort" },
            ].map((tab) => (
              <div key={tab.label} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 3, opacity: 0.45 }}>
                <span style={{ fontSize: 22 }}>{tab.icon}</span>
                <span style={{ fontSize: 10, fontWeight: 600, color: "#aaa" }}>{tab.label}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

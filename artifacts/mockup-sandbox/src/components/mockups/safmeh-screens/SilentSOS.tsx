import { useState } from "react";

const FONT_IMPORT = "https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap";

export function SilentSOS() {
  const [triggered, setTriggered] = useState(false);

  return (
    <div style={{ fontFamily: "'Space Grotesk', sans-serif", background: triggered ? "#0D0008" : "#FFF8FA", minHeight: "100vh", display: "flex", alignItems: "center", justifyContent: "center", transition: "background 0.5s" }}>
      <link rel="stylesheet" href={FONT_IMPORT} />
      <div style={{ width: 390, height: 844, background: triggered ? "#0D0008" : "#FFF8FA", borderRadius: 40, overflow: "hidden", display: "flex", flexDirection: "column", boxShadow: "0 30px 80px rgba(255,107,157,0.18)", transition: "background 0.5s" }}>

        {/* Status bar */}
        <div style={{ padding: "16px 24px 0", display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <span style={{ fontSize: 13, fontWeight: 600, color: triggered ? "#FFB6C8" : "#333", letterSpacing: "0.02em" }}>9:41</span>
          <div style={{ width: 25, height: 12, border: `1.5px solid ${triggered ? "#FFB6C8" : "#333"}`, borderRadius: 3, padding: "1px 2px", display: "flex", alignItems: "center" }}>
            <div style={{ width: "80%", height: "100%", background: "#4CAF50", borderRadius: 1.5 }} />
          </div>
        </div>

        {!triggered ? (
          <>
            {/* Header */}
            <div style={{ padding: "18px 24px 0" }}>
              <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
                <div style={{ width: 32, height: 32, borderRadius: 12, background: "#FFE4EE", display: "flex", alignItems: "center", justifyContent: "center" }}>
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" strokeWidth="2.5" strokeLinecap="round"><path d="M19 12H5M12 5l-7 7 7 7"/></svg>
                </div>
                <h1 style={{ margin: 0, fontSize: 20, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.02em" }}>Silent SOS</h1>
              </div>
              <p style={{ margin: "8px 0 0", fontSize: 13, color: "#999", fontWeight: 500 }}>Triggers without making a sound or visible alert.</p>
            </div>

            {/* Big SOS button */}
            <div style={{ display: "flex", flexDirection: "column", alignItems: "center", padding: "32px 24px 0" }}>
              <div
                onClick={() => setTriggered(true)}
                style={{ width: 172, height: 172, borderRadius: "50%", background: "linear-gradient(135deg, #FF8FAB, #FF4B8B)", boxShadow: "0 0 0 14px #FFD5E5, 0 20px 50px rgba(255,75,139,0.35)", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", cursor: "pointer", gap: 6 }}
              >
                <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
                <p style={{ margin: 0, fontSize: 12, fontWeight: 700, color: "#fff", letterSpacing: "0.08em", textTransform: "uppercase" }}>Hold for SOS</p>
              </div>
              <p style={{ marginTop: 18, fontSize: 12, color: "#C0B0B5", fontWeight: 500 }}>Hold 2 sec · Sends silently</p>
            </div>

            {/* Trigger methods */}
            <div style={{ padding: "26px 20px 0" }}>
              <p style={{ margin: "0 0 12px", fontSize: 13, fontWeight: 700, color: "#1A1A1A", letterSpacing: "-0.01em" }}>Other trigger methods</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                {[
                  { label: "Power button × 3", sub: "Press 3 times within 2 seconds", path: "M18.36 6.64a9 9 0 11-12.73 0M12 2v10" },
                  { label: "Shake phone", sub: "Shake firmly for 2 seconds", path: "M12 2v20M2 12h20" },
                  { label: "Volume pattern", sub: "Up · Up · Down within 3 seconds", path: "M11 5L6 9H2v6h4l5 4V5zM19.07 4.93a10 10 0 010 14.14M15.54 8.46a5 5 0 010 7.07" },
                  { label: "Voice keyword", sub: "Say your secret phrase", path: "M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3zM19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8" },
                ].map((item) => (
                  <div key={item.label} style={{ background: "#fff", borderRadius: 14, padding: "12px 14px", display: "flex", alignItems: "center", gap: 12, border: "1px solid #F3EEF0" }}>
                    <div style={{ width: 34, height: 34, borderRadius: 10, background: "#FFE4EE", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#FF6B9D" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d={item.path}/></svg>
                    </div>
                    <div>
                      <p style={{ margin: 0, fontSize: 13, fontWeight: 600, color: "#1A1A1A" }}>{item.label}</p>
                      <p style={{ margin: 0, fontSize: 11, color: "#aaa", fontWeight: 500 }}>{item.sub}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </>
        ) : (
          /* TRIGGERED STATE */
          <div style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center", padding: "0 28px" }}>
            <div style={{ position: "relative", display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 36 }}>
              <div style={{ position: "absolute", width: 190, height: 190, borderRadius: "50%", border: "1.5px solid rgba(255,143,171,0.2)" }} />
              <div style={{ position: "absolute", width: 148, height: 148, borderRadius: "50%", border: "1.5px solid rgba(255,143,171,0.35)" }} />
              <div style={{ width: 112, height: 112, borderRadius: "50%", background: "linear-gradient(135deg, #FF4B8B, #FF8FAB)", display: "flex", alignItems: "center", justifyContent: "center", boxShadow: "0 0 40px rgba(255,75,139,0.5)" }}>
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round"><path d="M12 9v4M12 17h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
              </div>
            </div>

            <h2 style={{ margin: "0 0 6px", fontSize: 22, fontWeight: 700, color: "#FFB6C8", letterSpacing: "-0.02em" }}>SOS Activated</h2>
            <p style={{ margin: "0 0 32px", fontSize: 13, color: "#FF8FAB", fontWeight: 500 }}>Silently alerting your Trusted Circle</p>

            <div style={{ width: "100%", display: "flex", flexDirection: "column", gap: 9 }}>
              {[
                { text: "Live location shared", done: true },
                { text: "Audio recording started", done: true },
                { text: "Mum notified", done: true },
                { text: "Riya notified", done: false },
              ].map((step) => (
                <div key={step.text} style={{ background: "rgba(255,182,200,0.07)", border: "1px solid rgba(255,182,200,0.12)", borderRadius: 12, padding: "12px 16px", display: "flex", alignItems: "center", gap: 12 }}>
                  <div style={{ width: 20, height: 20, borderRadius: "50%", background: step.done ? "rgba(34,197,94,0.15)" : "rgba(255,182,200,0.1)", border: `1px solid ${step.done ? "#22C55E" : "rgba(255,182,200,0.3)"}`, display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                    {step.done
                      ? <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#22C55E" strokeWidth="3" strokeLinecap="round"><path d="M5 13l4 4L19 7"/></svg>
                      : <div style={{ width: 6, height: 6, borderRadius: "50%", background: "rgba(255,182,200,0.4)" }} />
                    }
                  </div>
                  <p style={{ flex: 1, margin: 0, fontSize: 13, color: "#FFB6C8", fontWeight: 500 }}>{step.text}</p>
                </div>
              ))}
            </div>

            <button
              onClick={() => setTriggered(false)}
              style={{ marginTop: 28, background: "transparent", border: "1px solid rgba(255,182,200,0.2)", borderRadius: 14, padding: "12px 32px", color: "#FF8FAB", fontSize: 13, fontWeight: 600, cursor: "pointer", letterSpacing: "0.02em" }}
            >
              Cancel SOS
            </button>
          </div>
        )}

        {!triggered && (
          <div style={{ marginTop: "auto", background: "#fff", borderTop: "1px solid #F3EEF0", padding: "10px 0 24px", display: "flex", justifyContent: "space-around" }}>
            {[
              { label: "Home", path: "M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z" },
              { label: "Circle", path: "M17 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M9 11a4 4 0 100-8 4 4 0 000 8z" },
              { label: "Route", path: "M3 12h18M3 6h18M3 18h18" },
              { label: "Comfort", path: "M20.84 4.61a5.5 5.5 0 00-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 00-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 000-7.78z" },
            ].map((tab) => (
              <div key={tab.label} style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 4 }}>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#C0B0B5" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d={tab.path}/></svg>
                <span style={{ fontSize: 10, fontWeight: 500, color: "#C0B0B5" }}>{tab.label}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

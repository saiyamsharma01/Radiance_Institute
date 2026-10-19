import { ImageResponse } from "next/og";

export const runtime = "edge";
export const alt = "Radiance Institute — Committed to Quality Education";
export const size = {
  width: 1200,
  height: 630,
};
export const contentType = "image/png";

export default async function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          background: "linear-gradient(135deg, #0B132B 0%, #172B4D 50%, #2059A5 100%)",
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          fontFamily: "sans-serif",
          padding: "60px",
          position: "relative",
        }}
      >
        {/* Glow circles */}
        <div
          style={{
            position: "absolute",
            top: "-100px",
            right: "-100px",
            width: "400px",
            height: "400px",
            borderRadius: "50%",
            background: "radial-gradient(circle, rgba(217,119,6,0.3) 0%, transparent 70%)",
          }}
        />
        <div
          style={{
            position: "absolute",
            bottom: "-100px",
            left: "-100px",
            width: "400px",
            height: "400px",
            borderRadius: "50%",
            background: "radial-gradient(circle, rgba(32,89,165,0.4) 0%, transparent 70%)",
          }}
        />

        {/* Center Card */}
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            background: "rgba(255, 255, 255, 0.08)",
            border: "2px solid rgba(255, 255, 255, 0.2)",
            borderRadius: "32px",
            padding: "50px 70px",
            boxShadow: "0 25px 50px -12px rgba(0, 0, 0, 0.5)",
            textAlign: "center",
          }}
        >
          {/* Badge */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              background: "rgba(217, 119, 6, 0.2)",
              border: "1px solid rgba(245, 158, 11, 0.4)",
              borderRadius: "50px",
              padding: "8px 24px",
              marginBottom: "24px",
              color: "#FBBF24",
              fontSize: "18px",
              fontWeight: 700,
              letterSpacing: "1px",
              textTransform: "uppercase",
            }}
          >
            Unit of Bedi College of Physics • Est. 1998
          </div>

          {/* Title */}
          <div
            style={{
              fontSize: "64px",
              fontWeight: 900,
              color: "#FFFFFF",
              letterSpacing: "-1px",
              marginBottom: "12px",
            }}
          >
            Radiance Institute
          </div>

          {/* Tagline */}
          <div
            style={{
              fontSize: "24px",
              fontWeight: 700,
              color: "#F59E0B",
              letterSpacing: "3px",
              textTransform: "uppercase",
              marginBottom: "24px",
            }}
          >
            Committed to Quality Education
          </div>

          {/* Details */}
          <div
            style={{
              fontSize: "20px",
              color: "#CBD5E1",
              maxWidth: "800px",
              lineHeight: 1.5,
              marginBottom: "28px",
            }}
          >
            Classes 6 to 12 • Senior Secondary PCM &amp; NEET • Physics by Er. Bedi Sir
          </div>

          {/* Location & Social */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: "30px",
              fontSize: "18px",
              color: "#94A3B8",
              borderTop: "1px solid rgba(255, 255, 255, 0.15)",
              paddingTop: "20px",
              width: "100%",
              justifyContent: "center",
            }}
          >
            <span>📍 85-A, Rani Ka Bagh, Amritsar</span>
            <span>•</span>
            <span>📸 @radiance_institute</span>
            <span>•</span>
            <span>📞 +91 99141 22256</span>
          </div>
        </div>
      </div>
    ),
    {
      ...size,
    }
  );
}

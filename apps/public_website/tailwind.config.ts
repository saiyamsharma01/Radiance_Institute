import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        radiance: {
          blue: "#1D5FBE",
          royal: "#174FA0",
          navy: "#0A192F",
          midnight: "#06101E",
          light: "#EEF5FF",
          surface: "#F8FAFC",
          gold: "#D97706",
          amber: "#F59E0B",
          accent: "#38BDF8",
        },
      },
      fontFamily: {
        sans: ["var(--font-inter)", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        display: ["var(--font-outfit)", "var(--font-inter)", "sans-serif"],
      },
      boxShadow: {
        glow: "0 0 25px -5px rgba(29, 95, 190, 0.25)",
        "glow-amber": "0 0 25px -5px rgba(245, 158, 11, 0.3)",
        glass: "0 8px 32px 0 rgba(11, 25, 47, 0.08)",
      },
    },
  },
  plugins: [],
};
export default config;

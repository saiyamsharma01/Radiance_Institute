import type { Metadata } from "next";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import "./globals.css";

export const metadata: Metadata = {
  metadataBase: new URL("https://radianceinstitute.net"),
  title: "Radiance Institute — Committed to Quality Education | Amritsar",
  description:
    "Radiance Institute in Rani Ka Bagh, Amritsar offers premier academic coaching for Classes 6 to 12, featuring specialized Physics, Chemistry, and Mathematics for senior secondary boards and competitive foundations.",
  keywords: [
    "Radiance Institute",
    "Amritsar Coaching",
    "Classes 6 to 12 Coaching",
    "Class 11 Physics Amritsar",
    "Class 12 Chemistry Amritsar",
    "Rani Ka Bagh Education",
    "Quality Education Punjab",
  ],
  authors: [{ name: "Radiance Institute" }],
  openGraph: {
    title: "Radiance Institute — Committed to Quality Education",
    description:
      "Premier academic institute for Classes 6 to 12 with specialized Physics, Chemistry, and Mathematics tracks in Amritsar, Punjab.",
    url: "https://radianceinstitute.net",
    siteName: "Radiance Institute",
    images: [
      {
        url: "/images/radiance_logo.jpg",
        width: 800,
        height: 800,
        alt: "Radiance Institute Emblem",
      },
    ],
    locale: "en_IN",
    type: "website",
  },
  robots: {
    index: true,
    follow: true,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "EducationalOrganization",
    "name": "Radiance Institute",
    "slogan": "Committed to Quality Education",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "85-A, Rani Ka Bagh, adjoining FCI Office",
      "addressLocality": "Amritsar",
      "addressRegion": "Punjab",
      "addressCountry": "IN"
    },
    "telephone": "+91-183-508-0005",
    "email": "info@radianceinstitute.net",
    "url": "https://radianceinstitute.net",
    "hasCourse": [
      {
        "@type": "Course",
        "name": "Senior Secondary Physics (Class 11 & 12)",
        "description": "Comprehensive mechanics, thermodynamics, electromagnetism, and modern physics."
      },
      {
        "@type": "Course",
        "name": "Senior Secondary Chemistry (Class 11 & 12)",
        "description": "Organic, physical, and inorganic chemistry foundations."
      },
      {
        "@type": "Course",
        "name": "Senior Secondary Mathematics (Class 11 & 12)",
        "description": "Calculus, vectors, probability, and algebra."
      }
    ]
  };

  return (
    <html lang="en">
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
      </head>
      <body className="min-h-screen flex flex-col bg-white text-slate-800 antialiased">
        <Navbar />
        <main className="flex-grow">{children}</main>
        <Footer />
      </body>
    </html>
  );
}

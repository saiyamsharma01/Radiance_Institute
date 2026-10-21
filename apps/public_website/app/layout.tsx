import type { Metadata } from "next";
import { Inter, Outfit } from "next/font/google";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import "./globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
  display: "swap",
});

const outfit = Outfit({
  subsets: ["latin"],
  variable: "--font-outfit",
  display: "swap",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://radianceinstitute.net"),
  title: "Radiance Institute — Committed to Quality Education | Amritsar",
  description:
    "Radiance Institute (Unit of Bedi College of Physics, Est. 1998) in Rani Ka Bagh, Amritsar offers premier academic coaching for Classes 6 to 12, featuring specialized Physics by Er. Bedi Sir, Chemistry, and Mathematics for senior secondary boards and competitive foundations (JEE & NEET).",
  keywords: [
    "Radiance Institute",
    "Bedi College of Physics",
    "Physics by Bedi Sir",
    "Amritsar Coaching",
    "Classes 6 to 12 Coaching",
    "Class 11 Physics Amritsar",
    "Class 12 Chemistry Amritsar",
    "Rani Ka Bagh Education",
    "JEE Coaching Amritsar",
    "NEET Coaching Amritsar",
    "Quality Education Punjab",
  ],
  authors: [{ name: "Radiance Institute" }],
  icons: {
    icon: [
      { url: "/images/radiance_logo.jpg", sizes: "any" },
      { url: "/favicon.ico", sizes: "any" },
    ],
    shortcut: ["/images/radiance_logo.jpg"],
    apple: [
      { url: "/images/radiance_logo.jpg", sizes: "180x180", type: "image/jpeg" },
      { url: "/apple-touch-icon.png", sizes: "180x180" },
    ],
  },
  openGraph: {
    title: "Radiance Institute — Committed to Quality Education | Amritsar",
    description:
      "Premier academic institute for Classes 6 to 12 with specialized Physics by Er. Bedi Sir, Chemistry, and Mathematics tracks in Rani Ka Bagh, Amritsar, Punjab.",
    url: "https://radianceinstitute.net",
    siteName: "Radiance Institute",
    images: [
      {
        url: "/images/radiance_logo.jpg",
        width: 800,
        height: 800,
        alt: "Radiance Institute Emblem & Crest",
      },
    ],
    locale: "en_IN",
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Radiance Institute — Committed to Quality Education",
    description:
      "Premier coaching for Classes 6 to 12 & Physics by Er. Bedi Sir at Rani Ka Bagh, Amritsar.",
    images: ["/images/radiance_logo.jpg"],
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
    "legalName": "Radiance Institute (Unit of Bedi College of Physics)",
    "slogan": "Committed to Quality Education",
    "logo": "https://radianceinstitute.net/images/radiance_logo.jpg",
    "image": "https://radianceinstitute.net/images/radiance_logo.jpg",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "85-A, Rani Ka Bagh, adjoining FCI Office",
      "addressLocality": "Amritsar",
      "addressRegion": "Punjab",
      "postalCode": "143001",
      "addressCountry": "IN"
    },
    "telephone": "+91-99141-22256",
    "email": "info@radianceinstitute.net",
    "url": "https://radianceinstitute.net",
    "sameAs": [
      "https://www.instagram.com/radiance_institute/"
    ],
    "hasCourse": [
      {
        "@type": "Course",
        "name": "Senior Secondary Physics by Er. Bedi Sir (Class 11 & 12)",
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
      },
      {
        "@type": "Course",
        "name": "Junior Foundation Academy (Classes 6 to 10)",
        "description": "Science, Mathematics, and Mental Ability for NTSE and Olympiads."
      }
    ]
  };

  return (
    <html lang="en" className={`${inter.variable} ${outfit.variable} scroll-smooth`}>
      <head>
        <link rel="icon" href="/images/radiance_logo.jpg" type="image/jpeg" />
        <link rel="shortcut icon" href="/images/radiance_logo.jpg" type="image/jpeg" />
        <link rel="apple-touch-icon" href="/images/radiance_logo.jpg" />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
        />
      </head>
      <body className="min-h-screen flex flex-col bg-slate-50/50 text-slate-800 font-sans antialiased selection:bg-blue-600 selection:text-white">
        <Navbar />
        <main className="flex-grow">{children}</main>
        <Footer />
      </body>
    </html>
  );
}

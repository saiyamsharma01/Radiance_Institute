"use client";

import Link from "next/link";
import Image from "next/image";
import { useState } from "react";
import { Menu, X, Phone, Instagram, Sparkles } from "lucide-react";

export default function Navbar() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navLinks = [
    { name: "Home", href: "/" },
    { name: "About", href: "/about" },
    { name: "Classes 6–12", href: "/classes" },
    { name: "Physics & PCM", href: "/subjects" },
    { name: "Instagram Hub", href: "/#instagram-feed" },
    { name: "Toppers", href: "/#toppers" },
    { name: "Fee Calculator", href: "/#calculator" },
    { name: "Admissions", href: "/admissions" },
    { name: "Contact", href: "/contact" },
  ];

  return (
    <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-slate-100 shadow-sm">
      {/* Top Contact & Social Bar */}
      <div className="bg-radiance-navy text-white text-xs py-2 px-4 sm:px-8 flex justify-between items-center">
        <div className="flex items-center space-x-6">
          <a
            href="tel:+919914122256"
            className="flex items-center hover:text-amber-300 transition-colors"
          >
            <Phone className="w-3.5 h-3.5 mr-1.5 text-amber-400" />
            <span>+91 99141 22256 / 0183 508 0005</span>
          </a>
          <span className="hidden md:inline text-slate-300">
            📍 85-A, Rani Ka Bagh (Adjoining FCI Office), Amritsar
          </span>
        </div>

        <div className="flex items-center space-x-4">
          <a
            href="https://www.instagram.com/radiance_institute/"
            target="_blank"
            rel="noopener noreferrer"
            className="inline-flex items-center gap-1.5 bg-gradient-to-r from-purple-500/30 to-pink-500/30 hover:from-purple-500/50 hover:to-pink-500/50 px-2.5 py-0.5 rounded-full border border-pink-400/40 text-pink-200 hover:text-white transition-all text-[11px] font-semibold"
          >
            <Instagram className="w-3 h-3 text-pink-400" />
            <span>@radiance_institute</span>
          </a>
          <span className="hidden sm:inline text-amber-400 font-semibold tracking-wide">
            Admissions Open 2026–27
          </span>
        </div>
      </div>

      {/* Main Navigation */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-20">
          {/* Logo & Institute Identity */}
          <Link href="/" className="flex items-center space-x-3 group">
            <div className="relative w-12 h-12 rounded-full overflow-hidden border-2 border-radiance-blue shadow-sm bg-white shrink-0">
              <Image
                src="/images/radiance_logo.jpg"
                alt="Radiance Institute Logo"
                fill
                className="object-cover"
                priority
              />
            </div>
            <div>
              <div className="flex items-center gap-1.5">
                <span className="font-extrabold text-xl text-radiance-navy tracking-tight group-hover:text-radiance-blue transition-colors">
                  Radiance Institute
                </span>
                <span className="text-[10px] font-bold bg-amber-100 text-amber-800 px-1.5 py-0.5 rounded">
                  Bedi College
                </span>
              </div>
              <span className="block text-xs font-semibold text-radiance-gold tracking-wider uppercase">
                Committed to Quality Education
              </span>
            </div>
          </Link>

          {/* Desktop Nav Links */}
          <nav className="hidden xl:flex items-center space-x-6">
            {navLinks.map((link) => (
              <Link
                key={link.name}
                href={link.href}
                className="text-xs font-semibold text-slate-700 hover:text-radiance-blue transition-colors"
              >
                {link.name}
              </Link>
            ))}
          </nav>

          {/* CTA Buttons */}
          <div className="hidden lg:flex items-center space-x-3">
            <a
              href="https://www.instagram.com/radiance_institute/"
              target="_blank"
              rel="noopener noreferrer"
              className="p-2.5 rounded-lg border border-slate-200 text-slate-600 hover:text-pink-600 hover:border-pink-300 transition-colors"
              title="Visit Instagram Profile"
            >
              <Instagram className="w-4 h-4" />
            </a>
            <Link
              href="/admissions"
              className="bg-radiance-blue hover:bg-blue-700 text-white px-5 py-2.5 rounded-lg text-xs font-bold shadow-sm hover:shadow transition-all"
            >
              Enquire Now
            </Link>
          </div>

          {/* Mobile Menu Button */}
          <div className="xl:hidden">
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 rounded-md text-slate-700 hover:text-radiance-blue hover:bg-slate-50"
              aria-label="Toggle navigation menu"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu Dropdown */}
      {mobileMenuOpen && (
        <div className="xl:hidden border-t border-slate-100 bg-white px-4 pt-3 pb-6 space-y-2">
          {navLinks.map((link) => (
            <Link
              key={link.name}
              href={link.href}
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-2 text-sm font-semibold text-slate-700 hover:text-radiance-blue hover:bg-slate-50 rounded-md"
            >
              {link.name}
            </Link>
          ))}
          <div className="pt-2 space-y-2">
            <a
              href="https://www.instagram.com/radiance_institute/"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center justify-center gap-2 w-full bg-gradient-to-r from-purple-600 to-pink-600 text-white px-4 py-2.5 rounded-lg text-xs font-bold"
            >
              <Instagram className="w-4 h-4" />
              <span>Follow @radiance_institute</span>
            </a>
            <Link
              href="/admissions"
              onClick={() => setMobileMenuOpen(false)}
              className="block w-full text-center bg-radiance-blue text-white px-4 py-2.5 rounded-lg text-xs font-bold"
            >
              Submit Admission Enquiry
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}

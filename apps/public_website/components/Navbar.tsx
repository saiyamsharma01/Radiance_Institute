"use client";

import Link from "next/link";
import Image from "next/image";
import { useState } from "react";
import { Menu, X, Phone, School } from "lucide-react";

export default function Navbar() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navLinks = [
    { name: "Home", href: "/" },
    { name: "About", href: "/about" },
    { name: "Classes 6–12", href: "/classes" },
    { name: "Subjects (PCM)", href: "/subjects" },
    { name: "Admissions", href: "/admissions" },
    { name: "Contact", href: "/contact" },
    { name: "FAQ", href: "/faq" },
  ];

  return (
    <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-slate-100 shadow-sm">
      {/* Top Contact Bar */}
      <div className="bg-radiance-navy text-white text-xs py-2 px-4 sm:px-8 flex justify-between items-center">
        <div className="flex items-center space-x-6">
          <span className="flex items-center">
            <Phone className="w-3.5 h-3.5 mr-1.5 text-amber-400" />
            +91 183 508 0005
          </span>
          <span className="hidden md:inline text-slate-300">
            85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar
          </span>
        </div>
        <div className="text-amber-400 font-medium tracking-wide">
          Admissions Open for Classes 6 to 12
        </div>
      </div>

      {/* Main Navigation */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-20">
          {/* Logo & Institute Identity */}
          <Link href="/" className="flex items-center space-x-3 group">
            <div className="relative w-12 h-12 rounded-full overflow-hidden border-2 border-radiance-blue shadow-sm bg-white">
              <Image
                src="/images/radiance_logo.jpg"
                alt="Radiance Institute Logo"
                fill
                className="object-cover"
                priority
              />
            </div>
            <div>
              <span className="block font-bold text-xl text-radiance-navy tracking-tight group-hover:text-radiance-blue transition-colors">
                Radiance Institute
              </span>
              <span className="block text-xs font-semibold text-radiance-gold tracking-wider uppercase">
                Committed to Quality Education
              </span>
            </div>
          </Link>

          {/* Desktop Nav Links */}
          <nav className="hidden lg:flex items-center space-x-8">
            {navLinks.map((link) => (
              <Link
                key={link.name}
                href={link.href}
                className="text-sm font-medium text-slate-700 hover:text-radiance-blue transition-colors"
              >
                {link.name}
              </Link>
            ))}
          </nav>

          {/* CTA Buttons */}
          <div className="hidden lg:flex items-center space-x-4">
            <Link
              href="/admissions"
              className="bg-radiance-blue hover:bg-blue-700 text-white px-5 py-2.5 rounded-lg text-sm font-semibold shadow-sm hover:shadow transition-all"
            >
              Enquire Now
            </Link>
          </div>

          {/* Mobile Menu Button */}
          <div className="lg:hidden">
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
        <div className="lg:hidden border-t border-slate-100 bg-white px-4 pt-3 pb-6 space-y-3">
          {navLinks.map((link) => (
            <Link
              key={link.name}
              href={link.href}
              onClick={() => setMobileMenuOpen(false)}
              className="block px-3 py-2 text-base font-medium text-slate-700 hover:text-radiance-blue hover:bg-slate-50 rounded-md"
            >
              {link.name}
            </Link>
          ))}
          <div className="pt-2">
            <Link
              href="/admissions"
              onClick={() => setMobileMenuOpen(false)}
              className="block w-full text-center bg-radiance-blue text-white px-4 py-2.5 rounded-lg text-sm font-semibold"
            >
              Submit Admission Enquiry
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}

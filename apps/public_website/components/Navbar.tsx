"use client";

import Link from "next/link";
import Image from "next/image";
import { useState, useEffect, useRef } from "react";
import {
  Menu,
  X,
  Phone,
  Instagram,
  Sparkles,
  ChevronDown,
  BookOpen,
  Trophy,
  Calculator,
  Calendar,
  ArrowRight,
  GraduationCap,
  Atom,
  Clock,
  MapPin,
  ExternalLink,
  MessageCircle,
} from "lucide-react";

export default function Navbar() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const [activeDropdown, setActiveDropdown] = useState<string | null>(null);
  const timeoutRef = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 15);
    };
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const handleMouseEnter = (name: string) => {
    if (timeoutRef.current) clearTimeout(timeoutRef.current);
    setActiveDropdown(name);
  };

  const handleMouseLeave = () => {
    timeoutRef.current = setTimeout(() => {
      setActiveDropdown(null);
    }, 150);
  };

  return (
    <header className="sticky top-0 z-50 w-full transition-all duration-300">
      {/* 1. Top Announcement Ribbon */}
      <div className="bg-[#0D1B2A] text-white text-xs py-2 px-4 sm:px-8 border-b border-white/10 hidden sm:block">
        <div className="max-w-7xl mx-auto flex justify-between items-center">
          {/* Left: Verified Helpline & Address */}
          <div className="flex items-center space-x-6 text-slate-300">
            <a
              href="tel:+919914122256"
              className="flex items-center hover:text-amber-400 transition-colors group"
            >
              <Phone className="w-3.5 h-3.5 mr-1.5 text-amber-400 group-hover:rotate-12 transition-transform" />
              <span>+91 99141 22256</span>
              <span className="text-slate-500 mx-1.5">|</span>
              <span className="text-slate-400 hover:text-white">0183 508 0005</span>
            </a>
            <span className="hidden lg:flex items-center text-slate-400">
              <MapPin className="w-3 h-3 mr-1 text-slate-400" />
              85-A, Rani Ka Bagh, Amritsar
            </span>
          </div>

          {/* Right: Instagram Highlight & Session */}
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-1.5 bg-amber-400/10 px-2.5 py-0.5 rounded-full border border-amber-400/20 text-amber-300 text-[11px] font-medium">
              <span className="relative flex h-2 w-2">
                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                <span className="relative inline-flex rounded-full h-2 w-2 bg-amber-400"></span>
              </span>
              <span>Admissions Open 2026–27</span>
            </div>

            <a
              href="https://www.instagram.com/radiance_institute/"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1.5 bg-gradient-to-r from-purple-500/20 via-pink-500/20 to-amber-500/20 hover:from-purple-500/40 hover:to-pink-500/40 px-3 py-0.5 rounded-full border border-pink-400/30 text-pink-200 hover:text-white transition-all text-[11px] font-semibold"
            >
              <Instagram className="w-3.5 h-3.5 text-pink-400" />
              <span>@radiance_institute</span>
              <ExternalLink className="w-2.5 h-2.5 opacity-70" />
            </a>
          </div>
        </div>
      </div>

      {/* 2. Main Navigation Glass Header */}
      <div
        className={`bg-white/95 backdrop-blur-xl border-b border-slate-200/80 transition-all duration-300 ${
          scrolled ? "shadow-lg shadow-slate-900/5 py-2.5" : "py-3.5"
        }`}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center">
            {/* Logo & Institute Identity */}
            <Link href="/" className="flex items-center gap-3 group shrink-0">
              <div className="relative w-12 h-12 sm:w-14 sm:h-14 rounded-xl overflow-hidden bg-white border border-slate-200/90 shadow-sm p-1 flex items-center justify-center group-hover:border-radiance-blue group-hover:shadow-md transition-all duration-200 shrink-0">
                <Image
                  src="/images/radiance_logo.jpg"
                  alt="Radiance Institute Logo"
                  fill
                  className="object-contain p-0.5"
                  priority
                />
              </div>
              <div className="flex flex-col">
                <div className="flex items-center gap-2">
                  <span className="font-black text-xl text-radiance-navy tracking-tight group-hover:text-radiance-blue transition-colors">
                    Radiance Institute
                  </span>
                </div>
                <div className="flex items-center gap-1.5 text-[11px]">
                  <span className="font-semibold text-slate-500">Unit of Bedi College</span>
                  <span className="w-1 h-1 rounded-full bg-amber-500"></span>
                  <span className="font-bold text-amber-600 tracking-wide uppercase text-[10px]">
                    Est. 1998
                  </span>
                </div>
              </div>
            </Link>

            {/* Desktop Navigation Menu (Organized & Sleek) */}
            <nav className="hidden lg:flex items-center space-x-1 xl:space-x-2">
              {/* Home */}
              <Link
                href="/"
                className="px-3.5 py-2 text-sm font-semibold text-slate-700 hover:text-radiance-blue hover:bg-slate-50 rounded-xl transition-all"
              >
                Home
              </Link>

              {/* Academics & Programs Dropdown */}
              <div
                className="relative"
                onMouseEnter={() => handleMouseEnter("programs")}
                onMouseLeave={handleMouseLeave}
              >
                <button
                  className={`flex items-center gap-1.5 px-3.5 py-2 text-sm font-semibold rounded-xl transition-all ${
                    activeDropdown === "programs"
                      ? "text-radiance-blue bg-blue-50"
                      : "text-slate-700 hover:text-radiance-blue hover:bg-slate-50"
                  }`}
                >
                  <span>Programs</span>
                  <ChevronDown
                    className={`w-4 h-4 transition-transform duration-200 ${
                      activeDropdown === "programs" ? "rotate-180 text-radiance-blue" : "text-slate-400"
                    }`}
                  />
                </button>

                {/* Dropdown Menu */}
                {activeDropdown === "programs" && (
                  <div className="absolute top-full left-0 mt-2 w-80 bg-white rounded-2xl shadow-2xl border border-slate-200/90 p-3 animate-in fade-in slide-in-from-top-2 duration-200 z-50">
                    <div className="space-y-1">
                      <Link
                        href="/classes"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-blue-50 text-radiance-blue flex items-center justify-center shrink-0 group-hover:bg-radiance-blue group-hover:text-white transition-colors">
                          <BookOpen className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Classes 6 to 10 Foundation
                          </div>
                          <div className="text-[11px] text-slate-500">
                            Pre-foundation, NTSE & Olympiad preparation
                          </div>
                        </div>
                      </Link>

                      <Link
                        href="/subjects"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-amber-50 text-amber-700 flex items-center justify-center shrink-0 group-hover:bg-amber-500 group-hover:text-white transition-colors">
                          <Atom className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Class 11 & 12 (PCM)
                          </div>
                          <div className="text-[11px] text-slate-500">
                            Senior secondary boards, JEE & NEET prep
                          </div>
                        </div>
                      </Link>

                      <Link
                        href="/about"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-purple-50 text-purple-700 flex items-center justify-center shrink-0 group-hover:bg-purple-600 group-hover:text-white transition-colors">
                          <GraduationCap className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Physics by Er. Bedi Sir
                          </div>
                          <div className="text-[11px] text-slate-500">
                            28+ years conceptual legacy & derivations
                          </div>
                        </div>
                      </Link>

                      <Link
                        href="/#batches"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-emerald-50 text-emerald-700 flex items-center justify-center shrink-0 group-hover:bg-emerald-600 group-hover:text-white transition-colors">
                          <Calendar className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Batch Schedules & Seats
                          </div>
                          <div className="text-[11px] text-slate-500">
                            Live batch timings & seats remaining
                          </div>
                        </div>
                      </Link>
                    </div>
                  </div>
                )}
              </div>

              {/* Student Life & Feats Dropdown */}
              <div
                className="relative"
                onMouseEnter={() => handleMouseEnter("explore")}
                onMouseLeave={handleMouseLeave}
              >
                <button
                  className={`flex items-center gap-1.5 px-3.5 py-2 text-sm font-semibold rounded-xl transition-all ${
                    activeDropdown === "explore"
                      ? "text-radiance-blue bg-blue-50"
                      : "text-slate-700 hover:text-radiance-blue hover:bg-slate-50"
                  }`}
                >
                  <span>Student Hub</span>
                  <ChevronDown
                    className={`w-4 h-4 transition-transform duration-200 ${
                      activeDropdown === "explore" ? "rotate-180 text-radiance-blue" : "text-slate-400"
                    }`}
                  />
                </button>

                {/* Dropdown Menu */}
                {activeDropdown === "explore" && (
                  <div className="absolute top-full left-0 mt-2 w-80 bg-white rounded-2xl shadow-2xl border border-slate-200/90 p-3 animate-in fade-in slide-in-from-top-2 duration-200 z-50">
                    <div className="space-y-1">
                      <Link
                        href="/#toppers"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-amber-50 text-amber-600 flex items-center justify-center shrink-0 group-hover:bg-amber-500 group-hover:text-white transition-colors">
                          <Trophy className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Toppers & Ranks
                          </div>
                          <div className="text-[11px] text-slate-500">
                            City & State rankers in JEE & NEET
                          </div>
                        </div>
                      </Link>

                      <Link
                        href="/#instagram-feed"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-pink-50 text-pink-600 flex items-center justify-center shrink-0 group-hover:bg-pink-600 group-hover:text-white transition-colors">
                          <Instagram className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Instagram Highlights
                          </div>
                          <div className="text-[11px] text-slate-500">
                            Reels, live lectures & classroom moments
                          </div>
                        </div>
                      </Link>

                      <Link
                        href="/#calculator"
                        className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-slate-50 transition-colors group"
                      >
                        <div className="w-9 h-9 rounded-lg bg-blue-50 text-radiance-blue flex items-center justify-center shrink-0 group-hover:bg-radiance-blue group-hover:text-white transition-colors">
                          <Calculator className="w-4 h-4" />
                        </div>
                        <div>
                          <div className="text-xs font-bold text-slate-900 group-hover:text-radiance-blue">
                            Scholarship & Fee Calculator
                          </div>
                          <div className="text-[11px] text-slate-500">
                            Calculate fee waiver based on past marks
                          </div>
                        </div>
                      </Link>
                    </div>
                  </div>
                )}
              </div>

              {/* About Campus */}
              <Link
                href="/about"
                className="px-3.5 py-2 text-sm font-semibold text-slate-700 hover:text-radiance-blue hover:bg-slate-50 rounded-xl transition-all"
              >
                About
              </Link>

              {/* Admissions */}
              <Link
                href="/admissions"
                className="px-3.5 py-2 text-sm font-semibold text-slate-700 hover:text-radiance-blue hover:bg-slate-50 rounded-xl transition-all"
              >
                Admissions
              </Link>

              {/* Contact */}
              <Link
                href="/contact"
                className="px-3.5 py-2 text-sm font-semibold text-slate-700 hover:text-radiance-blue hover:bg-slate-50 rounded-xl transition-all"
              >
                Contact
              </Link>
            </nav>

            {/* Desktop Action Buttons (Right) */}
            <div className="hidden lg:flex items-center gap-3">
              {/* Instagram Follow Button */}
              <a
                href="https://www.instagram.com/radiance_institute/"
                target="_blank"
                rel="noopener noreferrer"
                className="group relative p-2.5 rounded-xl border border-slate-200 text-slate-700 hover:text-white transition-all overflow-hidden"
                title="Follow @radiance_institute on Instagram"
              >
                <span className="absolute inset-0 bg-gradient-to-tr from-amber-500 via-pink-600 to-purple-600 opacity-0 group-hover:opacity-100 transition-opacity"></span>
                <Instagram className="w-4 h-4 relative z-10 transition-transform group-hover:scale-110" />
              </a>

              {/* Enquire Now CTA Button */}
              <Link
                href="/admissions"
                className="group relative inline-flex items-center gap-2 bg-gradient-to-r from-radiance-blue to-blue-700 hover:from-blue-700 hover:to-radiance-navy text-white text-xs font-bold px-5 py-2.5 rounded-xl shadow-md hover:shadow-xl hover:shadow-blue-500/20 active:scale-95 transition-all duration-200"
              >
                <span>Enquire Now</span>
                <ArrowRight className="w-3.5 h-3.5 group-hover:translate-x-1 transition-transform" />
              </Link>
            </div>

            {/* Mobile Menu Trigger */}
            <div className="lg:hidden flex items-center gap-2">
              <a
                href="https://www.instagram.com/radiance_institute/"
                target="_blank"
                rel="noopener noreferrer"
                className="p-2 rounded-lg text-pink-600 bg-pink-50"
              >
                <Instagram className="w-5 h-5" />
              </a>

              <button
                onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                className="p-2 rounded-xl text-slate-800 hover:bg-slate-100 transition-colors"
                aria-label="Toggle navigation menu"
              >
                {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6 text-radiance-navy" />}
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* 3. Mobile Navigation Drawer */}
      {mobileMenuOpen && (
        <div className="lg:hidden fixed inset-x-0 top-[110px] sm:top-[120px] bottom-0 bg-white/98 backdrop-blur-xl border-t border-slate-200 overflow-y-auto p-5 space-y-6 shadow-2xl animate-in fade-in slide-in-from-top-4 duration-200 z-50">
          {/* Quick Links Group */}
          <div className="space-y-1">
            <Link
              href="/"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Home
            </Link>
            <Link
              href="/about"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              About Campus & Bedi Sir
            </Link>
            <Link
              href="/classes"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Classes 6–10 Foundation
            </Link>
            <Link
              href="/subjects"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Senior Secondary PCM & Physics
            </Link>
            <Link
              href="/#toppers"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Toppers & Hall of Fame
            </Link>
            <Link
              href="/#calculator"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Fee & Scholarship Calculator
            </Link>
            <Link
              href="/#instagram-feed"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Instagram Channel & Reels
            </Link>
            <Link
              href="/contact"
              onClick={() => setMobileMenuOpen(false)}
              className="block px-4 py-3 rounded-xl font-bold text-sm text-slate-800 hover:bg-slate-50"
            >
              Contact Campus
            </Link>
          </div>

          {/* Action CTAs in Mobile */}
          <div className="space-y-3 pt-3 border-t border-slate-100">
            <Link
              href="/admissions"
              onClick={() => setMobileMenuOpen(false)}
              className="w-full inline-flex items-center justify-center gap-2 bg-radiance-blue text-white font-bold text-sm py-3.5 rounded-xl shadow-lg"
            >
              <span>Submit Admission Enquiry</span>
              <ArrowRight className="w-4 h-4" />
            </Link>

            <a
              href="https://wa.me/919914122256?text=Hello%20Radiance%20Institute,%20I%20would%20like%20to%20enquire%20about%20admissions."
              target="_blank"
              rel="noopener noreferrer"
              className="w-full inline-flex items-center justify-center gap-2 bg-emerald-600 text-white font-bold text-sm py-3.5 rounded-xl shadow-md"
            >
              <MessageCircle className="w-4 h-4" />
              <span>Chat on WhatsApp</span>
            </a>

            <a
              href="https://www.instagram.com/radiance_institute/"
              target="_blank"
              rel="noopener noreferrer"
              className="w-full inline-flex items-center justify-center gap-2 bg-gradient-to-r from-purple-600 to-pink-600 text-white font-bold text-sm py-3.5 rounded-xl shadow-md"
            >
              <Instagram className="w-4 h-4" />
              <span>Follow @radiance_institute</span>
            </a>
          </div>

          {/* Campus Helpline Footer */}
          <div className="pt-3 text-center text-xs text-slate-500">
            📍 85-A, Rani Ka Bagh, Amritsar • 📞 +91 99141 22256
          </div>
        </div>
      )}
    </header>
  );
}

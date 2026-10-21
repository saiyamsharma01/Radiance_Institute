"use client";

import { useState } from "react";
import Link from "next/link";
import {
  Instagram,
  MessageCircle,
  Phone,
  X,
  Sparkles,
  HelpCircle,
  MapPin,
  Send,
} from "lucide-react";

export default function FloatingSocialWidget() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="fixed bottom-4 right-4 sm:bottom-6 sm:right-6 z-40 flex flex-col items-end">
      {/* Expanded Quick Contact Drawer */}
      {isOpen && (
        <div className="mb-3 bg-white rounded-3xl p-5 shadow-2xl border border-slate-200/90 w-[calc(100vw-32px)] sm:w-80 max-w-sm animate-in fade-in slide-in-from-bottom-5 duration-200">
          <div className="flex items-center justify-between pb-3 border-b border-slate-100">
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 rounded-full bg-radiance-blue text-white flex items-center justify-center">
                <Sparkles className="w-4 h-4" />
              </div>
              <div>
                <h4 className="font-bold text-slate-900 text-sm">Radiance Helpdesk</h4>
                <p className="text-[11px] text-slate-500">Rani Ka Bagh, Amritsar</p>
              </div>
            </div>
            <button
              onClick={() => setIsOpen(false)}
              className="p-1.5 rounded-full hover:bg-slate-100 text-slate-400 hover:text-slate-600"
            >
              <X className="w-4 h-4" />
            </button>
          </div>

          <div className="py-3 space-y-2.5">
            {/* Instagram Quick Link */}
            <a
              href="https://www.instagram.com/radiance_institute/"
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center justify-between p-3 rounded-xl bg-gradient-to-r from-pink-50 via-purple-50 to-pink-50 hover:from-pink-100 hover:to-purple-100 border border-pink-200/60 transition-all group"
            >
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-full bg-gradient-to-tr from-amber-500 via-pink-500 to-purple-600 text-white flex items-center justify-center shadow-sm">
                  <Instagram className="w-4 h-4" />
                </div>
                <div>
                  <span className="font-bold text-xs text-slate-900 group-hover:text-pink-600 block">
                    Follow @radiance_institute
                  </span>
                  <span className="text-[11px] text-slate-500">
                    200+ reels, tips & topper posts
                  </span>
                </div>
              </div>
            </a>

            {/* WhatsApp Quick Chat */}
            <a
              href="https://wa.me/919914122256?text=Hello%20Radiance%20Institute,%20I%20would%20like%20to%20enquire%20about%20admissions."
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center justify-between p-3 rounded-xl bg-emerald-50 hover:bg-emerald-100 border border-emerald-200/60 transition-all group"
            >
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-full bg-emerald-500 text-white flex items-center justify-center shadow-sm">
                  <MessageCircle className="w-4 h-4" />
                </div>
                <div>
                  <span className="font-bold text-xs text-slate-900 group-hover:text-emerald-700 block">
                    WhatsApp Academic Team
                  </span>
                  <span className="text-[11px] text-slate-500">+91 99141 22256 (Instant reply)</span>
                </div>
              </div>
            </a>

            {/* Direct Call */}
            <a
              href="tel:+911835080005"
              className="flex items-center justify-between p-3 rounded-xl bg-blue-50 hover:bg-blue-100 border border-blue-200/60 transition-all group"
            >
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-full bg-radiance-blue text-white flex items-center justify-center shadow-sm">
                  <Phone className="w-4 h-4" />
                </div>
                <div>
                  <span className="font-bold text-xs text-slate-900 group-hover:text-radiance-blue block">
                    Call Office Direct
                  </span>
                  <span className="text-[11px] text-slate-500">0183 508 0005 / 98156 22256</span>
                </div>
              </div>
            </a>

            {/* Visit Office */}
            <Link
              href="/contact"
              onClick={() => setIsOpen(false)}
              className="flex items-center justify-between p-3 rounded-xl bg-slate-50 hover:bg-slate-100 border border-slate-200 transition-all group"
            >
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 rounded-full bg-slate-700 text-white flex items-center justify-center shadow-sm">
                  <MapPin className="w-4 h-4" />
                </div>
                <div>
                  <span className="font-bold text-xs text-slate-900 block">
                    Campus Directions
                  </span>
                  <span className="text-[11px] text-slate-500">85-A, Rani Ka Bagh, Amritsar</span>
                </div>
              </div>
            </Link>
          </div>
        </div>
      )}

      {/* Floating Pill / Trigger Button */}
      <button
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Connect with Radiance Institute"
        className="flex items-center gap-2 bg-gradient-to-r from-radiance-blue via-blue-700 to-slate-900 text-white px-3.5 py-3 sm:px-5 sm:py-3 rounded-full shadow-2xl shadow-blue-500/25 hover:shadow-blue-500/40 hover:scale-105 active:scale-95 transition-all group border border-white/20"
      >
        <span className="relative flex h-2.5 w-2.5">
          <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
          <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-amber-400"></span>
        </span>
        <div className="flex items-center gap-1.5 text-xs font-bold tracking-wide">
          <Instagram className="w-4 h-4 text-pink-300" />
          <span className="hidden sm:inline">Connect with Radiance</span>
          <span className="sm:hidden font-bold">Connect</span>
        </div>
      </button>
    </div>
  );
}

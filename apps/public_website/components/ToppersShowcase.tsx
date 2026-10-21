"use client";

import { useState } from "react";
import Image from "next/image";
import {
  Award,
  Sparkles,
  Trophy,
  GraduationCap,
  Star,
  Quote,
  CheckCircle,
} from "lucide-react";

interface Topper {
  id: string;
  name: string;
  exam: string;
  category: "all" | "jee" | "neet" | "foundation" | "boards";
  rankOrScore: string;
  subtext: string;
  school: string;
  year: string;
  quote: string;
  badgeColor: string;
  image: string;
}

const TOPPERS_DATA: Topper[] = [
  {
    id: "top-1",
    name: "Shubham Maini",
    exam: "NEET-UG & Senior Secondary Medical",
    category: "neet",
    rankOrScore: "685 / 720",
    subtext: "Selected at Top Govt Medical College",
    school: "DAV International School, Amritsar",
    year: "2025",
    quote:
      "Physics was my biggest fear until I attended Er. Bedi Sir's lectures at Radiance Institute. His conceptual derivations made numericals second nature for me.",
    badgeColor: "bg-emerald-500",
    image: "/images/student_testimonial.jpg",
  },
  {
    id: "top-2",
    name: "Lavanya Mahajan",
    exam: "JEE Advanced (IIT Selection)",
    category: "jee",
    rankOrScore: "AIR 412",
    subtext: "99.86 Percentile in Physics",
    school: "Spring Dale Senior School, Amritsar",
    year: "2025",
    quote:
      "The rigorous problem sets and Irodov sessions at Radiance gave me the exact analytical edge needed for JEE Advanced. Radiance's disciplined environment is unmatched.",
    badgeColor: "bg-blue-600",
    image: "/images/student_testimonial.jpg",
  },
  {
    id: "top-3",
    name: "Guneet Kalsi",
    exam: "JEE Main Physics Topper",
    category: "jee",
    rankOrScore: "100 Percentile",
    subtext: "Amritsar District Rank 1",
    school: "Delhi Public School, Amritsar",
    year: "2026",
    quote:
      "Scoring a perfect 100 percentile in Physics seemed impossible until Er. Bedi Sir systematically broke down rotational mechanics and electrodynamics. Thank you Radiance!",
    badgeColor: "bg-indigo-600",
    image: "/images/student_testimonial.jpg",
  },
  {
    id: "top-4",
    name: "Rehaan Goenka",
    exam: "Class 10 NTSE & Pre-Foundation",
    category: "foundation",
    rankOrScore: "NTSE Scholar",
    subtext: "State Rank 4 in Junior Science Olympiad",
    school: "St. Francis School, Amritsar",
    year: "2026",
    quote:
      "The Foundation Academy at Radiance built my mental math and analytical reasoning from Class 8. It gave me complete clarity before entering Class 11 PCM.",
    badgeColor: "bg-purple-600",
    image: "/images/student_testimonial.jpg",
  },
  {
    id: "top-5",
    name: "Simranjeet Kaur",
    exam: "CBSE Class 12 Boards (PCM)",
    category: "boards",
    rankOrScore: "98.4% Aggregate",
    subtext: "99/100 in Physics & Chemistry",
    school: "Holy Heart Presidency, Amritsar",
    year: "2025",
    quote:
      "Radiance Institute doesn't just train for competitive exams; they ensure board answer writing and derivations are flawless. The faculty's personal doubt sessions were invaluable.",
    badgeColor: "bg-amber-500",
    image: "/images/student_testimonial.jpg",
  },
  {
    id: "top-6",
    name: "Harshvardhan Arora",
    exam: "JEE Main & Punjab State Ranker",
    category: "jee",
    rankOrScore: "99.45%ile",
    subtext: "Admitted to NIT Jalandhar Computer Science",
    school: "Bhavan's SL Public School, Amritsar",
    year: "2025",
    quote:
      "From daily DPPs to Sunday mock test simulations with negative marking, Radiance creates real exam temperament. Rani Ka Bagh is truly the home of Amritsar's top rankers.",
    badgeColor: "bg-blue-600",
    image: "/images/student_testimonial.jpg",
  },
];

export default function ToppersShowcase() {
  const [activeTab, setActiveTab] = useState<string>("all");

  const filteredToppers =
    activeTab === "all"
      ? TOPPERS_DATA
      : TOPPERS_DATA.filter((t) => t.category === activeTab);

  return (
    <section className="py-16 sm:py-20 bg-white relative overflow-hidden" id="toppers">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Section Header */}
        <div className="text-center max-w-3xl mx-auto mb-10 sm:mb-14">
          <div className="inline-flex items-center gap-2 bg-amber-50 text-amber-800 text-xs font-bold px-3.5 py-1.5 rounded-full border border-amber-200 shadow-sm mb-3">
            <Trophy className="w-3.5 h-3.5 text-amber-600" />
            <span>Proven Track Record • Bedi College Legacy</span>
          </div>
          <h2 className="font-display text-2xl sm:text-3xl lg:text-4xl font-extrabold text-slate-900 tracking-tight">
            Hall of Fame: Our City &amp; State Toppers
          </h2>
          <p className="text-xs sm:text-base text-slate-600 mt-2 leading-relaxed">
            Consistently producing top percentiles and selections in JEE Main, JEE Advanced, NEET,
            and CBSE Board Examinations from Amritsar.
          </p>

          {/* Interactive Filter Pills (Touch friendly swipeable on mobile) */}
          <div className="w-full overflow-x-auto no-scrollbar pt-6 pb-1">
            <div className="flex items-center justify-start sm:justify-center gap-2 min-w-max mx-auto">
              {[
                { id: "all", label: "All Achievers" },
                { id: "jee", label: "JEE Main & Advanced" },
                { id: "neet", label: "NEET Medical" },
                { id: "boards", label: "CBSE 95%+ Boards" },
                { id: "foundation", label: "Olympiads & NTSE" },
              ].map((tab) => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`text-xs font-bold px-4 py-2 sm:px-5 sm:py-2.5 rounded-xl transition-all ${
                    activeTab === tab.id
                      ? "bg-slate-900 text-white shadow-md shadow-slate-900/10"
                      : "bg-slate-100 hover:bg-slate-200 text-slate-700"
                  }`}
                >
                  {tab.label}
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Toppers Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 sm:gap-8">
          {filteredToppers.map((topper) => (
            <div
              key={topper.id}
              className="group bg-gradient-to-b from-white to-slate-50/60 rounded-3xl border border-slate-200/90 hover:border-radiance-blue/40 p-5 sm:p-6 shadow-sm hover:shadow-xl hover:-translate-y-0.5 transition-all duration-300 flex flex-col justify-between relative"
            >
              {/* Top Score Badge */}
              <div className="flex items-start justify-between gap-3 mb-4">
                <div>
                  <span className="text-[10px] sm:text-[11px] font-black uppercase tracking-wider text-slate-400">
                    {topper.exam}
                  </span>
                  <div className="font-display text-2xl sm:text-3xl font-black text-slate-900 mt-0.5 tracking-tight">
                    {topper.rankOrScore}
                  </div>
                  <span className="inline-flex items-center gap-1 text-xs font-semibold text-radiance-blue mt-1">
                    <CheckCircle className="w-3.5 h-3.5 text-blue-600 shrink-0" />
                    <span>{topper.subtext}</span>
                  </span>
                </div>

                <div className="shrink-0 w-11 h-11 sm:w-12 sm:h-12 rounded-2xl bg-amber-50 border border-amber-200 flex items-center justify-center text-amber-600 group-hover:scale-105 transition-transform shadow-sm">
                  <Trophy className="w-5 h-5 sm:w-6 sm:h-6" />
                </div>
              </div>

              {/* Quote */}
              <div className="relative bg-white rounded-2xl p-4 border border-slate-100 mb-4 shadow-sm">
                <Quote className="w-4 h-4 text-slate-300 absolute -top-2 -left-1 fill-slate-100" />
                <p className="text-xs sm:text-sm text-slate-600 italic leading-relaxed pl-1.5">
                  "{topper.quote}"
                </p>
              </div>

              {/* Student Bio */}
              <div className="pt-3.5 border-t border-slate-100 flex items-center gap-3">
                <div className="relative w-10 h-10 rounded-full overflow-hidden border-2 border-radiance-blue/30 shrink-0 bg-slate-100">
                  <Image
                    src={topper.image}
                    alt={topper.name}
                    fill
                    className="object-cover"
                  />
                </div>
                <div className="min-w-0 flex-1">
                  <h4 className="font-display font-bold text-slate-900 text-sm truncate">
                    {topper.name}
                  </h4>
                  <p className="text-[11px] sm:text-xs text-slate-500 truncate">
                    {topper.school} • Batch of {topper.year}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Bottom Stat Banner */}
        <div className="mt-12 sm:mt-16 grid grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-6 bg-gradient-to-br from-radiance-midnight via-radiance-navy to-[#0F2848] text-white rounded-3xl p-6 sm:p-8 text-center shadow-xl border border-white/10">
          <div className="p-2 sm:p-0">
            <div className="font-display text-2xl sm:text-3xl font-black text-amber-400">98.6%</div>
            <p className="text-[11px] sm:text-xs text-slate-300 mt-1 font-medium">Board Distinction Rate</p>
          </div>
          <div className="p-2 sm:p-0">
            <div className="font-display text-2xl sm:text-3xl font-black text-amber-400">45+</div>
            <p className="text-[11px] sm:text-xs text-slate-300 mt-1 font-medium">IIT / NIT / AIIMS Ranks</p>
          </div>
          <div className="p-2 sm:p-0">
            <div className="font-display text-2xl sm:text-3xl font-black text-amber-400">25:1</div>
            <p className="text-[11px] sm:text-xs text-slate-300 mt-1 font-medium">Max Student-Teacher Ratio</p>
          </div>
          <div className="p-2 sm:p-0">
            <div className="font-display text-2xl sm:text-3xl font-black text-amber-400">28+</div>
            <p className="text-[11px] sm:text-xs text-slate-300 mt-1 font-medium">Years Academic Legacy</p>
          </div>
        </div>
      </div>
    </section>
  );
}

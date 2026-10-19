"use client";

import { useState } from "react";
import Link from "next/link";
import {
  Calculator,
  Percent,
  Sparkles,
  CheckCircle2,
  Calendar,
  CreditCard,
  ArrowRight,
  ShieldCheck,
} from "lucide-react";

interface ProgramPlan {
  id: string;
  classLevel: string;
  name: string;
  baseAnnualFee: number; // in rupees
  duration: string;
  subjects: string[];
  features: string[];
}

const PROGRAM_PLANS: ProgramPlan[] = [
  {
    id: "foundation-junior",
    classLevel: "Classes 6, 7 & 8",
    name: "Middle School Pre-Foundation Academy",
    baseAnnualFee: 32000,
    duration: "1 Year Academic Session",
    subjects: ["Mathematics", "General Science", "Mental Ability & Reasoning"],
    features: [
      "Weekly concept quizzes & mental math speed drills",
      "School board exam syllabus full coverage",
      "Olympiad & NTSE readiness orientation",
      "Regular parent performance reviews",
    ],
  },
  {
    id: "foundation-senior",
    classLevel: "Classes 9 & 10",
    name: "Secondary Board & Pre-Competitive Prep",
    baseAnnualFee: 42000,
    duration: "1 Year Academic Session",
    subjects: ["Science (Physics, Chemistry, Biology)", "Standard & Basic Mathematics", "Mental Ability"],
    features: [
      "Rigorous CBSE board question bank practice",
      "Foundation for Class 11 PCM / Medical streams",
      "Bi-weekly test series with instant grading",
      "Small batch size of max 25 students",
    ],
  },
  {
    id: "senior-pcm",
    classLevel: "Class 11 (PCM)",
    name: "Class 11 Senior Secondary PCM + JEE Main",
    baseAnnualFee: 65000,
    duration: "1 Year Academic Session (April to March)",
    subjects: ["Physics by Er. Bedi Sir", "Chemistry (Org/Inorg/Physical)", "Mathematics"],
    features: [
      "Er. Bedi Sir's Physics derivations & numerical clinics",
      "Complete CBSE/ICSE board syllabus + JEE Main level problem solving",
      "Laboratory demonstrations & practical exam training",
      "Sunday grand simulation test series with full analysis",
    ],
  },
  {
    id: "senior-pcm-12",
    classLevel: "Class 12 (PCM)",
    name: "Class 12 Board Distinction + JEE Advanced",
    baseAnnualFee: 72000,
    duration: "1 Year Academic Session + Revision Crash Course",
    subjects: ["Physics by Er. Bedi Sir", "Chemistry", "Mathematics"],
    features: [
      "Mastery of modern physics, electromagnetism & calculus",
      "Last 15 years board papers & JEE Advanced problem archives",
      "Dedicated doubt sessions with subject specialists",
      "Verified mock test marks cards sent to parents via app",
    ],
  },
  {
    id: "physics-special",
    classLevel: "Class 11 & 12 (Physics Only)",
    name: "Physics Mastery Track by Er. Bedi Sir",
    baseAnnualFee: 35000,
    duration: "Full Academic Year",
    subjects: ["Advanced Theoretical & Numerical Physics"],
    features: [
      "Direct guidance under Er. Bedi Sir (25+ yrs experience)",
      "HC Verma, Irodov & past 20-yr JEE/NEET problem sheets",
      "Conceptual experiments and video simulation demos",
      "Special weekend numerical problem solving sessions",
    ],
  },
];

export default function CourseFeeCalculator() {
  const [selectedPlanId, setSelectedPlanId] = useState<string>("senior-pcm");
  const [previousMarks, setPreviousMarks] = useState<number>(88);
  const [selectedInstallmentPlan, setSelectedInstallmentPlan] = useState<"annual" | "quarterly">(
    "quarterly"
  );

  const selectedPlan =
    PROGRAM_PLANS.find((p) => p.id === selectedPlanId) || PROGRAM_PLANS[2];

  // Scholarship Tier Calculation
  let scholarshipPercent = 0;
  let scholarshipBadge = "Standard Merit";

  if (previousMarks >= 95) {
    scholarshipPercent = 30;
    scholarshipBadge = "🌟 Super 30 Academic Excellence Tier (30% Waiver)";
  } else if (previousMarks >= 90) {
    scholarshipPercent = 20;
    scholarshipBadge = "⭐ Radiance Scholar Tier (20% Waiver)";
  } else if (previousMarks >= 80) {
    scholarshipPercent = 10;
    scholarshipBadge = "✨ Early Bird Merit Tier (10% Waiver)";
  } else {
    scholarshipPercent = 0;
    scholarshipBadge = "Standard Tuition Fee";
  }

  const discountAmount = Math.round((selectedPlan.baseAnnualFee * scholarshipPercent) / 100);
  const netAnnualFee = selectedPlan.baseAnnualFee - discountAmount;
  const quarterlyInstallment = Math.round(netAnnualFee / 4);

  return (
    <section className="py-20 bg-slate-50 relative overflow-hidden" id="calculator">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center max-w-3xl mx-auto mb-14">
          <div className="inline-flex items-center gap-2 bg-blue-100/70 text-radiance-blue text-xs font-bold px-3.5 py-1.5 rounded-full mb-3">
            <Calculator className="w-3.5 h-3.5" />
            <span>Interactive Transparency Tool</span>
          </div>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy tracking-tight">
            Fee Estimator & Merit Scholarship Calculator
          </h2>
          <p className="text-base text-slate-600 mt-2">
            Calculate your personalized tuition plan, explore flexible payment installments, and
            check your instant scholarship eligibility based on previous academic performance.
          </p>
        </div>

        {/* Interactive Calculator Body */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Left Column: Form Controls */}
          <div className="lg:col-span-7 bg-white rounded-3xl p-6 sm:p-8 border border-slate-200/90 shadow-md space-y-7">
            {/* Step 1: Select Academic Program */}
            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 mb-3">
                1. Select Academic Grade & Program
              </label>
              <div className="space-y-2.5">
                {PROGRAM_PLANS.map((plan) => (
                  <div
                    key={plan.id}
                    onClick={() => setSelectedPlanId(plan.id)}
                    className={`cursor-pointer rounded-2xl p-4 border transition-all flex items-center justify-between ${
                      selectedPlanId === plan.id
                        ? "border-radiance-blue bg-blue-50/50 shadow-sm"
                        : "border-slate-200 hover:border-slate-300 bg-white"
                    }`}
                  >
                    <div>
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-semibold px-2.5 py-0.5 rounded-full bg-slate-100 text-slate-700">
                          {plan.classLevel}
                        </span>
                        <h4 className="font-bold text-slate-900 text-sm">{plan.name}</h4>
                      </div>
                      <p className="text-xs text-slate-500 mt-1">
                        Subjects: {plan.subjects.join(", ")}
                      </p>
                    </div>
                    <div className="text-right pl-3 shrink-0">
                      <span className="text-xs text-slate-400 block">Base Annual</span>
                      <span className="text-sm font-bold text-slate-900">
                        ₹{plan.baseAnnualFee.toLocaleString("en-IN")}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Step 2: Previous Exam Marks Slider */}
            <div>
              <div className="flex justify-between items-center mb-2">
                <label className="text-xs font-bold uppercase tracking-wider text-slate-500">
                  2. Your Previous Class / Board Score (%)
                </label>
                <span className="text-base font-extrabold text-radiance-blue bg-blue-50 px-3 py-1 rounded-xl border border-blue-200">
                  {previousMarks}%
                </span>
              </div>
              <input
                type="range"
                min="50"
                max="100"
                value={previousMarks}
                onChange={(e) => setPreviousMarks(Number(e.target.value))}
                className="w-full h-2.5 bg-slate-200 rounded-lg appearance-none cursor-pointer accent-radiance-blue"
              />
              <div className="flex justify-between text-[11px] text-slate-400 mt-1 font-medium">
                <span>50%</span>
                <span>80% (10% Off)</span>
                <span>90% (20% Off)</span>
                <span>95%+ (30% Off)</span>
                <span>100%</span>
              </div>

              {/* Scholarship Tier Badge */}
              <div className="mt-3 p-3 bg-amber-50 rounded-xl border border-amber-200/80 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-1.5 sm:gap-2">
                <span className="text-xs font-bold text-amber-900 flex items-center gap-1.5">
                  <Sparkles className="w-4 h-4 text-amber-600 shrink-0" />
                  <span>{scholarshipBadge}</span>
                </span>
                <span className="text-xs font-extrabold text-amber-700 bg-amber-100/60 px-2 py-0.5 rounded">
                  Save ₹{discountAmount.toLocaleString("en-IN")}
                </span>
              </div>
            </div>

            {/* Step 3: Installment Mode */}
            <div>
              <label className="block text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">
                3. Choose Payment Structure
              </label>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                <button
                  type="button"
                  onClick={() => setSelectedInstallmentPlan("quarterly")}
                  className={`p-3.5 rounded-xl border text-left transition-all ${
                    selectedInstallmentPlan === "quarterly"
                      ? "border-radiance-blue bg-blue-50 text-radiance-navy font-bold shadow-sm"
                      : "border-slate-200 text-slate-600 hover:bg-slate-50"
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <Calendar className="w-4 h-4 text-radiance-blue shrink-0" />
                    <span className="text-xs font-bold">4 Quarterly Installments</span>
                  </div>
                  <span className="text-[11px] text-slate-500 block mt-1">
                    Flexible fee schedule every 3 months
                  </span>
                </button>

                <button
                  type="button"
                  onClick={() => setSelectedInstallmentPlan("annual")}
                  className={`p-3.5 rounded-xl border text-left transition-all ${
                    selectedInstallmentPlan === "annual"
                      ? "border-radiance-blue bg-blue-50 text-radiance-navy font-bold shadow-sm"
                      : "border-slate-200 text-slate-600 hover:bg-slate-50"
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <CreditCard className="w-4 h-4 text-radiance-blue shrink-0" />
                    <span className="text-xs font-bold">1-Time Annual Payment</span>
                  </div>
                  <span className="text-[11px] text-slate-500 block mt-1">
                    Includes all study materials &amp; mock tests
                  </span>
                </button>
              </div>
            </div>
          </div>

          {/* Right Column: Instant Fee Breakdown Card */}
          <div className="lg:col-span-5 bg-gradient-to-br from-radiance-navy to-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-2xl relative overflow-hidden flex flex-col justify-between">
            {/* Background pattern */}
            <div className="absolute top-0 right-0 w-64 h-64 bg-radiance-blue/20 rounded-full blur-2xl pointer-events-none" />

            <div className="relative z-10 space-y-6">
              <div className="flex items-center justify-between pb-4 border-b border-white/10">
                <span className="text-xs font-semibold text-amber-400 uppercase tracking-wider">
                  Live Fee Quote
                </span>
                <span className="text-xs text-slate-300">{selectedPlan.duration}</span>
              </div>

              <div>
                <h3 className="text-xl sm:text-2xl font-bold">{selectedPlan.name}</h3>
                <p className="text-xs text-slate-300 mt-1">
                  Classroom coaching at 85-A, Rani Ka Bagh, Amritsar
                </p>
              </div>

              {/* Price Calculation Table */}
              <div className="space-y-3 bg-white/5 rounded-2xl p-4 border border-white/10 text-xs sm:text-sm">
                <div className="flex justify-between text-slate-300">
                  <span>Gross Tuition Fee:</span>
                  <span>₹{selectedPlan.baseAnnualFee.toLocaleString("en-IN")}</span>
                </div>

                {scholarshipPercent > 0 && (
                  <div className="flex justify-between text-amber-400 font-semibold">
                    <span>Merit Scholarship Discount ({scholarshipPercent}%):</span>
                    <span>-₹{discountAmount.toLocaleString("en-IN")}</span>
                  </div>
                )}

                <div className="flex justify-between text-slate-300">
                  <span>Study Modules & DPPs:</span>
                  <span className="text-emerald-400 font-medium">Included (₹0)</span>
                </div>

                <div className="flex justify-between text-slate-300">
                  <span>Sunday Test Series & Analytics:</span>
                  <span className="text-emerald-400 font-medium">Included (₹0)</span>
                </div>

                <div className="pt-3 border-t border-white/15 flex justify-between items-baseline">
                  <span className="text-sm font-bold text-white">Net Total Fee:</span>
                  <span className="text-2xl sm:text-3xl font-extrabold text-amber-400">
                    ₹{netAnnualFee.toLocaleString("en-IN")}
                  </span>
                </div>

                {selectedInstallmentPlan === "quarterly" && (
                  <div className="text-[11px] text-slate-300 bg-white/10 p-2.5 rounded-lg text-center mt-2">
                    Payable in 4 easy installments of{" "}
                    <strong className="text-white text-xs">
                      ₹{quarterlyInstallment.toLocaleString("en-IN")} / quarter
                    </strong>
                  </div>
                )}
              </div>

              {/* Plan Highlights */}
              <div className="space-y-2">
                <span className="text-xs font-bold uppercase tracking-wider text-slate-400">
                  What's included in this program:
                </span>
                <ul className="space-y-1.5 text-xs text-slate-200">
                  {selectedPlan.features.map((feat, i) => (
                    <li key={i} className="flex items-start gap-2">
                      <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 shrink-0 mt-0.5" />
                      <span>{feat}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </div>

            {/* Action CTA */}
            <div className="relative z-10 pt-6 mt-6 border-t border-white/10 space-y-3">
              <Link
                href={`/admissions?classLevel=${encodeURIComponent(
                  selectedPlan.classLevel
                )}&program=${encodeURIComponent(selectedPlan.name)}`}
                className="w-full inline-flex items-center justify-center gap-2 bg-amber-400 hover:bg-amber-500 text-radiance-navy font-bold text-sm py-3.5 px-6 rounded-xl shadow-lg transition-all"
              >
                <span>Enquire With This Fee Plan</span>
                <ArrowRight className="w-4 h-4" />
              </Link>
              <div className="flex items-center justify-center gap-1.5 text-[11px] text-slate-400 text-center">
                <ShieldCheck className="w-3.5 h-3.5 text-emerald-400" />
                <span>Zero hidden charges • 3-Day risk-free trial classes included</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

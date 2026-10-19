"use client";

import { useState } from "react";
import Link from "next/link";
import {
  Calendar,
  Clock,
  User,
  Users,
  CheckCircle2,
  AlertCircle,
  Sparkles,
  ArrowRight,
  BookOpen,
} from "lucide-react";

interface Batch {
  id: string;
  name: string;
  classLevel: "6-8" | "9-10" | "11" | "12";
  subject: string;
  faculty: string;
  days: string;
  timing: string;
  classroom: string;
  capacity: number;
  enrolled: number;
  status: "Open" | "Filling Fast" | "Weekend Special";
  badgeColor: string;
}

const BATCHES_DATA: Batch[] = [
  {
    id: "batch-c11-phys-bedi",
    name: "JEE Advanced Physics Alpha",
    classLevel: "11",
    subject: "Physics (Mechanics & Waves)",
    faculty: "Er. Bedi Sir (Senior Physics Master)",
    days: "Mon, Wed, Fri",
    timing: "04:30 PM – 06:00 PM",
    classroom: "Hall A (Physics Demonstration Lab)",
    capacity: 30,
    enrolled: 24,
    status: "Filling Fast",
    badgeColor: "bg-amber-100 text-amber-800 border-amber-300",
  },
  {
    id: "batch-c12-phys-bedi",
    name: "JEE & Board Physics Mastery",
    classLevel: "12",
    subject: "Physics (Electrodynamics & Modern Physics)",
    faculty: "Er. Bedi Sir",
    days: "Tue, Thu, Sat",
    timing: "05:00 PM – 06:30 PM",
    classroom: "Hall A",
    capacity: 30,
    enrolled: 27,
    status: "Filling Fast",
    badgeColor: "bg-red-100 text-red-800 border-red-300",
  },
  {
    id: "batch-c11-chem",
    name: "Class 11 Chemistry Core",
    classLevel: "11",
    subject: "Chemistry (Physical & Organic)",
    faculty: "Prof. S. Sharma (M.Sc. Gold Medalist)",
    days: "Tue, Thu, Sat",
    timing: "03:30 PM – 05:00 PM",
    classroom: "Lecture Hall B",
    capacity: 28,
    enrolled: 18,
    status: "Open",
    badgeColor: "bg-emerald-100 text-emerald-800 border-emerald-300",
  },
  {
    id: "batch-c12-math",
    name: "Class 12 Calculus & Vectors Elite",
    classLevel: "12",
    subject: "Mathematics (JEE Main & Boards)",
    faculty: "Er. R. K. Verma",
    days: "Mon, Wed, Fri",
    timing: "06:00 PM – 07:30 PM",
    classroom: "Lecture Hall C",
    capacity: 25,
    enrolled: 20,
    status: "Open",
    badgeColor: "bg-emerald-100 text-emerald-800 border-emerald-300",
  },
  {
    id: "batch-c10-foundation",
    name: "Class 10 Board Excellence & NTSE",
    classLevel: "9-10",
    subject: "Science & Mathematics (Combined)",
    faculty: "Foundation Specialist Faculty",
    days: "Mon, Wed, Fri",
    timing: "03:30 PM – 05:30 PM",
    classroom: "Junior Scholars Hall",
    capacity: 25,
    enrolled: 21,
    status: "Filling Fast",
    badgeColor: "bg-amber-100 text-amber-800 border-amber-300",
  },
  {
    id: "batch-c9-foundation",
    name: "Class 9 Pre-Foundation Genius",
    classLevel: "9-10",
    subject: "Physics, Chem & Math Fundamentals",
    faculty: "Foundation Mentors",
    days: "Tue, Thu, Sat",
    timing: "04:00 PM – 05:30 PM",
    classroom: "Junior Scholars Hall",
    capacity: 25,
    enrolled: 16,
    status: "Open",
    badgeColor: "bg-emerald-100 text-emerald-800 border-emerald-300",
  },
  {
    id: "batch-c68-junior",
    name: "Junior Foundation Academy (6, 7 & 8)",
    classLevel: "6-8",
    subject: "Maths, Science & Mental Ability",
    faculty: "Senior Junior Faculty",
    days: "Mon, Wed, Fri",
    timing: "04:00 PM – 05:30 PM",
    classroom: "Interactive Activity Studio",
    capacity: 20,
    enrolled: 13,
    status: "Open",
    badgeColor: "bg-emerald-100 text-emerald-800 border-emerald-300",
  },
  {
    id: "batch-weekend-grand",
    name: "Sunday Grand Test & Doubts Clinic",
    classLevel: "11",
    subject: "All Subjects (PCM/Medical)",
    faculty: "Er. Bedi Sir & Subject Team",
    days: "Every Sunday",
    timing: "10:00 AM – 01:00 PM",
    classroom: "Main Examination Hall",
    capacity: 80,
    enrolled: 64,
    status: "Weekend Special",
    badgeColor: "bg-purple-100 text-purple-800 border-purple-300",
  },
];

export default function BatchScheduleExplorer() {
  const [filterClass, setFilterClass] = useState<string>("all");

  const filteredBatches =
    filterClass === "all"
      ? BATCHES_DATA
      : BATCHES_DATA.filter((b) => b.classLevel === filterClass);

  return (
    <section className="py-20 bg-white relative" id="batches">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 mb-12">
          <div>
            <div className="inline-flex items-center gap-2 bg-blue-50 text-radiance-blue text-xs font-bold px-3 py-1 rounded-full mb-2">
              <Calendar className="w-3.5 h-3.5" />
              <span>Real-Time Academic Timetable</span>
            </div>
            <h2 className="text-3xl font-extrabold text-radiance-navy tracking-tight">
              Interactive Batch Schedule & Live Seat Status
            </h2>
            <p className="text-sm sm:text-base text-slate-600 mt-1 max-w-2xl">
              Strictly capped batch sizes ensure optimal teacher-to-student interaction. Check
              schedule timings and remaining seats for the 2026 academic session.
            </p>
          </div>

          {/* Filter Pills */}
          <div className="flex flex-wrap items-center gap-2">
            {[
              { id: "all", label: "All Batches" },
              { id: "12", label: "Class 12 (PCM)" },
              { id: "11", label: "Class 11 (PCM)" },
              { id: "9-10", label: "Classes 9 & 10" },
              { id: "6-8", label: "Classes 6 to 8" },
            ].map((f) => (
              <button
                key={f.id}
                onClick={() => setFilterClass(f.id)}
                className={`text-xs font-semibold px-4 py-2 rounded-full transition-all ${
                  filterClass === f.id
                    ? "bg-radiance-navy text-white shadow"
                    : "bg-slate-100 hover:bg-slate-200 text-slate-700"
                }`}
              >
                {f.label}
              </button>
            ))}
          </div>
        </div>

        {/* Batch Cards Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredBatches.map((batch) => {
            const seatsRemaining = batch.capacity - batch.enrolled;
            const percentFilled = Math.round((batch.enrolled / batch.capacity) * 100);

            return (
              <div
                key={batch.id}
                className="bg-white rounded-2xl border border-slate-200 p-6 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col justify-between"
              >
                <div>
                  {/* Top Bar */}
                  <div className="flex items-start justify-between gap-3 mb-3">
                    <span className="text-xs font-bold px-2.5 py-1 rounded-md bg-blue-50 text-radiance-blue border border-blue-100">
                      {batch.subject}
                    </span>
                    <span
                      className={`text-[11px] font-bold px-2.5 py-0.5 rounded-full border ${batch.badgeColor}`}
                    >
                      {batch.status}
                    </span>
                  </div>

                  <h3 className="font-extrabold text-base text-slate-900 group-hover:text-radiance-blue">
                    {batch.name}
                  </h3>

                  {/* Faculty Badge */}
                  <div className="flex items-center gap-2 mt-2 text-xs font-semibold text-slate-700 bg-slate-50 p-2 rounded-lg">
                    <User className="w-4 h-4 text-radiance-blue shrink-0" />
                    <span>{batch.faculty}</span>
                  </div>

                  {/* Timing & Days */}
                  <div className="space-y-2 mt-4 text-xs text-slate-600">
                    <div className="flex items-center gap-2">
                      <Calendar className="w-4 h-4 text-slate-400 shrink-0" />
                      <span>{batch.days}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-slate-400 shrink-0" />
                      <span className="font-medium text-slate-800">{batch.timing}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <BookOpen className="w-4 h-4 text-slate-400 shrink-0" />
                      <span>{batch.classroom}</span>
                    </div>
                  </div>
                </div>

                {/* Seat Capacity Progress & CTA */}
                <div className="mt-6 pt-4 border-t border-slate-100">
                  <div className="flex justify-between items-center text-xs mb-1.5">
                    <span className="text-slate-500 flex items-center gap-1">
                      <Users className="w-3.5 h-3.5" />
                      <span>Batch Capacity</span>
                    </span>
                    <span className="font-bold text-slate-800">
                      {batch.enrolled}/{batch.capacity} seats ({seatsRemaining} left)
                    </span>
                  </div>

                  {/* Progress Bar */}
                  <div className="w-full h-2 bg-slate-100 rounded-full overflow-hidden">
                    <div
                      className={`h-full transition-all duration-500 ${
                        percentFilled > 80
                          ? "bg-amber-500"
                          : percentFilled > 60
                          ? "bg-blue-600"
                          : "bg-emerald-500"
                      }`}
                      style={{ width: `${percentFilled}%` }}
                    />
                  </div>

                  <Link
                    href={`/admissions?batch=${encodeURIComponent(batch.name)}`}
                    className="mt-4 w-full inline-flex items-center justify-center gap-1.5 bg-slate-100 hover:bg-radiance-blue hover:text-white text-slate-800 font-bold text-xs py-2.5 rounded-xl transition-all"
                  >
                    <span>Reserve Free 3-Day Demo</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </Link>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

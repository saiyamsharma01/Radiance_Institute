import type { Metadata } from "next";
import Link from "next/link";
import { ArrowRight, BookOpen, Check } from "lucide-react";

export const metadata: Metadata = {
  title: "Classes 6 to 12 Academic Offerings | Radiance Institute",
  description:
    "Explore class-wise academic programs at Radiance Institute Amritsar, covering middle school foundations (6-8), secondary board preparation (9-10), and senior secondary PCM (11-12).",
};

export default function ClassesPage() {
  const classesList = [
    {
      level: "6",
      name: "Class 6 Foundation",
      category: "Middle School",
      subjects: ["Mathematics", "General Science", "Reasoning Basics"],
      desc: "Instills study discipline and foundational numeracy and scientific inquiry during the transition from primary school.",
    },
    {
      level: "7",
      name: "Class 7 Foundation",
      category: "Middle School",
      subjects: ["Mathematics", "Physics Basics", "Chemistry Basics", "Biology"],
      desc: "Strengthens algebraic basics, geometric constructions, and fundamental principles of energy and matter.",
    },
    {
      level: "8",
      name: "Class 8 Foundation",
      category: "Middle School",
      subjects: ["Advanced Mathematics", "General Science", "Aptitude"],
      desc: "Prepares students for high school rigors with structured problem solving in equations, mensuration, and sciences.",
    },
    {
      level: "9",
      name: "Class 9 Pre-Board",
      category: "Secondary",
      subjects: ["Mathematics", "Physics", "Chemistry", "Biology"],
      desc: "Crucial foundation year covering mechanics, matter, and advanced algebra that forms the backbone for board exams.",
    },
    {
      level: "10",
      name: "Class 10 Board Excellence",
      category: "Secondary",
      subjects: ["Mathematics", "Science & Technology", "Mock Test Series"],
      desc: "Targeted board exam preparation with extensive previous years' question analysis, answer presentation, and full syllabus tests.",
    },
    {
      level: "11",
      name: "Class 11 Senior Secondary (PCM)",
      category: "Senior Secondary",
      subjects: ["Physics", "Chemistry", "Mathematics"],
      desc: "Comprehensive senior secondary curriculum focusing on deep derivations, physical models, organic synthesis, and calculus.",
    },
    {
      level: "12",
      name: "Class 12 Senior Secondary (PCM)",
      category: "Senior Secondary",
      subjects: ["Physics", "Chemistry", "Mathematics"],
      desc: "Rigorous board revision, numerical drills, laboratory theory, and competitive foundation problem sets.",
    },
  ];

  return (
    <div className="py-16 bg-white">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <div className="text-center max-w-3xl mx-auto space-y-3">
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Official Course Offerings
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Academic Programs for Classes 6 through 12
          </h1>
          <p className="text-sm text-slate-600">
            Choose a grade level below to explore syllabus coverage, subject options, and batch
            schedules at our Rani Ka Bagh, Amritsar campus.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {classesList.map((cls) => (
            <div
              key={cls.level}
              className="border border-slate-200 rounded-xl p-6 bg-white hover:border-radiance-blue/60 hover:shadow-md transition-all flex flex-col justify-between"
            >
              <div>
                <div className="flex justify-between items-center mb-3">
                  <span className="text-xs font-bold px-2.5 py-1 bg-radiance-light text-radiance-blue rounded-md">
                    {cls.category}
                  </span>
                  <span className="text-xs font-semibold text-slate-500">Class {cls.level}</span>
                </div>
                <h2 className="text-lg font-bold text-radiance-navy">{cls.name}</h2>
                <p className="text-xs text-slate-600 mt-2 leading-relaxed">{cls.desc}</p>

                <div className="mt-4 pt-4 border-t border-slate-100">
                  <div className="text-xs font-semibold text-slate-700 mb-2">Key Subjects:</div>
                  <ul className="space-y-1">
                    {cls.subjects.map((sub, i) => (
                      <li key={i} className="text-xs text-slate-600 flex items-center">
                        <Check className="w-3.5 h-3.5 text-radiance-blue mr-1.5 shrink-0" />
                        <span>{sub}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>

              <div className="mt-6 pt-4 border-t border-slate-100 flex justify-between items-center">
                <Link
                  href={`/classes/${cls.level}`}
                  className="text-xs font-bold text-radiance-blue hover:text-blue-800 flex items-center"
                >
                  View Class Details <ArrowRight className="w-3 h-3 ml-1" />
                </Link>
                <Link
                  href="/admissions"
                  className="text-xs text-slate-500 hover:text-radiance-navy font-medium"
                >
                  Enquire
                </Link>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

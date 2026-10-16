import type { Metadata } from "next";
import Link from "next/link";
import { Atom, FlaskConical, Binary, CheckCircle2, ArrowRight } from "lucide-react";

export const metadata: Metadata = {
  title: "Physics, Chemistry & Mathematics Coaching | Radiance Institute Amritsar",
  description:
    "Specialized senior secondary Physics, Chemistry, and Mathematics (PCM) coaching for Classes 11 and 12 at Radiance Institute Amritsar.",
};

export default function SubjectsPage() {
  const subjects = [
    {
      name: "Senior Secondary Physics",
      icon: Atom,
      tagline: "Bridging mathematical formulation with physical intuition",
      classLevels: "Classes 11 & 12",
      description:
        "Physics at the senior secondary level requires transitioning from qualitative facts to rigorous mathematical vector mechanics, electrodynamics, and wave theory.",
      modules: [
        "Kinematics & Vector Dynamics",
        "Rotational Mechanics & Gravitation",
        "Thermodynamics & Kinetic Theory",
        "Electrostatics & Current Electricity",
        "Magnetism & Electromagnetic Induction",
        "Wave Optics & Modern Quantum Physics",
      ],
      approach: "Step-by-step free body diagrams, derivation sheets, and high-volume numerical practice.",
    },
    {
      name: "Senior Secondary Chemistry",
      icon: FlaskConical,
      tagline: "Comprehensive balance of Physical, Organic & Inorganic domains",
      classLevels: "Classes 11 & 12",
      description:
        "Our Chemistry curriculum ensures students master theoretical thermodynamics, molecular symmetry, organic reaction mechanisms, and periodic behavior without feeling overwhelmed.",
      modules: [
        "Chemical Bonding & Molecular Structure",
        "Thermodynamics & Equilibrium",
        "Electrochemistry & Chemical Kinetics",
        "Organic Reaction Mechanisms & Functional Groups",
        "Coordination Compounds & Transition Elements",
        "Biomolecules & Everyday Chemistry",
      ],
      approach: "Mechanism roadmaps, formula flash sheets, and structured concept maps.",
    },
    {
      name: "Senior Secondary Mathematics",
      icon: Binary,
      tagline: "Calculus, Coordinate Geometry & Algebra Mastery",
      classLevels: "Classes 11 & 12",
      description:
        "Mathematics forms the bedrock of analytical reasoning. We train students in algebraic structures, trigonometry, differential and integral calculus, and probabilistic models.",
      modules: [
        "Complex Numbers & Quadratic Equations",
        "Trigonometric Functions & Identities",
        "Differential & Integral Calculus",
        "Vectors & 3-Dimensional Geometry",
        "Matrices, Determinants & Systems of Equations",
        "Probability Distributions & Permutations",
      ],
      approach: "Extensive problem-solving sessions, proof explanations, and speed-accuracy drills.",
    },
  ];

  return (
    <div className="py-16 bg-white">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        {/* Header */}
        <div className="text-center max-w-3xl mx-auto space-y-3">
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Core Academic Specialization
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Senior Secondary Physics, Chemistry & Mathematics
          </h1>
          <p className="text-sm text-slate-600 leading-relaxed">
            Radiance Institute offers dedicated, subject-wise specialized batches for Classes 11 and 12,
            led by experienced faculty focused on board excellence and strong foundational thinking.
          </p>
        </div>

        {/* Subjects List */}
        <div className="space-y-12">
          {subjects.map((sub, idx) => {
            const Icon = sub.icon;
            return (
              <div
                key={idx}
                className="border border-slate-200 rounded-2xl p-8 bg-white hover:border-radiance-blue/40 hover:shadow-lg transition-all"
              >
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                  <div className="lg:col-span-5 space-y-4">
                    <div className="w-14 h-14 rounded-xl bg-radiance-light text-radiance-blue flex items-center justify-center">
                      <Icon className="w-8 h-8" />
                    </div>
                    <div>
                      <span className="text-xs font-bold text-radiance-gold uppercase">
                        {sub.classLevels}
                      </span>
                      <h2 className="text-2xl font-bold text-radiance-navy mt-1">{sub.name}</h2>
                      <p className="text-xs text-radiance-blue font-semibold mt-1">{sub.tagline}</p>
                    </div>
                    <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">
                      {sub.description}
                    </p>
                    <div className="pt-2">
                      <Link
                        href="/admissions"
                        className="inline-flex items-center text-xs font-bold text-radiance-blue hover:text-blue-800"
                      >
                        Enquire for {sub.name} <ArrowRight className="w-3.5 h-3.5 ml-1" />
                      </Link>
                    </div>
                  </div>

                  <div className="lg:col-span-7 bg-slate-50 border border-slate-200/80 rounded-xl p-6 space-y-4">
                    <h3 className="text-sm font-bold text-radiance-navy uppercase tracking-wider">
                      Core Syllabus Modules Covered
                    </h3>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
                      {sub.modules.map((m, i) => (
                        <div key={i} className="flex items-start space-x-2 text-xs text-slate-700">
                          <CheckCircle2 className="w-4 h-4 text-radiance-blue shrink-0 mt-0.5" />
                          <span>{m}</span>
                        </div>
                      ))}
                    </div>
                    <div className="mt-4 pt-4 border-t border-slate-200 text-xs text-slate-600">
                      <strong className="text-radiance-navy font-semibold">Teaching Approach: </strong>
                      {sub.approach}
                    </div>
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Bottom Banner */}
        <div className="bg-radiance-navy text-white rounded-2xl p-8 text-center space-y-4">
          <h3 className="text-2xl font-bold">Class-Wise or Subject-Wise Enrolment Options</h3>
          <p className="text-sm text-slate-300 max-w-2xl mx-auto">
            Students can enroll in complete PCM packages or individual subject batches according to
            their specific academic focus.
          </p>
          <div className="pt-2">
            <Link
              href="/admissions"
              className="inline-block bg-amber-400 hover:bg-amber-500 text-radiance-navy font-bold px-8 py-3 rounded-lg text-sm shadow transition-colors"
            >
              Consult with Academic Coordinator
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";
import { CheckCircle2, ArrowLeft, ArrowRight, BookOpen, Clock, Users } from "lucide-react";

interface Props {
  params: Promise<{ classLevel: string }>;
}

const classData: Record<
  string,
  {
    title: string;
    stage: string;
    tagline: string;
    description: string;
    curriculum: string[];
    features: string[];
  }
> = {
  "6": {
    title: "Class 6 Academic Program",
    stage: "Middle School Foundation",
    tagline: "Nurturing curiosity and mathematical habits early",
    description:
      "Class 6 marks a pivotal transition into formal departmental sciences and algebra. Our curriculum reinforces number systems, geometry fundamentals, and foundational natural science concepts.",
    curriculum: [
      "Integers, Fractions & Decimal Operations",
      "Basic Geometrical Ideas & Mensuration",
      "Components of Food & Matter",
      "Motion & Measurement of Distances",
      "Light, Shadows & Reflections",
    ],
    features: ["Interactive teaching methods", "Weekly concept worksheets", "Small batch size of 20-25"],
  },
  "7": {
    title: "Class 7 Academic Program",
    stage: "Middle School Foundation",
    tagline: "Strengthening algebraic reasoning and physical sciences",
    description:
      "Class 7 builds the bridging blocks for secondary schooling, introducing algebraic expressions, heat and temperature principles, and chemical changes.",
    curriculum: [
      "Algebraic Expressions & Simple Equations",
      "Lines, Angles & Triangles Properties",
      "Heat, Acids, Bases & Salts",
      "Physical and Chemical Changes",
      "Electric Current and its Effects",
    ],
    features: ["Step-by-step problem derivations", "Fortnightly progress quizzes", "Doubt sessions"],
  },
  "8": {
    title: "Class 8 Academic Program",
    stage: "Middle School Foundation",
    tagline: "High-school readiness and quantitative aptitude",
    description:
      "Preparing students for the rigor of Classes 9 and 10 with advanced linear equations, algebraic identities, force, friction, and light.",
    curriculum: [
      "Rational Numbers, Linear Equations & Factorisation",
      "Mensuration & Exponents and Powers",
      "Force and Pressure, Friction & Sound",
      "Chemical Effects of Electric Current & Light",
      "Synthetic Fibres, Plastics & Metals",
    ],
    features: ["Pre-foundation competitive reasoning", "Structured homework logs", "Parent meeting reviews"],
  },
  "9": {
    title: "Class 9 Secondary Program",
    stage: "Secondary Pre-Board",
    tagline: "The foundational core for board exams and competitive foundations",
    description:
      "Class 9 is widely recognized as the most critical academic transition. Topics in mechanics, laws of motion, structure of atoms, and polynomial algebra form 50% of future competitive syllabus.",
    curriculum: [
      "Number Systems, Polynomials & Coordinate Geometry",
      "Linear Equations in Two Variables & Triangles",
      "Motion, Force and Laws of Motion & Gravitation",
      "Work and Energy & Sound Waves",
      "Matter in Our Surroundings, Atoms and Molecules",
    ],
    features: ["Rigorous NCERT & Exemplar coverage", "Numerical problem sessions", "Individual error logs"],
  },
  "10": {
    title: "Class 10 Board Excellence Program",
    stage: "Secondary Board Year",
    tagline: "Mastery, speed, and precision for board exams",
    description:
      "Intensive preparation tailored to maximize board examination performance through systematic chapter tests, sample paper solving, and precise answer-writing methodology.",
    curriculum: [
      "Real Numbers, Polynomials & Quadratic Equations",
      "Arithmetic Progressions, Triangles & Trigonometry",
      "Chemical Reactions, Acids, Bases & Metals",
      "Carbon and its Compounds & Periodic Classification",
      "Light (Reflection & Refraction) & Electricity",
    ],
    features: ["Previous 10 years question analysis", "Full-length timed mock tests", "Board answer writing rubrics"],
  },
  "11": {
    title: "Class 11 Senior Secondary PCM",
    stage: "Senior Secondary Specialization",
    tagline: "In-depth Physics, Chemistry, and Mathematics",
    description:
      "Senior secondary coaching dedicated to Physics, Chemistry, and Mathematics. Focuses on deep conceptual derivations, mathematical models, and rigorous problem sets.",
    curriculum: [
      "Physics: Units, Kinematics, Laws of Motion, Work-Energy, Gravitation & Thermodynamics",
      "Chemistry: Atomic Structure, Periodic Table, Chemical Bonding & Thermodynamics",
      "Chemistry: Organic Chemistry Basics, Hydrocarbons & States of Matter",
      "Mathematics: Sets, Relations, Trigonometric Functions & Complex Numbers",
      "Mathematics: Straight Lines, Conic Sections & Limits and Derivatives",
    ],
    features: [
      "Subject-wise specialized batches",
      "Faculty specializing in senior secondary pedagogy",
      "Extensive derivations and analytical numerical training",
    ],
  },
  "12": {
    title: "Class 12 Senior Secondary PCM",
    stage: "Senior Secondary Board & Foundation",
    tagline: "Culmination of school academics: Boards & Entrance Readiness",
    description:
      "Class 12 requires balanced board precision and entrance-level speed. Our curriculum features intensive coverage, regular test series, and structured board revision.",
    curriculum: [
      "Physics: Electrostatics, Current Electricity, Magnetism & Electromagnetic Induction",
      "Physics: Optics, Dual Nature of Radiation, Atoms, Nuclei & Semiconductor Devices",
      "Chemistry: Solutions, Electrochemistry, Chemical Kinetics & Coordination Compounds",
      "Chemistry: Haloalkanes, Alcohols, Aldehydes, Ketones, Amines & Biomolecules",
      "Mathematics: Relations and Functions, Inverse Trig, Matrices, Determinants & Calculus",
      "Mathematics: Differential Equations, Vectors, 3D Geometry & Probability",
    ],
    features: [
      "Complete syllabus completion before pre-boards",
      "Rigorous unit-wise and full-syllabus mock tests",
      "Continuous performance audit and parent reporting",
    ],
  },
};

export async function generateStaticParams() {
  return ["6", "7", "8", "9", "10", "11", "12"].map((level) => ({
    classLevel: level,
  }));
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { classLevel } = await params;
  const data = classData[classLevel];
  if (!data) return { title: "Class Not Found" };

  return {
    title: `Class ${classLevel} Coaching in Amritsar | Radiance Institute`,
    description: `${data.title} at Radiance Institute Amritsar. ${data.description.slice(0, 150)}...`,
  };
}

export default async function ClassDetailPage({ params }: Props) {
  const { classLevel } = await params;
  const data = classData[classLevel];

  if (!data) {
    notFound();
  }

  return (
    <div className="py-16 bg-white">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        {/* Back navigation */}
        <Link
          href="/classes"
          className="inline-flex items-center text-xs font-semibold text-slate-500 hover:text-radiance-blue"
        >
          <ArrowLeft className="w-3.5 h-3.5 mr-1" /> Back to all classes
        </Link>

        {/* Header */}
        <div className="space-y-4">
          <div className="inline-block px-3 py-1 bg-radiance-light text-radiance-blue text-xs font-bold rounded-full">
            {data.stage}
          </div>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">{data.title}</h1>
          <p className="text-base text-radiance-gold font-semibold">{data.tagline}</p>
          <p className="text-sm sm:text-base text-slate-600 leading-relaxed max-w-3xl">
            {data.description}
          </p>
        </div>

        {/* Curriculum breakdown */}
        <div className="bg-slate-50 border border-slate-200 rounded-2xl p-8 space-y-6">
          <div className="flex items-center space-x-2 text-radiance-navy">
            <BookOpen className="w-5 h-5 text-radiance-blue" />
            <h2 className="text-xl font-bold">Curriculum & Topics Covered</h2>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            {data.curriculum.map((topic, idx) => (
              <div key={idx} className="flex items-start space-x-2.5 p-2 bg-white rounded-lg border border-slate-100">
                <CheckCircle2 className="w-4 h-4 text-radiance-blue shrink-0 mt-0.5" />
                <span className="text-xs sm:text-sm text-slate-700 font-medium">{topic}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Program Features */}
        <div className="border border-slate-200 rounded-2xl p-8 space-y-4">
          <h3 className="text-lg font-bold text-radiance-navy">Batch Structure & Methodology</h3>
          <ul className="space-y-2.5">
            {data.features.map((feat, idx) => (
              <li key={idx} className="flex items-center space-x-2 text-sm text-slate-700">
                <div className="w-1.5 h-1.5 rounded-full bg-radiance-blue" />
                <span>{feat}</span>
              </li>
            ))}
          </ul>
        </div>

        {/* CTA */}
        <div className="bg-radiance-navy text-white rounded-2xl p-8 flex flex-col sm:flex-row justify-between items-center gap-6">
          <div className="space-y-1 text-center sm:text-left">
            <h3 className="text-xl font-bold">Interested in Class {classLevel} Enrolment?</h3>
            <p className="text-xs text-slate-300">
              Submit an enquiry to receive batch timings, fee details, and counseling.
            </p>
          </div>
          <Link
            href="/admissions"
            className="bg-amber-400 hover:bg-amber-500 text-radiance-navy font-bold px-6 py-3 rounded-lg text-sm shrink-0 shadow transition-colors"
          >
            Submit Admission Enquiry
          </Link>
        </div>
      </div>
    </div>
  );
}

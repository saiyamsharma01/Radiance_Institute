import type { Metadata } from "next";
import Link from "next/link";
import Image from "next/image";
import {
  CheckCircle2,
  MapPin,
  Phone,
  Mail,
  Award,
  Target,
  BookOpen,
  Instagram,
  Sparkles,
  Zap,
  Users,
} from "lucide-react";

export const metadata: Metadata = {
  title: "About Us | Radiance Institute & Bedi College of Physics — Amritsar",
  description:
    "Learn about Radiance Institute's educational mission, Er. Bedi Sir's renowned Physics legacy, and academic guidance for Classes 6 to 12 in Rani Ka Bagh, Amritsar.",
};

export default function AboutPage() {
  return (
    <div className="py-16 bg-white">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        {/* Header */}
        <div className="text-center space-y-4 max-w-3xl mx-auto">
          <div className="inline-flex items-center gap-2 bg-amber-50 text-amber-800 text-xs font-bold px-3.5 py-1.5 rounded-full border border-amber-200">
            <Sparkles className="w-3.5 h-3.5 text-amber-600" />
            <span>Unit of Bedi College of Physics • Est. 1998</span>
          </div>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Committed to Quality Education in Amritsar
          </h1>
          <p className="text-base text-slate-600 leading-relaxed">
            Radiance Institute, working in synergy with Bedi College of Physics, stands as a premier
            institution for concept-driven schooling, board exam distinctions, and competitive
            engineering (JEE) and medical (NEET) entrance preparations.
          </p>
        </div>

        {/* Bedi Sir's Physics Legacy Section */}
        <div className="bg-gradient-to-br from-slate-900 to-radiance-navy text-white rounded-3xl p-8 sm:p-10 shadow-xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-80 h-80 bg-blue-500/10 rounded-full blur-3xl pointer-events-none" />
          <div className="grid grid-cols-1 md:grid-cols-12 gap-8 items-center relative z-10">
            <div className="md:col-span-4 flex justify-center">
              <div className="relative w-44 h-44 rounded-2xl overflow-hidden border-2 border-amber-400/50 shadow-2xl">
                <Image
                  src="/images/teacher_physics.jpg"
                  alt="Er. Bedi Sir - Senior Physics Master"
                  fill
                  className="object-cover"
                />
              </div>
            </div>
            <div className="md:col-span-8 space-y-3">
              <span className="text-xs font-bold text-amber-400 uppercase tracking-wider">
                Founder & Senior Physics Mentor
              </span>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-white">
                Er. Bedi Sir — 28+ Years of Physics Distinction
              </h2>
              <p className="text-sm text-slate-300 leading-relaxed">
                Pioneering conceptual physics training in Amritsar since 1998, Er. Bedi Sir has mentored
                thousands of students to achieve 100 percentiles in JEE Physics, top ranks in NEET, and
                selections into India's premier IITs and Government Medical Colleges. His teaching methodology
                transforms complex theoretical derivations into intuitive problem-solving models.
              </p>
              <div className="pt-2 flex flex-wrap gap-3">
                <a
                  href="https://www.instagram.com/radiance_institute/"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-1.5 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white text-xs font-bold px-4 py-2 rounded-xl shadow transition-all"
                >
                  <Instagram className="w-3.5 h-3.5" />
                  <span>Follow Er. Bedi Sir on @radiance_institute</span>
                </a>
              </div>
            </div>
          </div>
        </div>

        {/* Mission & Philosophy */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="bg-slate-50 border border-slate-200 p-8 rounded-2xl space-y-4">
            <div className="w-12 h-12 rounded-xl bg-radiance-light text-radiance-blue flex items-center justify-center">
              <Target className="w-6 h-6" />
            </div>
            <h2 className="text-xl font-bold text-radiance-navy">Our Academic Mission</h2>
            <p className="text-sm text-slate-600 leading-relaxed">
              To cultivate genuine conceptual understanding rather than rote memorization. We guide
              students to develop critical thinking, analytical problem-solving skills, and the academic
              discipline necessary for school boards, JEE, NEET, and beyond.
            </p>
          </div>

          <div className="bg-slate-50 border border-slate-200 p-8 rounded-2xl space-y-4">
            <div className="w-12 h-12 rounded-xl bg-radiance-light text-radiance-blue flex items-center justify-center">
              <Award className="w-6 h-6" />
            </div>
            <h2 className="text-xl font-bold text-radiance-navy">Our Core Philosophy</h2>
            <p className="text-sm text-slate-600 leading-relaxed">
              Every student possesses innate potential. By maintaining optimum batch sizes (max 25-30),
              providing regular formative assessments, and keeping parents informed of real progress via
              our digital platform, we ensure no student gets left behind.
            </p>
          </div>
        </div>

        {/* Academic Principles */}
        <div className="space-y-6">
          <h2 className="text-2xl font-bold text-radiance-navy">Our Pedagogical Framework</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {[
              "Er. Bedi Sir's structured Physics problem sets and Irodov/HC Verma discussions",
              "Comprehensive Chemistry (Physical, Organic & Inorganic) and Mathematics coaching",
              "Junior Foundation Academy for Classes 6 to 10 covering NTSE and Science Olympiads",
              "Bi-weekly tests with deterministic attendance tracking and instant parent alerts",
              "Dedicated one-on-one doubt clearing sessions outside regular batch timings",
              "Real exam simulation with negative marking and detailed performance analytics",
            ].map((item, idx) => (
              <div key={idx} className="flex items-start space-x-3 p-3 bg-white rounded-xl border border-slate-100 shadow-sm">
                <CheckCircle2 className="w-5 h-5 text-radiance-blue shrink-0 mt-0.5" />
                <span className="text-sm text-slate-700">{item}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Campus Location Card */}
        <div className="border border-slate-200 rounded-3xl p-8 bg-radiance-light/40 space-y-4">
          <h3 className="text-lg font-bold text-radiance-navy">Institute Campus & Facilities</h3>
          <p className="text-sm text-slate-600">
            Our campus is situated in the central Rani Ka Bagh locality of Amritsar, adjoining the
            FCI Office. The campus features well-lit, air-conditioned lecture rooms, demonstration
            laboratories, and dedicated study desks designed for distraction-free learning.
          </p>
          <div className="pt-2 text-sm text-slate-700 space-y-2">
            <div className="flex items-center">
              <MapPin className="w-4 h-4 text-radiance-blue mr-2 shrink-0" />
              <span>85-A, Rani Ka Bagh, adjoining FCI Office (Near Shivaji Park), Amritsar, Punjab – 143001</span>
            </div>
            <div className="flex items-center">
              <Phone className="w-4 h-4 text-radiance-blue mr-2 shrink-0" />
              <span>+91 99141 22256 / +91 98156 22256 / 0183 508 0005</span>
            </div>
            <div className="flex items-center">
              <Instagram className="w-4 h-4 text-pink-600 mr-2 shrink-0" />
              <a
                href="https://www.instagram.com/radiance_institute/"
                target="_blank"
                rel="noopener noreferrer"
                className="hover:underline font-semibold text-pink-600"
              >
                @radiance_institute (Official Instagram)
              </a>
            </div>
            <div className="flex items-center">
              <Mail className="w-4 h-4 text-radiance-blue mr-2 shrink-0" />
              <span>info@radianceinstitute.net</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

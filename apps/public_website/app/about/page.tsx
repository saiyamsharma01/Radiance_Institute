import type { Metadata } from "next";
import Link from "next/link";
import { CheckCircle2, MapPin, Phone, Mail, Award, Target, BookOpen } from "lucide-react";

export const metadata: Metadata = {
  title: "About Us | Radiance Institute — Amritsar",
  description:
    "Learn about Radiance Institute's educational mission, teaching philosophy, and academic guidance for Classes 6 to 12 in Rani Ka Bagh, Amritsar.",
};

export default function AboutPage() {
  return (
    <div className="py-16 bg-white">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 space-y-16">
        {/* Header */}
        <div className="text-center space-y-4 max-w-3xl mx-auto">
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            About Our Institute
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Committed to Quality Education in Amritsar
          </h1>
          <p className="text-base text-slate-600 leading-relaxed">
            Radiance Institute was established with a singular objective: to provide rigorous,
            concept-driven, and ethical academic mentoring for middle and senior school students.
          </p>
        </div>

        {/* Mission & Philosophy */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div className="bg-slate-50 border border-slate-200 p-8 rounded-2xl space-y-4">
            <div className="w-12 h-12 rounded-lg bg-radiance-light text-radiance-blue flex items-center justify-center">
              <Target className="w-6 h-6" />
            </div>
            <h2 className="text-xl font-bold text-radiance-navy">Our Academic Mission</h2>
            <p className="text-sm text-slate-600 leading-relaxed">
              To cultivate genuine conceptual understanding rather than rote memorization. We guide
              students to develop critical thinking, analytical problem-solving skills, and the academic
              discipline necessary for boards and beyond.
            </p>
          </div>

          <div className="bg-slate-50 border border-slate-200 p-8 rounded-2xl space-y-4">
            <div className="w-12 h-12 rounded-lg bg-radiance-light text-radiance-blue flex items-center justify-center">
              <Award className="w-6 h-6" />
            </div>
            <h2 className="text-xl font-bold text-radiance-navy">Our Core Philosophy</h2>
            <p className="text-sm text-slate-600 leading-relaxed">
              Every student possesses innate potential. By maintaining optimum batch sizes,
              providing regular formative assessments, and keeping parents informed of real progress,
              we ensure no student gets left behind.
            </p>
          </div>
        </div>

        {/* Academic Principles */}
        <div className="space-y-6">
          <h2 className="text-2xl font-bold text-radiance-navy">Our Pedagogical Framework</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {[
              "Clear syllabus milestones structured across the academic calendar",
              "Emphasis on fundamental scientific derivations and mathematical proofs",
              "Regular chapter-end tests with personalized mistake-analysis",
              "Dedicated doubt-clearing assistance outside standard lecture hours",
              "Deterministic attendance tracking with instant parent alerts",
              "Ethical academic environment with transparent progress reporting",
            ].map((item, idx) => (
              <div key={idx} className="flex items-start space-x-3 p-3">
                <CheckCircle2 className="w-5 h-5 text-radiance-blue shrink-0 mt-0.5" />
                <span className="text-sm text-slate-700">{item}</span>
              </div>
            ))}
          </div>
        </div>

        {/* Campus Location Card */}
        <div className="border border-slate-200 rounded-2xl p-8 bg-radiance-light/40 space-y-4">
          <h3 className="text-lg font-bold text-radiance-navy">Institute Campus & Facilities</h3>
          <p className="text-sm text-slate-600">
            Our campus is situated in the central Rani Ka Bagh locality of Amritsar, adjoining the
            FCI Office. The campus features well-lit, air-conditioned lecture rooms designed for
            distraction-free learning.
          </p>
          <div className="pt-2 text-sm text-slate-700 space-y-2">
            <div className="flex items-center">
              <MapPin className="w-4 h-4 text-radiance-blue mr-2 shrink-0" />
              <span>85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India</span>
            </div>
            <div className="flex items-center">
              <Phone className="w-4 h-4 text-radiance-blue mr-2 shrink-0" />
              <span>+91 183 508 0005</span>
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

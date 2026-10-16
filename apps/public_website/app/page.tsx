import Link from "next/link";
import Image from "next/image";
import {
  BookOpen,
  Award,
  Users,
  CheckCircle2,
  Calendar,
  ArrowRight,
  MapPin,
  Phone,
  Mail,
  Sparkles,
} from "lucide-react";

export default function HomePage() {
  const academicOfferings = [
    {
      level: "Classes 6, 7 & 8",
      title: "Middle School Foundations",
      desc: "Building rock-solid fundamentals in Mathematics, Science, and logical reasoning for junior school scholars.",
      badge: "Foundation Track",
    },
    {
      level: "Classes 9 & 10",
      title: "Secondary Board Excellence",
      desc: "Comprehensive board syllabus coverage with systematic concept mastery and pre-foundation competitive prep.",
      badge: "Board Prep",
    },
    {
      level: "Class 11 & 12 (PCM)",
      title: "Senior Secondary Specialization",
      desc: "In-depth Physics, Chemistry, and Mathematics coaching tailored for board mastery and engineering entrance foundations.",
      badge: "Core PCM Specialization",
    },
  ];

  const features = [
    {
      icon: BookOpen,
      title: "Structured Academic Pedagogy",
      desc: "Clear syllabus roadmaps, comprehensive study materials, and rigorous problem sets designed for conceptual depth.",
    },
    {
      icon: Users,
      title: "Optimum Batch Sizes",
      desc: "Individual student attention with small batch capacities allowing faculty to address doubts promptly.",
    },
    {
      icon: Calendar,
      title: "Continuous Assessment & Tracking",
      desc: "Regular unit tests, verified attendance logs, and transparent parent reporting via the Radiance platform.",
    },
    {
      icon: Award,
      title: "Proven Faculty Guidance",
      desc: "Subject specialists dedicated to mentoring students towards academic excellence and board distinction.",
    },
  ];

  return (
    <div>
      {/* 1. Hero Section */}
      <section className="relative bg-gradient-to-br from-radiance-navy via-blue-900 to-radiance-blue text-white overflow-hidden py-20 lg:py-28">
        <div className="absolute inset-0 opacity-10 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:16px_16px] pointer-events-none" />
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
            <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
              <div className="inline-flex items-center space-x-2 bg-white/10 backdrop-blur-md px-3.5 py-1.5 rounded-full border border-white/15 text-xs font-semibold text-amber-300">
                <Sparkles className="w-3.5 h-3.5" />
                <span>Radiance Institute • Rani Ka Bagh, Amritsar</span>
              </div>
              <h1 className="text-3xl sm:text-4xl lg:text-5xl font-extrabold tracking-tight leading-tight">
                Committed to Quality Education for{" "}
                <span className="text-amber-400">Classes 6 to 12</span>
              </h1>
              <p className="text-base sm:text-lg text-slate-200 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-normal">
                Empowering Amritsar's young minds with deep conceptual learning, structured classroom
                pedagogy, and specialized senior secondary coaching in{" "}
                <strong className="text-white font-semibold">Physics, Chemistry, and Mathematics</strong>.
              </p>
              <div className="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 pt-4">
                <Link
                  href="/admissions"
                  className="w-full sm:w-auto text-center bg-amber-400 hover:bg-amber-500 text-radiance-navy font-bold px-8 py-3.5 rounded-lg shadow-lg hover:shadow-xl transition-all"
                >
                  Submit Admission Enquiry
                </Link>
                <Link
                  href="/classes"
                  className="w-full sm:w-auto text-center bg-white/10 hover:bg-white/20 text-white font-semibold px-6 py-3.5 rounded-lg border border-white/20 backdrop-blur-sm transition-all"
                >
                  View Class Offerings
                </Link>
              </div>
            </div>

            {/* Hero Visual Card */}
            <div className="lg:col-span-5 flex justify-center">
              <div className="relative w-72 sm:w-80 h-72 sm:h-80 rounded-2xl bg-white/5 border border-white/20 p-6 backdrop-blur-xl shadow-2xl flex flex-col justify-center items-center text-center">
                <div className="relative w-28 h-28 rounded-full overflow-hidden mb-4 border-2 border-amber-400/40 shadow-inner bg-white">
                  <Image
                    src="/images/radiance_logo.jpg"
                    alt="Radiance Institute Crest"
                    fill
                    className="object-cover"
                  />
                </div>
                <h3 className="text-xl font-bold text-white">Radiance Institute</h3>
                <p className="text-xs text-amber-300 font-semibold tracking-wider uppercase mt-1">
                  Committed to Quality Education
                </p>
                <div className="mt-4 pt-4 border-t border-white/10 w-full text-xs text-slate-300">
                  <span>85-A, Rani Ka Bagh, Amritsar</span>
                  <div className="mt-1 font-semibold text-white">+91 183 508 0005</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 2. Key Pillars */}
      <section className="py-16 bg-slate-50 border-b border-slate-100">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto mb-12">
            <h2 className="text-2xl sm:text-3xl font-bold text-radiance-navy">
              Why Parents & Students Choose Radiance Institute
            </h2>
            <p className="mt-3 text-sm text-slate-600">
              A disciplined academic environment focused on concept building, systematic evaluations,
              and transparent parent communication.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {features.map((f, i) => {
              const Icon = f.icon;
              return (
                <div
                  key={i}
                  className="bg-white p-6 rounded-xl border border-slate-200/80 shadow-sm hover:shadow-md transition-shadow"
                >
                  <div className="w-12 h-12 rounded-lg bg-radiance-light text-radiance-blue flex items-center justify-center mb-4">
                    <Icon className="w-6 h-6" />
                  </div>
                  <h3 className="font-bold text-base text-radiance-navy mb-2">{f.title}</h3>
                  <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">{f.desc}</p>
                </div>
              );
            })}
          </div>
        </div>
      </section>

      {/* 3. Academic Programs Breakdown */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex flex-col md:flex-row justify-between items-start md:items-end mb-12">
            <div>
              <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
                Official Curriculum
              </span>
              <h2 className="text-2xl sm:text-3xl font-bold text-radiance-navy mt-1">
                Class Offerings (Classes 6 through 12)
              </h2>
            </div>
            <Link
              href="/classes"
              className="mt-4 md:mt-0 text-sm font-semibold text-radiance-blue hover:text-blue-800 flex items-center"
            >
              Explore all curriculum tracks <ArrowRight className="w-4 h-4 ml-1" />
            </Link>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {academicOfferings.map((item, i) => (
              <div
                key={i}
                className="border border-slate-200 rounded-2xl p-7 bg-white hover:border-radiance-blue/50 hover:shadow-lg transition-all flex flex-col justify-between"
              >
                <div>
                  <span className="inline-block px-3 py-1 bg-radiance-light text-radiance-blue rounded-full text-xs font-semibold mb-4">
                    {item.badge}
                  </span>
                  <h3 className="text-xl font-bold text-radiance-navy mb-1">{item.level}</h3>
                  <h4 className="text-sm font-semibold text-slate-700 mb-3">{item.title}</h4>
                  <p className="text-xs sm:text-sm text-slate-600 leading-relaxed">{item.desc}</p>
                </div>
                <div className="mt-6 pt-4 border-t border-slate-100">
                  <Link
                    href="/admissions"
                    className="text-xs font-bold text-radiance-blue hover:text-blue-800 flex items-center"
                  >
                    Enquire for this grade <ArrowRight className="w-3.5 h-3.5 ml-1" />
                  </Link>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* 4. Senior Secondary Focus Banner */}
      <section className="py-16 bg-gradient-to-r from-blue-900 to-radiance-navy text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-center">
            <div className="lg:col-span-8 space-y-4">
              <span className="text-amber-400 text-xs font-bold uppercase tracking-wider">
                Senior Secondary Excellence
              </span>
              <h2 className="text-2xl sm:text-3xl font-extrabold text-white">
                Specialized Physics, Chemistry & Mathematics for Classes 11 & 12
              </h2>
              <p className="text-sm text-slate-300 max-w-2xl leading-relaxed">
                Senior secondary years define your higher education pathway. Our focused PCM batches
                provide rigorous numerical derivation training, conceptual mastery, and mock test
                series aligned with board standards and entrance foundations.
              </p>
            </div>
            <div className="lg:col-span-4 flex justify-start lg:justify-end">
              <Link
                href="/subjects"
                className="bg-white text-radiance-navy font-bold px-6 py-3 rounded-lg text-sm hover:bg-slate-100 transition-colors shadow-md"
              >
                Learn About PCM Subjects
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* 5. Campus Location & Visit CTA */}
      <section className="py-20 bg-slate-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white rounded-2xl border border-slate-200 overflow-hidden shadow-sm grid grid-cols-1 lg:grid-cols-2">
            <div className="p-8 sm:p-12 space-y-6">
              <div>
                <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
                  Campus Address
                </span>
                <h3 className="text-2xl font-bold text-radiance-navy mt-1">
                  Visit Radiance Institute in Amritsar
                </h3>
              </div>
              <p className="text-sm text-slate-600 leading-relaxed">
                Parents and students are welcome to visit our campus for counseling, batch schedule
                clarifications, and enrollment inquiries.
              </p>
              <div className="space-y-3 pt-2 text-sm text-slate-700">
                <div className="flex items-start">
                  <MapPin className="w-5 h-5 text-radiance-blue mr-3 shrink-0 mt-0.5" />
                  <span>85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India</span>
                </div>
                <div className="flex items-center">
                  <Phone className="w-5 h-5 text-radiance-blue mr-3 shrink-0" />
                  <span>Phone: +91 183 508 0005</span>
                </div>
                <div className="flex items-center">
                  <Mail className="w-5 h-5 text-radiance-blue mr-3 shrink-0" />
                  <span>Email: info@radianceinstitute.net</span>
                </div>
              </div>
              <div className="pt-2">
                <Link
                  href="/admissions"
                  className="inline-block bg-radiance-blue hover:bg-blue-700 text-white font-semibold px-6 py-3 rounded-lg text-sm shadow-sm transition-colors"
                >
                  Submit Admission Enquiry
                </Link>
              </div>
            </div>

            <div className="bg-slate-100 p-8 flex flex-col justify-center items-center text-center border-t lg:border-t-0 lg:border-l border-slate-200">
              <div className="w-16 h-16 rounded-full bg-radiance-light text-radiance-blue flex items-center justify-center mb-4">
                <MapPin className="w-8 h-8" />
              </div>
              <h4 className="font-bold text-base text-radiance-navy">Conveniently Located in Amritsar</h4>
              <p className="text-xs text-slate-600 max-w-sm mt-2">
                Situated in Rani Ka Bagh, easily accessible from all major residential sectors and
                schools across Amritsar.
              </p>
              <Link
                href="/contact"
                className="mt-6 text-xs font-bold text-radiance-blue hover:text-blue-800 flex items-center"
              >
                View Directions & Timings <ArrowRight className="w-3.5 h-3.5 ml-1" />
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

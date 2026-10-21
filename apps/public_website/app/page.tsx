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
  Instagram,
  Trophy,
  Zap,
  GraduationCap,
} from "lucide-react";
import InstagramFeed from "@/components/InstagramFeed";
import ToppersShowcase from "@/components/ToppersShowcase";
import CourseFeeCalculator from "@/components/CourseFeeCalculator";
import BatchScheduleExplorer from "@/components/BatchScheduleExplorer";
import FloatingSocialWidget from "@/components/FloatingSocialWidget";
import AnimatedStatsStrip from "@/components/AnimatedStatsStrip";

export default function HomePage() {
  const academicOfferings = [
    {
      level: "Classes 6, 7 & 8",
      title: "Junior Pre-Foundation Academy",
      desc: "Building rock-solid fundamentals in Mathematics, Science, and logical reasoning for junior school scholars.",
      badge: "Foundation Track",
    },
    {
      level: "Classes 9 & 10",
      title: "Secondary Board & NTSE Excellence",
      desc: "Comprehensive board syllabus coverage with systematic concept mastery, lab demos, and Olympiad prep.",
      badge: "Board & Pre-Competitive",
    },
    {
      level: "Class 11 & 12 (PCM)",
      title: "Senior Secondary & JEE Specialization",
      desc: "In-depth Physics by Er. Bedi Sir, Chemistry, and Mathematics coaching tailored for board distinction and JEE/NEET.",
      badge: "Physics by Bedi Sir",
    },
  ];

  const features = [
    {
      icon: Zap,
      title: "Physics Mastery under Er. Bedi Sir",
      desc: "25+ years of pedagogical excellence delivering crystal-clear concept derivations and 100%ile results.",
    },
    {
      icon: Users,
      title: "Optimum Small Batches",
      desc: "Individual student attention with capped batch sizes allowing faculty to address doubts promptly.",
    },
    {
      icon: Calendar,
      title: "Continuous Assessment & Tracking",
      desc: "Regular unit tests, verified attendance logs, and transparent parent reporting via the Radiance platform.",
    },
    {
      icon: Award,
      title: "Proven City & State Toppers",
      desc: "Consistent selections in IITs, NITs, and top medical colleges with 99+ percentiles from Amritsar.",
    },
  ];

  return (
    <div className="relative">
      {/* 1. Hero Section */}
      <section className="relative bg-gradient-to-br from-radiance-midnight via-radiance-navy to-[#103260] text-white overflow-hidden py-14 sm:py-20 lg:py-28">
        {/* Modern ambient glow backdrop */}
        <div className="absolute top-0 right-1/4 w-[500px] h-[500px] bg-blue-500/15 rounded-full blur-[120px] pointer-events-none" />
        <div className="absolute bottom-0 left-10 w-[400px] h-[400px] bg-amber-500/10 rounded-full blur-[100px] pointer-events-none" />
        <div className="absolute inset-0 opacity-10 bg-[radial-gradient(#ffffff_1px,transparent_1px)] [background-size:24px_24px] pointer-events-none" />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-12 items-center">
            {/* Left Content */}
            <div className="lg:col-span-7 space-y-5 sm:space-y-6 text-center lg:text-left">
              {/* Badge */}
              <div className="inline-flex items-center gap-2 bg-white/10 backdrop-blur-md px-3.5 py-1.5 rounded-full border border-white/20 text-[11px] sm:text-xs font-semibold text-amber-300 shadow-sm max-w-full">
                <Sparkles className="w-3.5 h-3.5 text-amber-400 shrink-0" />
                <span className="truncate">Rani Ka Bagh, Amritsar • Unit of Bedi College (Est. 1998)</span>
              </div>

              {/* Main Headline */}
              <h1 className="font-display text-2xl xs:text-3xl sm:text-4xl lg:text-5xl font-extrabold tracking-tight leading-[1.2] text-white">
                Committed to Quality Education for{" "}
                <span className="text-transparent bg-clip-text bg-gradient-to-r from-amber-300 via-amber-400 to-amber-200">
                  Classes 6 to 12
                </span>
              </h1>

              {/* Sub-headline */}
              <p className="text-sm sm:text-base lg:text-lg text-slate-200 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-normal">
                Empowering Amritsar&apos;s young minds with deep conceptual learning, structured classroom
                pedagogy, and renowned Physics mentoring by{" "}
                <strong className="text-white font-semibold">Er. Bedi Sir</strong> alongside specialized
                guidance in <strong className="text-white font-semibold">Chemistry &amp; Mathematics</strong> for boards and JEE/NEET.
              </p>

              {/* Responsive CTA Buttons (Aesthetic on mobile & desktop) */}
              <div className="pt-2 flex flex-col sm:flex-row items-stretch sm:items-center justify-center lg:justify-start gap-3">
                <Link
                  href="/admissions"
                  className="inline-flex items-center justify-center gap-2 bg-gradient-to-r from-amber-400 to-amber-500 hover:from-amber-500 hover:to-amber-600 text-radiance-navy font-bold px-7 py-3.5 rounded-xl shadow-lg shadow-amber-500/20 active:scale-95 transition-all text-sm"
                >
                  <span>Submit Admission Enquiry</span>
                  <ArrowRight className="w-4 h-4" />
                </Link>

                <div className="grid grid-cols-2 gap-2.5 sm:flex sm:items-center">
                  <a
                    href="#calculator"
                    className="inline-flex items-center justify-center gap-1.5 bg-white/10 hover:bg-white/20 text-white font-semibold px-4 py-3.5 rounded-xl border border-white/20 backdrop-blur-sm transition-all text-xs sm:text-sm text-center"
                  >
                    <span>⚡ Fee Calculator</span>
                  </a>
                  <a
                    href="https://www.instagram.com/radiance_institute/"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="inline-flex items-center justify-center gap-1.5 bg-gradient-to-r from-purple-600/60 to-pink-600/60 hover:from-purple-600 hover:to-pink-600 text-white font-semibold px-4 py-3.5 rounded-xl border border-pink-400/30 backdrop-blur-sm transition-all text-xs sm:text-sm text-center"
                  >
                    <Instagram className="w-3.5 h-3.5 text-pink-300" />
                    <span>Instagram</span>
                  </a>
                </div>
              </div>

              {/* Dynamic Animated Mini Stats Card Strip */}
              <AnimatedStatsStrip />
            </div>


            {/* Right Hero Visual Card */}
            <div className="lg:col-span-5 flex justify-center">
              <div className="relative w-full max-w-sm rounded-3xl bg-white/10 border border-white/20 p-6 sm:p-7 backdrop-blur-xl shadow-2xl flex flex-col justify-center items-center text-center">
                {/* Admissions Open Live Pill */}
                <div className="mb-4 inline-flex items-center gap-1.5 bg-amber-400/20 px-3 py-1 rounded-full border border-amber-400/40 text-amber-300 text-xs font-bold">
                  <span className="relative flex h-2 w-2">
                    <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-amber-400 opacity-75"></span>
                    <span className="relative inline-flex rounded-full h-2 w-2 bg-amber-400"></span>
                  </span>
                  <span>Admissions Open 2026–27</span>
                </div>

                <div className="relative w-28 h-28 sm:w-32 sm:h-32 rounded-3xl overflow-hidden mb-4 border-2 border-white/30 shadow-2xl shadow-blue-950/60 bg-[#3c4c89] flex items-center justify-center group hover:scale-105 transition-transform duration-300">
                  <Image
                    src="/images/radiance_logo.png"
                    alt="Radiance Institute Crest"
                    fill
                    className="object-cover"
                    priority
                  />
                </div>
                <h3 className="font-display text-xl sm:text-2xl font-black text-white">Radiance Institute</h3>
                <p className="text-[11px] sm:text-xs text-amber-300 font-bold tracking-widest uppercase mt-0.5">
                  Unit of Bedi College of Physics
                </p>

                {/* Quick Info */}
                <div className="mt-4 pt-4 border-t border-white/15 w-full text-xs text-slate-200 space-y-2">
                  <div className="flex items-center justify-center gap-1.5 text-slate-300">
                    <MapPin className="w-3.5 h-3.5 text-amber-400 shrink-0" />
                    <span className="truncate">85-A, Rani Ka Bagh, Amritsar</span>
                  </div>
                  <div className="flex items-center justify-center gap-1.5 font-bold text-white text-xs sm:text-sm">
                    <Phone className="w-3.5 h-3.5 text-amber-400 shrink-0" />
                    <span>+91 99141 22256</span>
                  </div>
                </div>

                {/* Batch Button */}
                <div className="mt-5 w-full">
                  <a
                    href="#batches"
                    className="block w-full py-2.5 rounded-xl bg-white/20 hover:bg-white/30 text-white font-bold text-xs transition-colors border border-white/20"
                  >
                    View Batch Timings &amp; Seats →
                  </a>
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
              Why Amritsar Scholars Trust Radiance Institute
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
                  className="bg-white p-6 rounded-2xl border border-slate-200/80 shadow-sm hover:shadow-md transition-shadow"
                >
                  <div className="w-12 h-12 rounded-xl bg-radiance-light text-radiance-blue flex items-center justify-center mb-4">
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

      {/* 3. Live Batch Schedule Explorer */}
      <BatchScheduleExplorer />

      {/* 4. Course Fee & Scholarship Calculator */}
      <CourseFeeCalculator />

      {/* 5. Toppers Wall of Fame */}
      <ToppersShowcase />

      {/* 6. Live Instagram Feed & Social Highlights */}
      <InstagramFeed />

      {/* 7. Academic Programs Breakdown */}
      <section className="py-20 bg-white border-t border-slate-100">
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
                    href={`/admissions?classLevel=${encodeURIComponent(item.level)}`}
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

      {/* 8. Campus Location & Visit Section */}
      <section className="py-20 bg-slate-50 border-t border-slate-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white rounded-3xl border border-slate-200 overflow-hidden shadow-lg grid grid-cols-1 lg:grid-cols-2">
            <div className="p-8 sm:p-12 space-y-6">
              <div>
                <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
                  Campus Address &amp; Counseling
                </span>
                <h3 className="text-2xl sm:text-3xl font-extrabold text-radiance-navy mt-1">
                  Visit Radiance Institute in Amritsar
                </h3>
              </div>
              <p className="text-sm text-slate-600 leading-relaxed">
                Parents and students are welcome to visit our Rani Ka Bagh campus for academic counseling,
                batch schedule discussions, syllabus material inspection, and Er. Bedi Sir&apos;s physics
                orientation.
              </p>
              <div className="space-y-3 pt-2 text-sm text-slate-700">
                <div className="flex items-start">
                  <MapPin className="w-5 h-5 text-radiance-blue mr-3 shrink-0 mt-0.5" />
                  <span>85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India – 143001</span>
                </div>
                <div className="flex items-center">
                  <Phone className="w-5 h-5 text-radiance-blue mr-3 shrink-0" />
                  <span>Helpline: +91 99141 22256 / 0183 508 0005</span>
                </div>
                <div className="flex items-center">
                  <Mail className="w-5 h-5 text-radiance-blue mr-3 shrink-0" />
                  <span>Email: info@radianceinstitute.net</span>
                </div>
                <div className="flex items-center">
                  <Instagram className="w-5 h-5 text-pink-600 mr-3 shrink-0" />
                  <a
                    href="https://www.instagram.com/radiance_institute/"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="hover:underline font-semibold text-pink-600"
                  >
                    @radiance_institute (Instagram)
                  </a>
                </div>
              </div>
              <div className="pt-2 flex flex-wrap gap-4">
                <Link
                  href="/admissions"
                  className="bg-radiance-blue hover:bg-blue-700 text-white font-bold px-6 py-3 rounded-xl text-sm shadow-md transition-colors"
                >
                  Submit Admission Enquiry
                </Link>
                <Link
                  href="/contact"
                  className="bg-slate-100 hover:bg-slate-200 text-slate-800 font-bold px-6 py-3 rounded-xl text-sm transition-colors"
                >
                  Get Directions
                </Link>
              </div>
            </div>

            <div className="bg-slate-100 p-8 flex flex-col justify-center items-center text-center border-t lg:border-t-0 lg:border-l border-slate-200 relative">
              <div className="w-16 h-16 rounded-2xl bg-radiance-light text-radiance-blue flex items-center justify-center mb-4 shadow-sm">
                <MapPin className="w-8 h-8" />
              </div>
              <h4 className="font-extrabold text-lg text-radiance-navy">
                Prime Rani Ka Bagh Location
              </h4>
              <p className="text-xs sm:text-sm text-slate-600 max-w-sm mt-2 leading-relaxed">
                Adjoining FCI Office, close to Shivaji Park and easily accessible from Mall Road,
                Lawrence Road, Majitha Road, and GT Road.
              </p>
              <div className="mt-6 flex flex-col gap-2 w-full max-w-xs">
                <a
                  href="https://maps.google.com/?q=85+Rani+Ka+Bagh+Amritsar"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full text-center bg-white hover:bg-slate-50 text-slate-800 border border-slate-200 font-bold text-xs py-3 rounded-xl shadow-sm transition-all"
                >
                  Open in Google Maps ↗
                </a>
                <a
                  href="https://wa.me/919914122256?text=Hello%20Radiance%20Institute,%20I%20am%20visiting%20Rani%20Ka%20Bagh%20campus."
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-full text-center bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs py-3 rounded-xl shadow-sm transition-all"
                >
                  WhatsApp Campus Location
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Floating Quick Action Widget */}
      <FloatingSocialWidget />
    </div>
  );
}

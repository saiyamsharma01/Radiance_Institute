import Link from "next/link";
import Image from "next/image";
import {
  Phone,
  Mail,
  MapPin,
  ArrowRight,
  Instagram,
  MessageCircle,
  ExternalLink,
  Sparkles,
} from "lucide-react";

export default function Footer() {
  return (
    <footer className="bg-radiance-navy text-slate-300 border-t border-slate-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10">
          {/* Col 1: Institute Brand & Identity */}
          <div className="space-y-4">
            <div className="flex items-center space-x-3">
              <div className="relative w-11 h-11 rounded-xl overflow-hidden bg-[#3c4c89] border border-white/20 shadow-lg shrink-0 flex items-center justify-center">
                <Image
                  src="/images/radiance_logo.png"
                  alt="Radiance Institute Logo"
                  fill
                  className="object-cover"
                />
              </div>
              <div>
                <span className="font-extrabold text-lg text-white block">
                  Radiance Institute
                </span>
                <span className="text-xs text-amber-400 font-medium">
                  Unit of Bedi College of Physics
                </span>
              </div>
            </div>
            <p className="text-xs sm:text-sm text-slate-400 leading-relaxed">
              Committed to Quality Education in Amritsar since 1998. Renowned for conceptual
              mastery under Er. Bedi Sir, empowering students across Classes 6 to 12 in Physics,
              Chemistry, Mathematics, and competitive entrance excellence (JEE & NEET).
            </p>

            {/* Social Badges */}
            <div className="pt-2 flex items-center gap-3">
              <a
                href="https://www.instagram.com/radiance_institute/"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1.5 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg shadow transition-all"
              >
                <Instagram className="w-3.5 h-3.5" />
                <span>@radiance_institute</span>
              </a>
              <a
                href="https://wa.me/919914122256"
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold px-3 py-1.5 rounded-lg shadow transition-all"
              >
                <MessageCircle className="w-3.5 h-3.5" />
                <span>WhatsApp</span>
              </a>
            </div>
          </div>

          {/* Col 2: Academic Programs */}
          <div>
            <h3 className="text-white font-semibold text-sm tracking-wider uppercase mb-4">
              Academic Offerings
            </h3>
            <ul className="space-y-2.5 text-xs sm:text-sm">
              <li>
                <Link href="/classes" className="hover:text-white transition-colors">
                  Junior Foundation (Classes 6, 7 & 8)
                </Link>
              </li>
              <li>
                <Link href="/classes" className="hover:text-white transition-colors">
                  Board & NTSE Foundation (Classes 9 & 10)
                </Link>
              </li>
              <li>
                <Link href="/subjects" className="hover:text-white transition-colors">
                  Physics by Er. Bedi Sir (Class 11 & 12)
                </Link>
              </li>
              <li>
                <Link href="/subjects" className="hover:text-white transition-colors">
                  JEE Main & Advanced Specialization
                </Link>
              </li>
              <li>
                <Link href="/subjects" className="hover:text-white transition-colors">
                  NEET Medical Physics & Chemistry
                </Link>
              </li>
              <li>
                <Link href="/#calculator" className="hover:text-amber-300 transition-colors text-amber-400">
                  ⚡ Fee Estimator & Scholarship Tool
                </Link>
              </li>
            </ul>
          </div>

          {/* Col 3: Quick Links */}
          <div>
            <h3 className="text-white font-semibold text-sm tracking-wider uppercase mb-4">
              Institute Info
            </h3>
            <ul className="space-y-2.5 text-xs sm:text-sm">
              <li>
                <Link href="/about" className="hover:text-white transition-colors">
                  About Bedi Sir & Campus Legacy
                </Link>
              </li>
              <li>
                <Link href="/#toppers" className="hover:text-white transition-colors">
                  City & State Toppers Hall of Fame
                </Link>
              </li>
              <li>
                <Link href="/#batches" className="hover:text-white transition-colors">
                  Batch Timetable & Available Seats
                </Link>
              </li>
              <li>
                <Link href="/#instagram-feed" className="hover:text-white transition-colors">
                  Live Instagram Highlights & Reels
                </Link>
              </li>
              <li>
                <Link href="/faq" className="hover:text-white transition-colors">
                  Frequently Asked Questions
                </Link>
              </li>
              <li>
                <Link href="/privacy-policy" className="hover:text-white transition-colors">
                  Privacy Policy & Student Data Safety
                </Link>
              </li>
            </ul>
          </div>

          {/* Col 4: Verified Contact Details */}
          <div>
            <h3 className="text-white font-semibold text-sm tracking-wider uppercase mb-4">
              Campus Contact & Office
            </h3>
            <ul className="space-y-3 text-xs sm:text-sm">
              <li className="flex items-start">
                <MapPin className="w-4 h-4 text-amber-400 mr-2.5 mt-0.5 shrink-0" />
                <span>
                  85-A, Rani Ka Bagh, adjoining FCI Office (Near Shivaji Park), Amritsar, Punjab – 143001
                </span>
              </li>
              <li className="flex items-center">
                <Phone className="w-4 h-4 text-amber-400 mr-2.5 shrink-0" />
                <div className="space-y-0.5">
                  <a href="tel:+919914122256" className="hover:text-white block">
                    +91 99141 22256 / +91 98156 22256
                  </a>
                  <a href="tel:+911835080005" className="hover:text-white block text-slate-400">
                    Office Landline: 0183 508 0005
                  </a>
                </div>
              </li>
              <li className="flex items-center">
                <Instagram className="w-4 h-4 text-pink-400 mr-2.5 shrink-0" />
                <a
                  href="https://www.instagram.com/radiance_institute/"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="hover:text-pink-300 flex items-center gap-1"
                >
                  <span>instagram.com/radiance_institute</span>
                  <ExternalLink className="w-3 h-3" />
                </a>
              </li>
              <li className="flex items-center">
                <Mail className="w-4 h-4 text-amber-400 mr-2.5 shrink-0" />
                <a href="mailto:info@radianceinstitute.net" className="hover:text-white">
                  info@radianceinstitute.net
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-12 pt-8 border-t border-slate-800 text-xs text-slate-500 flex flex-col sm:flex-row justify-between items-center gap-4">
          <p>
            © {new Date().getFullYear()} Radiance Institute (Unit of Bedi College of Physics).
            Committed to Quality Education. All rights reserved.
          </p>
          <div className="flex items-center gap-4">
            <Link href="/privacy-policy" className="hover:text-slate-400">
              Privacy
            </Link>
            <span>•</span>
            <Link href="/terms" className="hover:text-slate-400">
              Terms
            </Link>
            <span>•</span>
            <span>Rani Ka Bagh, Amritsar, Punjab</span>
          </div>
        </div>
      </div>
    </footer>
  );
}

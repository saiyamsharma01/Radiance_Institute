import Link from "next/link";
import Image from "next/image";
import { Phone, Mail, MapPin, ArrowRight } from "lucide-react";

export default function Footer() {
  return (
    <footer className="bg-radiance-navy text-slate-300 border-t border-slate-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-10">
          {/* Col 1: Institute Brand & Identity */}
          <div className="space-y-4">
            <div className="flex items-center space-x-3">
              <div className="relative w-10 h-10 rounded-full overflow-hidden bg-white">
                <Image
                  src="/images/radiance_logo.jpg"
                  alt="Radiance Institute Logo"
                  fill
                  className="object-cover"
                />
              </div>
              <span className="font-bold text-lg text-white">Radiance Institute</span>
            </div>
            <p className="text-sm text-slate-400 leading-relaxed">
              Committed to Quality Education in Amritsar. Empowering students across Classes 6 to 12
              with foundational excellence and specialized senior secondary Physics, Chemistry, and
              Mathematics coaching.
            </p>
          </div>

          {/* Col 2: Academic Programs */}
          <div>
            <h3 className="text-white font-semibold text-sm tracking-wider uppercase mb-4">
              Academic Offerings
            </h3>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/classes" className="hover:text-white transition-colors">
                  Secondary Classes (6, 7, 8)
                </Link>
              </li>
              <li>
                <Link href="/classes" className="hover:text-white transition-colors">
                  High School Foundation (Classes 9 & 10)
                </Link>
              </li>
              <li>
                <Link href="/subjects" className="hover:text-white transition-colors">
                  Class 11 Physics, Chemistry & Math
                </Link>
              </li>
              <li>
                <Link href="/subjects" className="hover:text-white transition-colors">
                  Class 12 Physics, Chemistry & Math
                </Link>
              </li>
              <li>
                <Link href="/admissions" className="hover:text-white transition-colors">
                  Admission Process & Guidelines
                </Link>
              </li>
            </ul>
          </div>

          {/* Col 3: Quick Links */}
          <div>
            <h3 className="text-white font-semibold text-sm tracking-wider uppercase mb-4">
              Institute Info
            </h3>
            <ul className="space-y-2.5 text-sm">
              <li>
                <Link href="/about" className="hover:text-white transition-colors">
                  About Our Campus
                </Link>
              </li>
              <li>
                <Link href="/faq" className="hover:text-white transition-colors">
                  Frequently Asked Questions
                </Link>
              </li>
              <li>
                <Link href="/contact" className="hover:text-white transition-colors">
                  Campus Directions & Office
                </Link>
              </li>
              <li>
                <Link href="/privacy-policy" className="hover:text-white transition-colors">
                  Privacy Policy
                </Link>
              </li>
              <li>
                <Link href="/terms" className="hover:text-white transition-colors">
                  Terms & Conditions
                </Link>
              </li>
            </ul>
          </div>

          {/* Col 4: Verified Contact Details */}
          <div>
            <h3 className="text-white font-semibold text-sm tracking-wider uppercase mb-4">
              Contact Campus
            </h3>
            <ul className="space-y-3 text-sm">
              <li className="flex items-start">
                <MapPin className="w-4 h-4 text-amber-400 mr-2.5 mt-1 shrink-0" />
                <span>85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India</span>
              </li>
              <li className="flex items-center">
                <Phone className="w-4 h-4 text-amber-400 mr-2.5 shrink-0" />
                <a href="tel:+911835080005" className="hover:text-white">
                  +91 183 508 0005
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

        <div className="mt-12 pt-8 border-t border-slate-800 text-xs text-slate-500 flex flex-col sm:flex-row justify-between items-center">
          <p>© {new Date().getFullYear()} Radiance Institute. Committed to Quality Education. All rights reserved.</p>
          <p className="mt-2 sm:mt-0">Amritsar, Punjab, India</p>
        </div>
      </div>
    </footer>
  );
}

import type { Metadata } from "next";
import Link from "next/link";
import { MapPin, Phone, Mail, Clock, ArrowRight } from "lucide-react";

export const metadata: Metadata = {
  title: "Contact & Campus Location | Radiance Institute Amritsar",
  description:
    "Find official address, contact numbers, email, and campus visiting hours for Radiance Institute at Rani Ka Bagh, Amritsar, Punjab.",
};

export default function ContactPage() {
  return (
    <div className="py-16 bg-white">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <div className="text-center max-w-2xl mx-auto space-y-3">
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Campus Contact
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Visit or Get in Touch
          </h1>
          <p className="text-sm text-slate-600">
            Have questions about admissions, batch timings, or academic programs? We look forward to
            welcoming you to our Rani Ka Bagh campus.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
          {/* Contact Details Card */}
          <div className="bg-slate-50 border border-slate-200 rounded-2xl p-8 space-y-6">
            <h2 className="text-xl font-bold text-radiance-navy">Official Campus Information</h2>

            <div className="space-y-4 text-sm text-slate-700">
              <div className="flex items-start">
                <MapPin className="w-5 h-5 text-radiance-blue mr-3 shrink-0 mt-0.5" />
                <div>
                  <strong className="block text-slate-900 font-semibold">Campus Address:</strong>
                  <span>85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India</span>
                </div>
              </div>

              <div className="flex items-start">
                <Phone className="w-5 h-5 text-radiance-blue mr-3 shrink-0 mt-0.5" />
                <div>
                  <strong className="block text-slate-900 font-semibold">Telephone:</strong>
                  <a href="tel:+911835080005" className="text-radiance-blue hover:underline">
                    +91 183 508 0005
                  </a>
                </div>
              </div>

              <div className="flex items-start">
                <Mail className="w-5 h-5 text-radiance-blue mr-3 shrink-0 mt-0.5" />
                <div>
                  <strong className="block text-slate-900 font-semibold">Official Email:</strong>
                  <a href="mailto:info@radianceinstitute.net" className="text-radiance-blue hover:underline">
                    info@radianceinstitute.net
                  </a>
                </div>
              </div>

              <div className="flex items-start">
                <Clock className="w-5 h-5 text-radiance-blue mr-3 shrink-0 mt-0.5" />
                <div>
                  <strong className="block text-slate-900 font-semibold">Office Hours:</strong>
                  <span>Monday – Saturday: 9:00 AM – 7:30 PM</span>
                  <div className="text-xs text-slate-500 mt-0.5">Sunday: 10:00 AM – 2:00 PM (Counseling by Appointment)</div>
                </div>
              </div>
            </div>

            <div className="pt-4 border-t border-slate-200">
              <Link
                href="/admissions"
                className="inline-flex items-center text-xs font-bold text-radiance-blue hover:underline"
              >
                Submit an Online Admission Enquiry <ArrowRight className="w-3.5 h-3.5 ml-1" />
              </Link>
            </div>
          </div>

          {/* Interactive Map Link / Directions Card */}
          <div className="border border-slate-200 rounded-2xl p-8 bg-radiance-navy text-white flex flex-col justify-between">
            <div className="space-y-4">
              <span className="text-amber-400 text-xs font-bold uppercase tracking-wider">
                Location & Accessibility
              </span>
              <h2 className="text-2xl font-bold">Rani Ka Bagh, Amritsar</h2>
              <p className="text-xs sm:text-sm text-slate-300 leading-relaxed">
                Conveniently located adjoining the FCI Office in Rani Ka Bagh. The campus is well
                connected via major arterial roads and transit routes across Amritsar.
              </p>
              <div className="bg-white/10 rounded-xl p-4 border border-white/10 text-xs text-slate-300 space-y-2">
                <div>
                  <strong className="text-white">Landmark:</strong> Adjoining FCI Office
                </div>
                <div>
                  <strong className="text-white">Locality:</strong> Rani Ka Bagh Central District
                </div>
                <div>
                  <strong className="text-white">City:</strong> Amritsar, Punjab
                </div>
              </div>
            </div>

            <div className="pt-6">
              <a
                href="https://maps.google.com/?q=85-A+Rani+Ka+Bagh+Amritsar"
                target="_blank"
                rel="noopener noreferrer"
                className="block text-center bg-amber-400 hover:bg-amber-500 text-radiance-navy font-bold py-3 rounded-lg text-sm shadow transition-colors"
              >
                Open in Google Maps
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

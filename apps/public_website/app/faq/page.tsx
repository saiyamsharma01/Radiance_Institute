import type { Metadata } from "next";
import Link from "next/link";
import { HelpCircle, ArrowRight } from "lucide-react";

export const metadata: Metadata = {
  title: "Frequently Asked Questions (FAQ) | Radiance Institute",
  description:
    "Common questions regarding admission, batch strengths, faculty, fee structures, and class schedules at Radiance Institute Amritsar.",
};

export default function FaqPage() {
  const faqs = [
    {
      q: "Which classes and grades are officially offered at Radiance Institute?",
      a: "Radiance Institute provides academic coaching for students from Class 6 through Class 12. For Classes 11 and 12 (senior secondary), we offer specialized programs in Physics, Chemistry, and Mathematics (PCM).",
    },
    {
      q: "Can a student enroll in individual subjects rather than all three PCM subjects?",
      a: "Yes. Radiance Institute supports both complete package enrolments as well as individual subject-wise batches (e.g. Physics only, or Chemistry only) to accommodate each student's specific academic requirements.",
    },
    {
      q: "What is the typical batch size for each classroom session?",
      a: "To ensure personalized attention, our batches maintain a disciplined strength of 20 to 30 students. This allows teachers to interact with every learner and resolve individual doubts promptly.",
    },
    {
      q: "How are parents kept informed about attendance and academic performance?",
      a: "Parents receive access to the Radiance parent mobile and web application. Whenever a child is marked absent or test marks are published, the parent dashboard updates immediately and alerts are dispatched.",
    },
    {
      q: "How is the admission enquiry process initiated?",
      a: "Parents or prospective students can submit an online enquiry via our Admissions page, call our desk directly at +91 183 508 0005, or visit our Rani Ka Bagh campus during office hours.",
    },
    {
      q: "Are demo or counseling sessions available prior to final admission?",
      a: "Yes. Parents and students are encouraged to schedule an initial counseling session with our academic coordinators to review the student's foundation and discuss appropriate batch schedules.",
    },
    {
      q: "What payment methods are supported for tuition fees?",
      a: "Through our integrated, secure payment portal, parents can pay tuition fees online via UPI, NetBanking, Debit Cards, and Credit Cards, and instantly download verified tax/tuition receipts.",
    },
  ];

  return (
    <div className="py-16 bg-white">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        <div className="text-center space-y-3">
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Clear Answers
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Frequently Asked Questions
          </h1>
          <p className="text-sm text-slate-600">
            Find answers to commonly asked questions regarding admissions, batch allocations, and
            institute policies.
          </p>
        </div>

        <div className="space-y-4">
          {faqs.map((faq, i) => (
            <div key={i} className="border border-slate-200 rounded-xl p-6 bg-slate-50/50">
              <h2 className="text-base font-bold text-radiance-navy mb-2 flex items-start">
                <HelpCircle className="w-5 h-5 text-radiance-blue mr-2.5 shrink-0 mt-0.5" />
                <span>{faq.q}</span>
              </h2>
              <p className="text-sm text-slate-600 pl-7 leading-relaxed">{faq.a}</p>
            </div>
          ))}
        </div>

        <div className="bg-radiance-light/60 border border-radiance-blue/20 rounded-2xl p-8 text-center space-y-3">
          <h3 className="font-bold text-base text-radiance-navy">Have a question not listed here?</h3>
          <p className="text-xs text-slate-600">
            Our campus counselors are available to answer your specific queries.
          </p>
          <div className="pt-2">
            <Link
              href="/contact"
              className="inline-flex items-center text-xs font-bold text-radiance-blue hover:underline"
            >
              Contact Our Campus Office <ArrowRight className="w-3.5 h-3.5 ml-1" />
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Privacy Policy | Radiance Institute",
  description:
    "Privacy and data protection policy of Radiance Institute regarding student records, parent communications, and platform security.",
};

export default function PrivacyPolicyPage() {
  return (
    <div className="py-16 bg-white">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8 text-slate-700">
        <div>
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Legal & Compliance
          </span>
          <h1 className="text-3xl font-extrabold text-radiance-navy mt-1">Privacy Policy</h1>
          <p className="text-xs text-slate-500 mt-2">Last Updated: October 2026</p>
        </div>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">1. Information We Collect</h2>
          <p className="text-sm leading-relaxed">
            Radiance Institute collects personal identification details necessary for academic
            administration and parent communications. This includes student names, roll numbers,
            dates of birth, emergency contact phone numbers, parent names, attendance logs, homework
            submissions, and assessment marks.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">2. Purpose of Data Processing</h2>
          <p className="text-sm leading-relaxed">
            We use collected information strictly to:
          </p>
          <ul className="list-disc list-inside text-sm space-y-1.5 pl-2">
            <li>Deliver scheduled classroom coaching and batch management.</li>
            <li>Maintain verified academic progress and attendance records.</li>
            <li>Enable authorized parents to view academic reports for their linked children.</li>
            <li>Facilitate secure tuition fee payments and generate verified receipts.</li>
            <li>Dispatch critical notifications regarding schedule changes and institute alerts.</li>
          </ul>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">3. Parent-Child Data Protection</h2>
          <p className="text-sm leading-relaxed">
            Access to minor students' academic records is strictly safeguarded. Parents are granted
            access only after completing verified phone OTP authentication and cryptographic matching
            against institute records. Public visitors cannot view student records.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">4. Financial Data & Payment Gateways</h2>
          <p className="text-sm leading-relaxed">
            Radiance Institute does not store sensitive payment card details, CVVs, or NetBanking
            credentials on our servers. All online fee transactions are handled through trusted,
            PCI-DSS compliant payment gateways (Razorpay) with server-side signature verification.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">5. Contact Campus Data Office</h2>
          <p className="text-sm leading-relaxed">
            For any queries regarding this Privacy Policy or your student account, please contact our
            office at 85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, or email us at{" "}
            <a href="mailto:info@radianceinstitute.net" className="text-radiance-blue underline">
              info@radianceinstitute.net
            </a>.
          </p>
        </section>
      </div>
    </div>
  );
}

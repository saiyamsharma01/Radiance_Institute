import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Terms and Conditions | Radiance Institute",
  description:
    "Terms of service and enrollment conditions for students, parents, and website visitors of Radiance Institute Amritsar.",
};

export default function TermsPage() {
  return (
    <div className="py-16 bg-white">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 space-y-8 text-slate-700">
        <div>
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Legal Agreement
          </span>
          <h1 className="text-3xl font-extrabold text-radiance-navy mt-1">Terms and Conditions</h1>
          <p className="text-xs text-slate-500 mt-2">Effective Date: Academic Session 2026–2027</p>
        </div>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">1. Acceptance of Terms</h2>
          <p className="text-sm leading-relaxed">
            By visiting the Radiance Institute website, enrolling as a student, or accessing the
            parent/student portals, you agree to comply with and be bound by the following terms and
            conditions.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">2. Enrollment and Batch Allocations</h2>
          <p className="text-sm leading-relaxed">
            Admission to Radiance Institute programs is confirmed upon payment of requisite tuition
            fees and submission of student information. Batch timings and classroom locations are
            scheduled by institute administration to maintain optimal teacher-student ratios.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">3. Tuition Fees & Online Invoicing</h2>
          <p className="text-sm leading-relaxed">
            Tuition fee plans are issued per batch, class, or individual agreement. Fees must be
            settled on or before the due date indicated on the electronic invoice. Online fee
            payments are reconciled server-side and an official institute receipt is generated for
            every verified transaction.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">4. Academic Integrity & Conduct</h2>
          <p className="text-sm leading-relaxed">
            Students are expected to maintain disciplined attendance and adhere to code of conduct
            both in offline classrooms and across electronic portals. Radiance Institute reserves the
            right to suspend accounts or terminate enrollment in cases of continuous misconduct.
          </p>
        </section>

        <section className="space-y-3">
          <h2 className="text-lg font-bold text-radiance-navy">5. Governing Jurisdiction</h2>
          <p className="text-sm leading-relaxed">
            These terms are governed by the laws of India. Any disputes arising out of the services
            provided by Radiance Institute shall be subject to the exclusive jurisdiction of the
            competent courts in Amritsar, Punjab.
          </p>
        </section>
      </div>
    </div>
  );
}

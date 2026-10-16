"use client";

import { useState } from "react";
import { CheckCircle2, Phone, Mail, MapPin, Send, AlertCircle } from "lucide-react";

export default function AdmissionsPage() {
  const [formData, setFormData] = useState({
    studentName: "",
    guardianName: "",
    contactNumber: "",
    classLevel: "11",
    academicYear: "2026-2027",
    subjectIds: [] as string[],
    preferredCallbackTime: "Morning (9 AM – 1 PM)",
    message: "",
    consent: false,
  });

  const [loading, setLoading] = useState(false);
  const [successResult, setSuccessResult] = useState<{
    reference: string;
    message: string;
  } | null>(null);
  const [errorMessage, setErrorMessage] = useState("");

  const availableSubjects = [
    "Physics",
    "Chemistry",
    "Mathematics",
    "General Science (Classes 6-10)",
    "Secondary Mathematics (Classes 6-10)",
  ];

  const handleSubjectToggle = (subject: string) => {
    if (formData.subjectIds.includes(subject)) {
      setFormData({
        ...formData,
        subjectIds: formData.subjectIds.filter((s) => s !== subject),
      });
    } else {
      setFormData({
        ...formData,
        subjectIds: [...formData.subjectIds, subject],
      });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErrorMessage("");

    if (!formData.consent) {
      setErrorMessage("Please consent to receive admissions updates from Radiance Institute.");
      return;
    }

    try {
      setLoading(true);
      const res = await fetch("/api/enquiry", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || "Failed to submit enquiry.");
      }

      setSuccessResult({
        reference: data.enquiryReference,
        message: data.message,
      });
    } catch (err: any) {
      setErrorMessage(err.message || "An unexpected error occurred. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="py-16 bg-slate-50 min-h-screen">
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 space-y-12">
        {/* Header */}
        <div className="text-center max-w-2xl mx-auto space-y-3">
          <span className="text-xs font-bold text-radiance-blue uppercase tracking-wider">
            Admissions & Enrolment
          </span>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-radiance-navy">
            Admissions for Classes 6 to 12
          </h1>
          <p className="text-sm text-slate-600">
            Submit an admission enquiry to schedule a consultation, batch suitability check, and
            academic roadmap discussion.
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-12 gap-10">
          {/* Left: Enquiry Form */}
          <div className="lg:col-span-8 bg-white p-8 rounded-2xl border border-slate-200 shadow-sm">
            {successResult ? (
              <div className="text-center py-12 space-y-4">
                <div className="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto">
                  <CheckCircle2 className="w-10 h-10" />
                </div>
                <h2 className="text-2xl font-bold text-radiance-navy">Enquiry Recorded Successfully!</h2>
                <div className="bg-slate-50 border border-slate-200 rounded-lg p-4 inline-block">
                  <div className="text-xs text-slate-500 uppercase font-semibold">Enquiry Reference ID</div>
                  <div className="text-xl font-mono font-bold text-radiance-blue mt-1">
                    {successResult.reference}
                  </div>
                </div>
                <p className="text-sm text-slate-600 max-w-md mx-auto leading-relaxed">
                  {successResult.message}
                </p>
                <div className="pt-4">
                  <button
                    onClick={() => {
                      setSuccessResult(null);
                      setFormData({
                        studentName: "",
                        guardianName: "",
                        contactNumber: "",
                        classLevel: "11",
                        academicYear: "2026-2027",
                        subjectIds: [],
                        preferredCallbackTime: "Morning (9 AM – 1 PM)",
                        message: "",
                        consent: false,
                      });
                    }}
                    className="text-xs font-bold text-radiance-blue hover:underline"
                  >
                    Submit another enquiry
                  </button>
                </div>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-6">
                <h2 className="text-lg font-bold text-radiance-navy border-b pb-3">
                  Prospective Student & Guardian Information
                </h2>

                {errorMessage && (
                  <div className="p-3 bg-red-50 border border-red-200 rounded-lg flex items-center space-x-2 text-xs text-red-700">
                    <AlertCircle className="w-4 h-4 shrink-0" />
                    <span>{errorMessage}</span>
                  </div>
                )}

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-slate-700 mb-1">
                      Student Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.studentName}
                      onChange={(e) => setFormData({ ...formData, studentName: e.target.value })}
                      placeholder="e.g. Aarav Sharma"
                      className="w-full px-3.5 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-radiance-blue"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-slate-700 mb-1">
                      Parent / Guardian Name *
                    </label>
                    <input
                      type="text"
                      required
                      value={formData.guardianName}
                      onChange={(e) => setFormData({ ...formData, guardianName: e.target.value })}
                      placeholder="e.g. Gurpreet Singh"
                      className="w-full px-3.5 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-radiance-blue"
                    />
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
                  <div>
                    <label className="block text-xs font-semibold text-slate-700 mb-1">
                      Contact Mobile (+91) *
                    </label>
                    <input
                      type="tel"
                      required
                      maxLength={10}
                      value={formData.contactNumber}
                      onChange={(e) => setFormData({ ...formData, contactNumber: e.target.value })}
                      placeholder="10-digit mobile"
                      className="w-full px-3.5 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-radiance-blue"
                    />
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-slate-700 mb-1">
                      Class of Interest *
                    </label>
                    <select
                      value={formData.classLevel}
                      onChange={(e) => setFormData({ ...formData, classLevel: e.target.value })}
                      className="w-full px-3.5 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-radiance-blue bg-white"
                    >
                      <option value="6">Class 6</option>
                      <option value="7">Class 7</option>
                      <option value="8">Class 8</option>
                      <option value="9">Class 9</option>
                      <option value="10">Class 10</option>
                      <option value="11">Class 11 (PCM)</option>
                      <option value="12">Class 12 (PCM)</option>
                    </select>
                  </div>

                  <div>
                    <label className="block text-xs font-semibold text-slate-700 mb-1">
                      Academic Session
                    </label>
                    <input
                      type="text"
                      readOnly
                      value={formData.academicYear}
                      className="w-full px-3.5 py-2 text-sm border border-slate-200 bg-slate-50 text-slate-500 rounded-lg"
                    />
                  </div>
                </div>

                {/* Subject interests */}
                <div>
                  <label className="block text-xs font-semibold text-slate-700 mb-2">
                    Subjects of Interest
                  </label>
                  <div className="flex flex-wrap gap-2">
                    {availableSubjects.map((sub) => {
                      const selected = formData.subjectIds.includes(sub);
                      return (
                        <button
                          key={sub}
                          type="button"
                          onClick={() => handleSubjectToggle(sub)}
                          className={`text-xs px-3 py-1.5 rounded-full border transition-all ${
                            selected
                              ? "bg-radiance-blue text-white border-radiance-blue font-semibold"
                              : "bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100"
                          }`}
                        >
                          {sub}
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* Preferred Callback Time */}
                <div>
                  <label className="block text-xs font-semibold text-slate-700 mb-1">
                    Preferred Time for Callback
                  </label>
                  <select
                    value={formData.preferredCallbackTime}
                    onChange={(e) =>
                      setFormData({ ...formData, preferredCallbackTime: e.target.value })
                    }
                    className="w-full px-3.5 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-radiance-blue bg-white"
                  >
                    <option value="Morning (9 AM – 1 PM)">Morning (9 AM – 1 PM)</option>
                    <option value="Afternoon (1 PM – 5 PM)">Afternoon (1 PM – 5 PM)</option>
                    <option value="Evening (5 PM – 8 PM)">Evening (5 PM – 8 PM)</option>
                  </select>
                </div>

                {/* Optional Message */}
                <div>
                  <label className="block text-xs font-semibold text-slate-700 mb-1">
                    Specific Queries / Student Background (Optional)
                  </label>
                  <textarea
                    rows={3}
                    value={formData.message}
                    onChange={(e) => setFormData({ ...formData, message: e.target.value })}
                    placeholder="e.g. Current school, previous marks percentage, preferred batch timing..."
                    className="w-full px-3.5 py-2 text-sm border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-radiance-blue"
                  />
                </div>

                {/* Consent checkbox */}
                <div className="flex items-start space-x-2 pt-2">
                  <input
                    type="checkbox"
                    id="consentCheck"
                    checked={formData.consent}
                    onChange={(e) => setFormData({ ...formData, consent: e.target.checked })}
                    className="mt-1 h-4 w-4 rounded border-slate-300 text-radiance-blue focus:ring-radiance-blue"
                  />
                  <label htmlFor="consentCheck" className="text-xs text-slate-600">
                    I authorize Radiance Institute to contact me on the provided mobile number
                    regarding academic programs and batch details.
                  </label>
                </div>

                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-radiance-blue hover:bg-blue-700 text-white font-semibold py-3 rounded-lg text-sm shadow transition-colors flex items-center justify-center space-x-2 disabled:opacity-70"
                >
                  {loading ? (
                    <span>Submitting Enquiry...</span>
                  ) : (
                    <>
                      <span>Submit Admission Enquiry</span>
                      <Send className="w-4 h-4 ml-1" />
                    </>
                  )}
                </button>
              </form>
            )}
          </div>

          {/* Right: Admission Guidelines */}
          <div className="lg:col-span-4 space-y-6">
            <div className="bg-white p-6 rounded-2xl border border-slate-200 space-y-4">
              <h3 className="font-bold text-base text-radiance-navy">Admissions Process</h3>
              <ol className="space-y-3 text-xs text-slate-600 list-decimal list-inside leading-relaxed">
                <li>
                  <strong className="text-slate-800">Submit Enquiry:</strong> Complete the form or call
                  the office.
                </li>
                <li>
                  <strong className="text-slate-800">Counseling Call:</strong> Our academic coordinator
                  explains batch structures and schedules.
                </li>
                <li>
                  <strong className="text-slate-800">Campus Interaction:</strong> Visit the campus in
                  Rani Ka Bagh for syllabus alignment.
                </li>
                <li>
                  <strong className="text-slate-800">Enrollment & Portal Setup:</strong> Enrolled
                  students and parents receive platform credentials.
                </li>
              </ol>
            </div>

            <div className="bg-radiance-navy text-white p-6 rounded-2xl space-y-3">
              <h3 className="font-bold text-sm text-white">Direct Campus Desk</h3>
              <p className="text-xs text-slate-300 leading-relaxed">
                For urgent admissions queries or to speak directly with the administration desk:
              </p>
              <div className="pt-2 text-xs space-y-2 text-slate-200">
                <div className="flex items-center">
                  <Phone className="w-4 h-4 text-amber-400 mr-2 shrink-0" />
                  <span>+91 183 508 0005</span>
                </div>
                <div className="flex items-center">
                  <Mail className="w-4 h-4 text-amber-400 mr-2 shrink-0" />
                  <span>info@radianceinstitute.net</span>
                </div>
                <div className="flex items-start">
                  <MapPin className="w-4 h-4 text-amber-400 mr-2 shrink-0 mt-0.5" />
                  <span>85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

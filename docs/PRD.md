# Product Requirements Document (PRD)
## Radiance Institute — Complete Cross-Platform Education Management Platform

**Document Version:** 1.0.0  
**Status:** Approved for Implementation  
**Product Name:** Radiance Institute  
**Tagline:** Committed to Quality Education  
**Address:** 85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India  
**Contact:** Phone: +91 183 508 0005 | Email: info@radianceinstitute.net  
**Target Academic Range:** Classes 6 through 12  
**Senior Secondary Specialization:** Physics, Chemistry, Mathematics (Classes 11 & 12)  

---

## 1. Executive Summary & Vision

Radiance Institute is an educational institute based in Amritsar, Punjab, providing coaching for students in Classes 6 through 12, with dedicated focus on Physics, Chemistry, and Mathematics for senior secondary boards and competitive foundations.

The Radiance Institute platform is an enterprise-grade, unified cross-platform education and institute management system consisting of:
1. **Public Marketing & Admissions Web Portal:** A fast, SEO-optimized, accessible Next.js website (App Router, Tailwind CSS, TypeScript) for prospective students and parents, featuring class curriculum breakdowns, institute details, contact channels, and a secure admission enquiry funnel.
2. **Cross-Platform Mobile & Tablet Application:** Built with Flutter (Material 3, Dart, GetX architecture) for Android and iOS devices, catering to Students, Parents, and Teachers with tailored dashboards, real-time push notifications, attendance, homework, test reports, and mobile fee checkout.
3. **Responsive Web-Based Institute Admin Dashboard:** An adaptive Flutter Web administration portal giving institute leaders and administrative staff granular control over admissions, students, teachers, parent-linking approvals, class/subject batches, timetables, attendance audits, fee invoicing, payment reconciliation, reports, and system audit logs.
4. **Trusted Serverless Backend:** Google Cloud Functions (TypeScript) backed by Cloud Firestore, Firebase Authentication, Cloud Storage, and Firebase Cloud Messaging (FCM), integrated with an industry-standard payment gateway (Razorpay sandbox/production) for server-side order generation, webhook signature validation, balance reconciliation, and receipt generation.

---

## 2. Brand Identity & Visual Design Tokens

All applications strictly reflect the Radiance Institute brand identity:
* **Primary Royal Blue:** `#2059A5` (Brochure primary, buttons, active states, brand headers)
* **Dark Navy:** `#172B4D` (High-contrast typography, top app bars, dark accents)
* **Soft Light Blue:** `#EAF2FF` (Surface cards, badges, light background tints)
* **Pure White:** `#FFFFFF` (Surface cards, clean container backgrounds)
* **Success Green:** `#10B981` (Fee paid, attendance present, marks published)
* **Warning Amber:** `#F59E0B` (Late submission, fee due, enquiry pending)
* **Error / Alert Crimson:** `#EF4444` (Attendance absent, payment failed, overdue)
* **Neutral Slate:** `#64748B` / `#334155` (Subtitles, borders, meta text)

**Typography:** Modern clean sans-serif (Inter / Outfit / Roboto), optimized for readability on mobile screens and data density on administrative dashboards.

---

## 3. User Roles & Permission Model (RBAC)

The system enforces strict Role-Based Access Control verified through custom claims in Firebase Authentication and Firestore Security Rules:

### 3.1 Public Visitor
* **Capabilities:** Browse public website pages (`/`, `/about`, `/classes`, `/classes/[classLevel]`, `/subjects`, `/admissions`, `/contact`, `/faq`, `/privacy-policy`, `/terms`).
* **Interactive Actions:** Submit admission enquiry forms with server-side validation and anti-spam protection.
* **Boundaries:** Zero access to authenticated student, parent, academic, or financial records.

### 3.2 Student
* **Capabilities:**
  * Access personalized dashboard with today's timetable, announcements, and quick metrics.
  * View enrolled classes, subjects, and assigned batches.
  * View attendance history and monthly percentage breakdown.
  * Access homework listings, deadlines, instructions, and download attachments.
  * Upload homework submissions (PDF/images) before deadline; view teacher feedback and grades.
  * Access syllabus and authorized study materials.
  * View upcoming test schedules and historical published marks/progress reports.
  * View fee invoices, payment receipts, and balance status.
  * Manage notification preferences and basic profile.
* **Boundaries:** Read-only access to own records; cannot modify grades, attendance, fees, or permissions.

### 3.3 Parent
* **Capabilities:**
  * Phone OTP registration and verification via Firebase Auth.
  * Initiate and accept authorized parent-child linking requests with institute-issued linking codes/verification.
  * Switch seamlessly between multiple enrolled children.
  * Monitor linked child's real-time attendance, absences, and correction history.
  * Review academic performance, test results, and teacher remarks.
  * Track daily homework tasks and test schedules.
  * View fee invoices, line-item details, and outstanding balances.
  * Pay tuition fees online via trusted Razorpay gateway checkout (UPI, Cards, NetBanking).
  * Download verified tax/tuition payment receipts.
  * Request parent-teacher consultations and receive official announcements.
* **Boundaries:** Cannot access records of unlinked students; cannot alter academic or fee records.

### 3.4 Teacher
* **Capabilities:**
  * View assigned batches, classes, subjects, and daily teaching schedule.
  * Mark daily attendance for assigned sessions with deterministic session locking.
  * Request attendance corrections if errors occur.
  * Create homework assignments with instructions, deadlines, and study resources.
  * Review and grade student submissions, adding qualitative feedback.
  * Create class tests, enter student marks, and submit for result publication.
  * Upload study notes, worksheets, and syllabus guides.
  * Post batch-specific announcements.
* **Boundaries:** Cannot view institute financial accounts, student fee statuses, or unassigned batches.

### 3.5 Institute Administrator
* **Capabilities:**
  * Complete lifecycle management of students, parents, and teachers.
  * Review and approve parent-child linking requests.
  * Create and maintain subjects, class-wise batches, and subject-wise batches (e.g., Class 11 Physics, Class 12 Chemistry).
  * Configure master timetables and teacher batch assignments.
  * Lead CRM: Manage admission enquiries from `NEW` -> `CONTACTED` -> `VISIT_SCHEDULED` -> `ADMITTED` -> `CLOSED`.
  * Academic governance: Audit attendance sessions, approve result publications.
  * Financial management: Create fee plans, generate student invoices (integer minor units / paise), apply authorized discounts, reconcile payments, issue manual receipt records, and log refunds.
  * Publish institute-wide announcements and send targeted push notifications via FCM.
  * Export compliance and academic reports (CSV/PDF) and review tamper-evident audit logs.

---

## 4. Functional Specifications

### 4.1 Public Website & Admissions CRM
* **Pages:**
  * `/`: Hero with royal blue identity, quick stats, feature highlights, curriculum overview, enquiry banner.
  * `/about`: Institute mission, academic philosophy, Rani Ka Bagh Amritsar campus location details.
  * `/classes`: Comprehensive grid of Classes 6, 7, 8, 9, 10, 11, and 12.
  * `/classes/[classLevel]`: Deep dive into specific class curriculum, foundation syllabus, and senior secondary tracks.
  * `/subjects`: Breakdown of core disciplines: Senior Secondary Physics, Chemistry, Mathematics, and secondary core subjects.
  * `/admissions`: Admission process guide, fee structure transparency note, interactive inquiry submission form.
  * `/contact`: Interactive map link, address (85-A, Rani Ka Bagh, Amritsar), phone (+91 183 508 0005), email, office hours.
  * `/faq`: Answers regarding batch sizes, board coverage, demo sessions, and parent reporting.
  * `/privacy-policy` & `/terms`: Legally compliant disclosures for education platforms and payment processing.
* **Admission Enquiry Submission:**
  * Fields: Student Name, Parent/Guardian Name, Contact Phone (10 digits Indian format), Class Level (6-12), Academic Year, Interested Subjects (multi-select), Preferred Callback Time, Message.
  * Protection: Server-side validation via Cloud Functions / Server Actions, rate limiting, and timestamped audit tracking.

### 4.2 Academic Batch & Enrolment Management
* Dual-structure support: General Class-level batches (e.g., `Class 8 General Tuition`) and subject-specialized batches (e.g., `Class 11 Physics Batch A`, `Class 11 Chemistry Batch B`).
* Multi-enrolment model: Students can be enrolled in multiple batches simultaneously without data duplication.
* Deterministic session keys for attendance (`{batchId}_{date}`) preventing race conditions and duplicate logs.

### 4.3 Financial Architecture & Payment Workflow
* **Monetary Precision:** All currency amounts stored as 64-bit integer minor units (paise in INR, where ₹1,500.00 = 150000 paise). Floating point arithmetic is strictly forbidden.
* **Invoicing Lifecycle:** `DRAFT` -> `ISSUED` -> `PARTIALLY_PAID` -> `PAID` -> `OVERDUE` -> `CANCELLED`.
* **Razorpay Gateway Flow:**
  1. Client requests payment for an authoritative invoice.
  2. Serverless function verifies identity, parent-child link, and balance due.
  3. Cloud Function invokes Razorpay Orders API (`amount`, `currency: 'INR'`, `receipt: invoiceId`).
  4. Client completes checkout via Razorpay SDK (UPI, Debit/Credit Card, NetBanking).
  5. Payment signature verified cryptographically via HMAC-SHA256 (`order_id|payment_id`) on the trusted backend.
  6. Idempotent webhook receiver processes `payment.captured`, reconciles balance, creates immutable `payments/{paymentId}` and `receipt_records/{receiptId}`, and dispatches push notifications.

---

## 5. Non-Functional Requirements
* **Security:** Zero client-side privilege escalation; custom claims verification; rate-limited endpoints; encrypted in-flight (TLS 1.3) and at-rest (AES-256).
* **Reliability & Idempotency:** Payment webhooks and financial mutations must be idempotent.
* **Performance:** Mobile launch time < 2.0s; Web First Contentful Paint < 1.2s; 60fps scrolling in Flutter.
* **Offline Resilience:** Firestore offline persistence enabled on Flutter mobile applications.
* **Auditability:** Sensitive mutations (role changes, fee adjustments, mark publications) recorded in `audit_logs`.

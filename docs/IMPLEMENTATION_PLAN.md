# Implementation Plan
## Radiance Institute — Complete Cross-Platform Education Management Platform

**Document Version:** 1.0.0  
**Status:** In Execution  

---

## 1. Roadmap Overview & Execution Phases

```
+------------------------------------------------------------------------------------+
| Phase 1: Foundation & Project Scaffolding                                          |
| -> Scaffolding monorepo: apps/radiance_flutter, apps/public_website, functions     |
| -> Design tokens: Royal Blue #2059A5, Navy #172B4D, Light Blue #EAF2FF             |
| -> Base configuration: Firebase, TypeScript, Dart dependencies                    |
+------------------------------------------------------------------------------------+
                                         │
                                         ▼
+------------------------------------------------------------------------------------+
| Phase 2: Security, Authentication & Permissions                                    |
| -> Firebase Auth with Custom Claims (admin, teacher, parent, student)              |
| -> Firestore Security Rules (RBAC) & Storage Rules                                 |
| -> Parent OTP verification & verified parent-child linking token logic             |
+------------------------------------------------------------------------------------+
                                         │
                                         ▼
+------------------------------------------------------------------------------------+
| Phase 3: Core Institute Management & CRM                                           |
| -> Students, Parents, Teachers management                                          |
| -> Classes 6-12, Senior Secondary PCM (Physics, Chem, Math)                        |
| -> Batches (Class-wise & Subject-wise), Enrolments & Timetable                      |
| -> Admissions CRM: Admission enquiries pipeline (NEW -> ADMITTED)                 |
+------------------------------------------------------------------------------------+
                                         │
                                         ▼
+------------------------------------------------------------------------------------+
| Phase 4: Academic Workflows & Notifications                                        |
| -> Attendance with deterministic session keys (`{batchId}_{date}_{studentId}`)     |
| -> Homework creation, deadlines, student submission, teacher grading               |
| -> Study material uploads & syllabus guides                                        |
| -> Tests, marks entry, publication & progress cards                                |
| -> In-app notifications & FCM payload triggers                                     |
+------------------------------------------------------------------------------------+
                                         │
                                         ▼
+------------------------------------------------------------------------------------+
| Phase 5: Custom Fees, Invoices & Razorpay Sandbox Payments                         |
| -> Custom fee plans (monthly, subject-wise, paise minor units)                     |
| -> Invoice generation, line items, authorized discounts, balance due               |
| -> Cloud Functions Razorpay Orders API integration                                 |
| -> Cryptographic signature verification (HMAC-SHA256) & idempotent webhooks        |
| -> Automated receipt generation & financial ledger reconciliation                  |
+------------------------------------------------------------------------------------+
                                         │
                                         ▼
+------------------------------------------------------------------------------------+
| Phase 6: Public SEO Website & Flutter Web Admin Dashboard                          |
| -> Next.js 15+ App Router website with Tailwind CSS & Royal Blue branding          |
| -> Pages: Home, About, Classes 6-12, Subjects, Admissions, Contact, FAQ, Terms     |
| -> Interactive Enquiry submission with server-side validation                      |
| -> Responsive Flutter Web Admin Dashboard: Data tables, filters, exports           |
+------------------------------------------------------------------------------------+
                                         │
                                         ▼
+------------------------------------------------------------------------------------+
| Phase 7: Automated Testing, Quality Assurance & Pilot Launch                       |
| -> Flutter unit and widget tests                                                   |
| -> Cloud Functions unit and financial calculation tests                            |
| -> Security rules verification                                                     |
| -> Build verification (Flutter & Next.js)                                          |
| -> Deliverables checklist and deployment documentation                             |
+------------------------------------------------------------------------------------+
```

---

## 2. Detailed Task Breakdown & Dependency Matrix

| Phase | Task ID | Description | Output Artifacts | Verification Method |
|---|---|---|---|---|
| **Phase 1** | P1-01 | Create docs (`PRD`, `ARCHITECTURE`, `DATABASE_SCHEMA`, `IMPLEMENTATION_PLAN`, `SECURITY`, `PAYMENT_FLOW`, `DEPLOYMENT`) | `docs/*.md` | File verification |
| **Phase 1** | P1-02 | Setup Monorepo structure (`apps/radiance_flutter`, `apps/public_website`, `functions`, `firebase`, `scripts`) | Directory layout | Directory listing |
| **Phase 1** | P1-03 | Configure Flutter dependencies (GetX, Google Fonts, Material 3, Firebase, Crypto) and design tokens | `apps/radiance_flutter/pubspec.yaml`, `lib/core/` | `flutter pub get` |
| **Phase 1** | P1-04 | Scaffold Next.js public website with Tailwind CSS & brand tokens | `apps/public_website/` | `npm run build` |
| **Phase 1** | P1-05 | Scaffold Cloud Functions with TypeScript & Razorpay SDK | `functions/` | `npm run build` |
| **Phase 2** | P2-01 | Firestore Security Rules & Storage Rules with RBAC | `firebase/firestore.rules`, `firebase/storage.rules` | Rules audit |
| **Phase 2** | P2-02 | Auth Service & Custom Claims in Cloud Functions | `functions/src/auth/` | Unit tests |
| **Phase 2** | P2-03 | Parent-child token generation & verification endpoints | `functions/src/auth/parentLinking.ts` | Unit tests |
| **Phase 2** | P2-04 | Flutter Authentication module (Login, Phone OTP, Role Router) | `apps/radiance_flutter/lib/modules/auth/` | Widget test |
| **Phase 3** | P3-01 | Models & Repositories for Students, Teachers, Batches, Enrolments | `apps/radiance_flutter/lib/data/` | Unit tests |
| **Phase 3** | P3-02 | Admin Management UI: Students, Teachers, Batches, Subjects | `apps/radiance_flutter/lib/modules/admin/` | Widget test |
| **Phase 3** | P3-03 | Admissions CRM module & Enquiry pipeline | `apps/radiance_flutter/lib/modules/admin/admissions/` | Widget test |
| **Phase 4** | P4-01 | Attendance module with session-locking & deterministic keys | `apps/radiance_flutter/lib/modules/teacher/attendance/` | Unit/Widget test |
| **Phase 4** | P4-02 | Homework assignment & student submission module | `apps/radiance_flutter/lib/modules/common/homework/` | Widget test |
| **Phase 4** | P4-03 | Tests, Marks entry, and Result publication module | `apps/radiance_flutter/lib/modules/teacher/tests/` | Widget test |
| **Phase 4** | P4-04 | Study resources and announcements | `apps/radiance_flutter/lib/modules/common/resources/` | Widget test |
| **Phase 5** | P5-01 | Minor-unit (paise) Fee calculation logic & Invoice generator | `apps/radiance_flutter/lib/data/models/fee.dart` | Unit tests |
| **Phase 5** | P5-02 | Cloud Functions: Razorpay order creation & webhook verification | `functions/src/payments/` | Unit tests |
| **Phase 5** | P5-03 | Payment checkout UI & Receipt viewer | `apps/radiance_flutter/lib/modules/parent/payments/` | Widget test |
| **Phase 6** | P6-01 | Public SEO Website pages (Home, About, Classes, Subjects, Admissions, Contact, FAQ, Terms, Privacy) | `apps/public_website/app/` | `npm run build` |
| **Phase 6** | P6-02 | Public Enquiry API & submission form | `apps/public_website/app/admissions/` | Form test |
| **Phase 6** | P6-03 | Responsive Flutter Web Admin Dashboard | `apps/radiance_flutter/lib/modules/admin/dashboard/` | Flutter web analyze |
| **Phase 7** | P7-01 | Test Suite Execution: Flutter unit/widget tests | `apps/radiance_flutter/test/` | `flutter test` |
| **Phase 7** | P7-02 | Test Suite Execution: Functions unit tests | `functions/test/` | `npm test` |
| **Phase 7** | P7-03 | Deployment documentation, environment configs, checklist | `docs/DEPLOYMENT.md`, `README.md` | Final review |

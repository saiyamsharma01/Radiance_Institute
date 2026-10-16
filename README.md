# Radiance Institute — Cross-Platform Education Management Platform

> **Committed to Quality Education**  
> 85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India  
> Phone: +91 183 508 0005 | Email: [info@radianceinstitute.net](mailto:info@radianceinstitute.net)

---

## 1. Project Overview

Radiance Institute is an enterprise-grade, unified education management ecosystem designed to serve prospective students, enrolled students, parents, teachers, and institute administrators across Android, iOS, Web, and Cloud.

The platform consists of four unified modules:
1. **Public Marketing & Admissions Website (`apps/public_website`)**: Built with Next.js 15+ (App Router, TypeScript, Tailwind CSS). SEO-optimized, schema.org structured data, and server-side validated admission enquiry submissions.
2. **Cross-Platform Mobile & Web Admin App (`apps/radiance_flutter`)**: Built with Flutter (Material 3, GetX, Clean Architecture). Delivers role-based experiences for Students, Parents, Teachers, and an adaptive Desktop Web Dashboard for Institute Administrators.
3. **Trusted Serverless Backend (`functions/`)**: Cloud Functions for Firebase in TypeScript. Executes privileged operations including Razorpay order creation, HMAC-SHA256 signature verification, idempotent webhook processing, parent-child cryptographic linking, role assignment, and FCM push notifications.
4. **Security & Infrastructure (`firebase/`)**: Declarative Firestore Security Rules (RBAC), Storage Security Rules, composite indexes, and local Firebase Emulator Suite configurations.

---

## 2. Monorepo Structure

```
Radiance_Institute/
├── apps/
│   ├── public_website/          # Next.js 15+ Public Marketing & Admissions Portal
│   │   ├── app/                 # App Router (/about, /classes, /subjects, /admissions, etc.)
│   │   ├── components/          # Accessible Navbar, Footer, and UI blocks
│   │   └── package.json
│   │
│   └── radiance_flutter/        # Flutter Multi-Platform App (Android, iOS, Web Admin)
│       ├── lib/
│       │   ├── core/            # Design tokens (#2059A5 Royal Blue), theme, utils
│       │   ├── data/            # Models, Repositories, Mock Data Source
│       │   ├── modules/         # Auth, Student, Parent, Teacher, Admin modules
│       │   └── main.dart
│       ├── test/                # Unit and Widget test suites
│       └── pubspec.yaml
│
├── functions/                   # Cloud Functions for Firebase (TypeScript)
│   ├── src/                     # Payments (Razorpay), Auth, CRM, Notifications
│   ├── test/                    # Jest Unit Tests (Financial math, HMAC crypto)
│   └── package.json
│
├── firebase/                    # Security Rules & Indexes
│   ├── firestore.rules          # Strict RBAC access control
│   ├── storage.rules            # File size & type restrictions
│   └── firestore.indexes.json   # Composite indexes
│
├── docs/                        # Complete System Specifications
│   ├── PRD.md                   # Product Requirements Document
│   ├── ARCHITECTURE.md          # Logical & Physical Architecture
│   ├── DATABASE_SCHEMA.md       # Firestore Schemas & minor-unit conventions
│   ├── SECURITY.md              # Access Control, Cryptography & Rules
│   ├── PAYMENT_FLOW.md          # Razorpay Order, Webhook & Reconciliation
│   ├── DEPLOYMENT.md            # CI/CD, Emulator & Cloud Deployment Guide
│   └── IMPLEMENTATION_PLAN.md   # Roadmap & Phase Gates
│
├── scripts/                     # Automation & Build Scripts
│   ├── test_all.sh              # Runs full test suite across all sub-projects
│   ├── build_all.sh             # Compiles all applications
│   └── dev_all.sh               # Local development instructions
│
├── .env.example                 # Environment variable templates
├── firebase.json                # Firebase configuration & emulator ports
└── README.md                    # Master documentation
```

---

## 3. Brand Identity & Visual System

* **Primary Royal Blue:** `#2059A5` (Brochure primary, buttons, active navigation)
* **Dark Navy:** `#172B4D` (Typography, headers, dark backgrounds)
* **Light Blue:** `#EAF2FF` (Badges, subtle card backgrounds)
* **Pure White:** `#FFFFFF` (Surface cards, contrast containers)
* **Accent Gold:** `#D97706` (Tagline highlights, badges)

---

## 4. Feature Checklist

| Module | Feature | Status | Automated Test Coverage |
|---|---|---|---|
| **Public Website** | Home, About, Classes 6-12, Senior Secondary PCM | ✅ Implemented | Next.js Build SSG (22/22 Pages) |
| **Public Website** | Admission Enquiry Submission with Server Validation | ✅ Implemented | API Route Handler |
| **Public Website** | SEO Metadata, Robots, Sitemap, Schema.org JSON-LD | ✅ Implemented | Built-in Verification |
| **Flutter Core** | Material 3 Design System & Royal Blue Branding | ✅ Implemented | Widget Test |
| **Flutter Core** | Role-Based Navigation (Student, Parent, Teacher, Admin) | ✅ Implemented | Widget Test |
| **Student** | Timetable, Enrolled Batches, Class Schedule | ✅ Implemented | Widget & Model Tests |
| **Student** | Attendance History & Percentage Calculations | ✅ Implemented | Unit & Widget Tests |
| **Student** | Homework Viewing, Submission & Teacher Feedback | ✅ Implemented | Widget Test |
| **Student** | Published Test Scores & Marks Cards | ✅ Implemented | Widget Test |
| **Student** | Invoices & Outstanding Balance (Paise precision) | ✅ Implemented | Unit & Widget Tests |
| **Parent** | Phone OTP Registration & Multi-Child Switcher | ✅ Implemented | Widget Test |
| **Parent** | Cryptographic Parent-Child Linking Challenge | ✅ Implemented | Unit & Cloud Functions |
| **Parent** | Real-time Attendance & Assessment Monitoring | ✅ Implemented | Widget Test |
| **Parent** | Online Fee Payment & Verified Receipt Generation | ✅ Implemented | Unit & Cloud Functions |
| **Teacher** | Batch Management & Classroom Schedule | ✅ Implemented | Widget Test |
| **Teacher** | Deterministic Session Attendance (`{batchId}_{date}_{studentId}`) | ✅ Implemented | Unit Test |
| **Teacher** | Assignment Creation with Deadlines | ✅ Implemented | Widget Test |
| **Teacher** | Assessment Creation & Result Publication | ✅ Implemented | Widget Test |
| **Admin** | Responsive Web Dashboard (Desktop Sidebar + Mobile Tabs) | ✅ Implemented | Web Build |
| **Admin** | Admissions CRM Pipeline (NEW -> ADMITTED) | ✅ Implemented | Widget Test |
| **Admin** | Student Enrollment & Teacher Assignment | ✅ Implemented | Widget Test |
| **Admin** | Custom Fee Plan Invoicing & Reconciliation Ledger | ✅ Implemented | Unit & Widget Tests |
| **Admin** | System Audit Logs Viewer | ✅ Implemented | Widget Test |
| **Backend** | Cloud Functions: Razorpay Orders & HMAC Webhook | ✅ Implemented | Jest Unit Tests |
| **Backend** | Cloud Functions: Minor Units (Paise) Arithmetic | ✅ Implemented | Jest Unit Tests |
| **Security** | Firestore & Storage Security Rules (RBAC) | ✅ Implemented | Rules Audit |

---

## 5. Quick Start & Setup Commands

### 5.1 Run Master Test Suite
```bash
# Runs Jest tests for Cloud Functions + Flutter unit & widget tests
./scripts/test_all.sh
```

### 5.2 Build All Applications
```bash
# Compiles Cloud Functions, builds Next.js SSG site, and Flutter Web app
./scripts/build_all.sh
```

### 5.3 Local Development
```bash
# 1. Public Website
cd apps/public_website
npm run dev
# Opens at http://localhost:3000

# 2. Flutter Mobile / Web Admin
cd apps/radiance_flutter
flutter run -d chrome

# 3. Firebase Emulator Suite
firebase emulators:start --only auth,firestore,functions,storage
```

---

## 6. Financial & Payment Protocol

All currency amounts in the database are stored as **64-bit integer minor units (paise)** to eliminate floating-point precision errors (e.g., ₹1,500.00 is stored as `150000`).

Payments integrate with Razorpay:
1. Client requests order for authoritative invoice balance due.
2. Cloud Function verifies authorization and calls Razorpay Orders API.
3. Client completes checkout via UPI, Cards, or NetBanking.
4. Server verifies HMAC-SHA256 signature and processes webhooks idempotently.
5. Invoice balance is reconciled in an ACID transaction and an immutable receipt record is generated.

---

## 7. Sandbox vs. Production Activation

* **Current State:** The platform contains a complete sandbox implementation. All financial calculations, parent-child linking validations, attendance session locks, CRM pipelines, and UI flows are functional and tested.
* **Production Activation:** Requires provisioning a live Firebase project (`firebase use <project-id>`) and supplying genuine merchant credentials (`RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`) in `functions/.env`.

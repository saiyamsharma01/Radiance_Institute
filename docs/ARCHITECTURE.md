# System Architecture Document
## Radiance Institute — Complete Cross-Platform Education Management Platform

**Document Version:** 1.0.0  
**Target:** Monorepo System Architecture  

---

## 1. High-Level Architectural Diagram

```
+-----------------------------------------------------------------------------------+
|                                  CLIENT LAYER                                     |
+---------------------------------------+-------------------------------------------+
|           PUBLIC WEB APP              |           FLUTTER MULTI-PLATFORM          |
|    Next.js 15+ (App Router, TS)       |          (Android, iOS, Admin Web)        |
|  - Marketing, Curriculum, About       |  - Material 3 Design & Royal Blue Brand   |
|  - Server-side Validated Enquiries    |  - Role-adaptive Navigation (GetX)        |
|  - SEO, Schema.org, Open Graph        |  - Student, Parent, Teacher, Admin Hubs   |
+---------------------------------------+-------------------------------------------+
                   |                                          |
                   | REST / Server Actions                    | Firebase SDK
                   v                                          v
+-----------------------------------------------------------------------------------+
|                              TRUSTED BACKEND LAYER                                |
+-----------------------------------------------------------------------------------+
|                        FIREBASE AUTHENTICATION                                    |
|   - Multi-tenant auth: Email/Password, Phone OTP                                  |
|   - Cryptographic Custom Claims: { role: 'admin' | 'teacher' | 'parent' | 'student' } |
+-----------------------------------------------------------------------------------+
|                     CLOUD FUNCTIONS FOR FIREBASE (Node/TS)                        |
|   - API: Submit & Validate Admission Enquiry                                      |
|   - API: Generate Parent-Child Linking Token & Verify Link Request                |
|   - API: Create Gateway Payment Order (Razorpay Sandbox/Production)               |
|   - Webhook: Idempotent Payment Signature Verification & Reconciliation           |
|   - Event Triggers: Notification Dispatch, Receipt Issuance, Audit Logging        |
+-----------------------------------------------------------------------------------+
|                             DATA & STORAGE LAYER                                  |
+---------------------------------------+-------------------------------------------+
|           CLOUD FIRESTORE             |               CLOUD STORAGE               |
|  - Normalized Document Collections    |  - Homework PDF & Image Submissions       |
|  - Granular Security Rules (RBAC)     |  - Study Notes & Syllabus Materials       |
|  - Bounded Queries & Composite Indexes|  - Verified Payment Receipts              |
+---------------------------------------+-------------------------------------------+
                                   |
                                   v
+-----------------------------------------------------------------------------------+
|                            EXTERNAL SERVICES LAYER                                |
+---------------------------------------+-------------------------------------------+
|          RAZORPAY PAYMENT GATEWAY     |          FIREBASE CLOUD MESSAGING (FCM)   |
|  - Server-side Order Creation         |  - Device Registration Tokens             |
|  - Webhook Delivery with HMAC-SHA256  |  - Instant Push Notifications             |
|  - UPI, NetBanking, Debit/Credit Card |  - Topic Subscriptions (Batches/Classes)  |
+---------------------------------------+-------------------------------------------+
```

---

## 2. Monorepo Directory Organization

```
Radiance_Institute/
├── apps/
│   ├── radiance_flutter/           # Cross-platform Flutter Application
│   │   ├── android/                # Native Android configuration
│   │   ├── ios/                    # Native iOS configuration
│   │   ├── web/                    # Responsive Web Admin build config
│   │   ├── lib/
│   │   │   ├── core/               # Design tokens, themes, network, constants
│   │   │   │   ├── constants/      # App constants, routes, colors
│   │   │   │   ├── theme/          # Royal Blue Material 3 theme & dark mode
│   │   │   │   ├── utils/          # Currency formatters, date utilities, validators
│   │   │   │   └── widgets/        # Universal buttons, cards, dialogs, badges
│   │   │   ├── data/               # Models and Firebase data providers
│   │   │   │   ├── models/         # Firestore DTOs with toJson/fromJson
│   │   │   │   └── repositories/   # Data access repositories
│   │   │   ├── modules/            # Feature modules with GetX pattern
│   │   │   │   ├── auth/           # Login, OTP verification, onboarding
│   │   │   │   ├── admin/          # Admin portal: Students, Teachers, Batches, Fees
│   │   │   │   ├── student/        # Student portal: Timetable, Attendance, Homework
│   │   │   │   ├── parent/         # Parent portal: Children switch, Fees, Payments
│   │   │   │   ├── teacher/        # Teacher portal: Attendance, Homework, Marks
│   │   │   │   └── common/         # Profile, Notifications, Settings
│   │   │   └── main.dart           # App bootstrap, Firebase init, GetX route setup
│   │   ├── test/                   # Unit, widget, and mock repository tests
│   │   └── pubspec.yaml            # Flutter dependencies and assets
│   │
│   └── public_website/             # Public Marketing & Admissions Website
│       ├── app/                    # Next.js App Router pages
│       │   ├── layout.tsx          # Root layout with Nav, Footer, SEO meta
│       │   ├── page.tsx            # Home page with hero, curriculum, stats
│       │   ├── about/              # About Radiance Institute & Campus
│       │   ├── classes/            # Classes 6 to 12 overview
│       │   ├── classes/[classLevel]# Detailed Class syllabus
│       │   ├── subjects/           # Senior Sec Physics, Chem, Math focus
│       │   ├── admissions/         # Admission process & enquiry form
│       │   ├── contact/            # Amritsar address, phone, Google map
│       │   ├── faq/                # Frequently asked questions
│       │   ├── privacy-policy/     # Privacy policy
│       │   ├── terms/              # Terms and conditions
│       │   └── api/                # Route handlers (Enquiry submission)
│       ├── components/             # Reusable accessible UI components
│       ├── public/                 # Static assets, branding, icons
│       ├── package.json            # Website dependencies
│       ├── tailwind.config.ts      # Tailwind configuration with brand tokens
│       └── tsconfig.json           # TypeScript configuration
│
├── functions/                      # Cloud Functions for Firebase
│   ├── src/
│   │   ├── index.ts                # Entrypoint exporting HTTP and trigger functions
│   │   ├── admissions/             # Enquiry validation & notification logic
│   │   ├── auth/                   # Custom claims assignment & parent-child linking
│   │   ├── payments/               # Razorpay order generation & webhook verification
│   │   ├── notifications/          # FCM dispatch triggers
│   │   └── utils/                  # Cryptography, validation, minor-unit math
│   ├── test/                       # Unit tests for functions (Jest/Mocha)
│   ├── package.json                # Functions dependencies
│   └── tsconfig.json               # Functions TypeScript setup
│
├── firebase/                       # Firebase Infrastructure Rules & Indexes
│   ├── firestore.rules             # Comprehensive security rules
│   ├── storage.rules               # Cloud Storage access rules
│   └── firestore.indexes.json      # Composite query index definitions
│
├── docs/                           # Architecture, PRD, Security & Payment Docs
│   ├── PRD.md
│   ├── ARCHITECTURE.md
│   ├── DATABASE_SCHEMA.md
│   ├── SECURITY.md
│   ├── PAYMENT_FLOW.md
│   ├── DEPLOYMENT.md
│   └── IMPLEMENTATION_PLAN.md
│
├── scripts/                        # Development and CI automation scripts
│   ├── dev_all.sh                  # Concurrently start dev environments
│   ├── test_all.sh                 # Run all unit/widget/integration tests
│   └── seed_emulator.ts            # Seed script for local development
│
├── firebase.json                   # Root Firebase configuration
└── README.md                       # Master documentation & quickstart
```

---

## 3. Flutter Application Architecture

### 3.1 Pattern: Clean Modular Architecture with GetX
To achieve high testability, separation of concerns, and clean state handling across Android, iOS, and Web, the Flutter app follows a 3-tier modular architecture:

```
[UI Layer / Presentation]
  └─ View Widgets (StatelessWidget / GetView<Controller>)
       │   ▲
       │   │  Observables (Rx<T>, Obx)
       ▼   │
  └─ GetxController (Business logic, form state, error handling)
       │
       ▼
[Domain / Repository Layer]
  └─ Abstract Repositories (IAuthRepo, IAcademicRepo, IFeeRepo)
  └─ Concrete Repositories (FirestoreAuthRepo, FirestoreAcademicRepo)
       │
       ▼
[Data Layer]
  └─ Models (Entity to/from Firestore Map converter with type-safety)
  └─ Data Sources (FirebaseFirestore, FirebaseAuth, FirebaseStorage, ApiClient)
```

### 3.2 Responsive Navigation Strategy
* **Mobile (Android/iOS):** Bottom Navigation Bar for rapid thumb access + Drawer for secondary options.
* **Desktop / Web Admin:** Persistent Collapsible Sidebar Navigation + Top Header with breadcrumbs, role badge, institute selector, and quick search.
* Breakpoint rules:
  * Compact (< 600dp): Mobile layout
  * Medium (600dp - 1024dp): Tablet adaptive layout
  * Expanded (> 1024dp): Multi-column desktop dashboard

---

## 4. Trusted Backend & Serverless API Design

Privileged operations are strictly isolated to Cloud Functions:
1. `submitEnquiry`: Public callable endpoint with schema validation, phone normalization, anti-spam rate limiting, and email/SMS alerts to administrators.
2. `createParentLinkRequest` & `verifyParentLinkRequest`: Cryptographically hashes and validates student roll numbers, birthdates, and parent phone OTPs before linking `parentUids` in `students/{studentId}`.
3. `createPaymentOrder`: Validates invoice balance due, ensures no duplicate active orders, and contacts Razorpay Orders API to generate an authoritative `gatewayOrderId`.
4. `handleRazorpayWebhook`: Verifies `X-Razorpay-Signature` with HMAC-SHA256, ensures idempotent event processing via `payment_events/{eventId}`, reconciles `fee_invoices/{invoiceId}` in a Firestore transaction, and generates `receipt_records/{receiptId}`.
5. `assignUserRole`: Privileged administrator endpoint that writes Firebase Custom Auth Claims and updates `users/{uid}`.

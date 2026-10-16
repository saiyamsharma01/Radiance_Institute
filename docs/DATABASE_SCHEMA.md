# Database Schema Document
## Radiance Institute — Cloud Firestore & Relational Model Specifications

**Document Version:** 1.0.0  
**Storage Engine:** Google Cloud Firestore (Document NoSQL with ACID Transactions)  
**Currency Convention:** Integer minor units (INR Paise, ₹1.00 = 100 paise)  
**Timestamp Standard:** UTC ISO-8601 strings or Firestore `FieldValue.serverTimestamp()`  

---

## 1. Schema Entity Relationship Overview

```
[Users]
  │
  ├─► [Students] ◄────── [Enrolments] ──────► [Batches] ◄─── [Subjects]
  │         │                                     ▲              ▲
  │         │                                     │              │
  │         ├─► [Attendance] ─────────────────────┤              │
  │         ├─► [Submissions] ──► [Homework] ─────┤              │
  │         ├─► [Results] ──────► [Tests] ────────┴──────────────┘
  │         │
  │         ├─► [Fee Invoices] ◄── [Fee Plans]
  │         │         ▲
  │         │         ├─► [Payment Orders] ──► [Payments] ──► [Receipts]
  │         ▼         │
  ├─► [Parents] ──────┤ (via linkedStudentIds)
  │
  └─► [Teachers] ─────┴─► (assigned to Batches)
```

---

## 2. Core Collections & Field Definitions

### 2.1 `users/{uid}`
Stores identity, contact info, and system role for authentication checks.
```typescript
interface UserDocument {
  uid: string;                       // Matches Firebase Auth UID
  displayName: string;               // Full legal name
  role: 'admin' | 'teacher' | 'parent' | 'student';
  phoneNumber: string;               // E.164 normalized format (+91XXXXXXXXXX)
  email?: string;                    // Optional or institute-assigned email
  accountStatus: 'active' | 'suspended' | 'pending';
  fcmTokens?: string[];              // Device tokens for push messaging
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.2 `students/{studentId}`
Stores official student profile, class affiliation, and linked parents.
```typescript
interface StudentDocument {
  studentId: string;                 // Stable alphanumeric ID (e.g., "RAD-2026-0042")
  userUid: string;                   // Firebase Auth UID if student account is activated
  fullName: string;
  classLevel: '6' | '7' | '8' | '9' | '10' | '11' | '12';
  academicYear: string;              // e.g., "2026-2027"
  parentUids: string[];              // UIDs of approved parents who have access
  rollNumber: string;                // Institute roll number
  dateOfBirth: string;               // "YYYY-MM-DD" for linking verification
  status: 'active' | 'graduated' | 'inactive';
  emergencyContact: string;
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.3 `parents/{parentUid}`
Stores verified parent details and their linked student IDs.
```typescript
interface ParentDocument {
  uid: string;                       // Matches Firebase Auth UID
  displayName: string;
  verifiedPhone: string;             // Verified via Firebase Phone OTP
  linkedStudentIds: string[];        // Array of authorized student IDs
  accountStatus: 'active' | 'suspended';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.4 `teachers/{teacherUid}`
Stores teacher profiles, subject expertise, and assigned batch IDs.
```typescript
interface TeacherDocument {
  uid: string;                       // Matches Firebase Auth UID
  displayName: string;
  email: string;
  phoneNumber: string;
  subjectIds: string[];              // e.g., ["sub_physics", "sub_math"]
  assignedBatchIds: string[];        // Array of batch IDs assigned for teaching
  accountStatus: 'active' | 'inactive';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.5 `subjects/{subjectId}`
Academic subjects catalog.
```typescript
interface SubjectDocument {
  subjectId: string;                 // e.g., "sub_physics_11", "sub_math_10"
  name: string;                      // "Physics", "Chemistry", "Mathematics"
  classLevels: string[];             // ["11", "12"]
  description?: string;
  status: 'active' | 'archived';
  createdAt: FirebaseFirestore.Timestamp;
}
```

### 2.6 `batches/{batchId}`
Class-wise or subject-wise study groups.
```typescript
interface BatchDocument {
  batchId: string;                   // e.g., "batch_class11_physics_morning"
  name: string;                      // "Class 11 Physics - Batch A"
  classLevel: string;                // "11"
  academicYear: string;              // "2026-2027"
  subjectIds: string[];              // ["sub_physics_11"]
  teacherUids: string[];             // Authorized teachers for this batch
  schedule: Array<{
    dayOfWeek: 'Monday' | 'Tuesday' | 'Wednesday' | 'Thursday' | 'Friday' | 'Saturday' | 'Sunday';
    startTime: string;               // "09:00"
    endTime: string;                 // "10:30"
    room?: string;
  }>;
  status: 'active' | 'completed' | 'cancelled';
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.7 `enrolments/{enrolmentId}`
Normalized many-to-many relationship linking a student to a batch.
```typescript
interface EnrolmentDocument {
  enrolmentId: string;               // Deterministic: `${studentId}_${batchId}`
  studentId: string;
  batchId: string;
  subjectIds: string[];
  startDate: string;                 // "YYYY-MM-DD"
  endDate?: string;
  status: 'active' | 'completed' | 'dropped';
  createdAt: FirebaseFirestore.Timestamp;
}
```

### 2.8 `admission_enquiries/{enquiryId}`
Public admission enquiry CRM pipeline.
```typescript
interface AdmissionEnquiryDocument {
  enquiryId: string;                 // e.g., "ENQ-2026-1001"
  studentName: string;
  guardianName: string;
  contactNumber: string;             // 10-digit phone
  classLevel: string;                // "6" to "12"
  academicYear: string;              // "2026-2027"
  subjectIds: string[];              // ["Physics", "Chemistry"]
  preferredCallbackTime?: string;    // "Morning", "Afternoon", "Evening"
  message?: string;
  status: 'NEW' | 'CONTACTED' | 'VISIT_SCHEDULED' | 'ADMITTED' | 'CLOSED';
  assignedTo?: string;               // Admin UID
  followUpAt?: FirebaseFirestore.Timestamp;
  notes?: Array<{
    authorUid: string;
    text: string;
    createdAt: string;
  }>;
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.9 `attendance/{attendanceId}`
Daily attendance records with deterministic keys to prevent duplicate submissions.
```typescript
interface AttendanceDocument {
  attendanceId: string;              // Deterministic: `${batchId}_${date}_${studentId}`
  batchId: string;
  studentId: string;
  sessionId: string;                 // `${batchId}_${date}`
  date: string;                      // "YYYY-MM-DD"
  status: 'PRESENT' | 'ABSENT' | 'LATE' | 'EXCUSED';
  markedBy: string;                  // Teacher UID
  markedAt: FirebaseFirestore.Timestamp;
  correctionStatus: 'NONE' | 'REQUESTED' | 'APPROVED' | 'REJECTED';
  correctionNotes?: string;
}
```

### 2.10 `homework/{homeworkId}` & `submissions/{submissionId}`
Assignments and student submissions.
```typescript
interface HomeworkDocument {
  homeworkId: string;
  batchId: string;
  subjectId: string;
  title: string;
  description: string;
  resourcePaths: string[];           // Firebase Storage paths
  deadline: FirebaseFirestore.Timestamp;
  createdBy: string;                 // Teacher UID
  createdAt: FirebaseFirestore.Timestamp;
}

interface SubmissionDocument {
  submissionId: string;              // Deterministic: `${homeworkId}_${studentId}`
  homeworkId: string;
  studentId: string;
  resourcePaths: string[];           // Student uploaded documents
  submittedAt: FirebaseFirestore.Timestamp;
  status: 'SUBMITTED' | 'LATE' | 'GRADED' | 'RESUBMISSION_REQUESTED';
  feedback?: string;
  score?: number;                    // Optional numerical grade
  reviewedBy?: string;               // Teacher UID
  reviewedAt?: FirebaseFirestore.Timestamp;
}
```

### 2.11 `tests/{testId}` & `results/{resultId}`
Class tests, marks, and published progress reports.
```typescript
interface TestDocument {
  testId: string;
  batchId: string;
  subjectId: string;
  title: string;                     // e.g., "Unit Test 1: Thermodynamics"
  testDate: string;                  // "YYYY-MM-DD"
  totalMarks: number;
  status: 'SCHEDULED' | 'MARKS_ENTERED' | 'PUBLISHED' | 'CANCELLED';
  createdBy: string;
  createdAt: FirebaseFirestore.Timestamp;
}

interface ResultDocument {
  resultId: string;                  // Deterministic: `${testId}_${studentId}`
  testId: string;
  studentId: string;
  marksObtained: number;
  percentage: number;
  feedback?: string;
  publishedAt?: FirebaseFirestore.Timestamp;
}
```

### 2.12 `fee_plans/{planId}` & `fee_invoices/{invoiceId}`
Tuition fee structure and immutable student invoices.
```typescript
interface FeePlanDocument {
  planId: string;
  name: string;                      // e.g., "Class 11 PCM Standard Tuition"
  classLevel?: string;
  batchId?: string;
  subjectIds: string[];
  amount: number;                    // In integer minor units (paise) e.g., 350000 = ₹3500.00
  billingFrequency: 'MONTHLY' | 'QUARTERLY' | 'ANNUAL' | 'ONE_TIME';
  effectiveFrom: string;             // "YYYY-MM-DD"
  effectiveTo?: string;
  status: 'active' | 'archived';
  createdAt: FirebaseFirestore.Timestamp;
}

interface FeeInvoiceDocument {
  invoiceId: string;                 // e.g., "INV-2026-00891"
  studentId: string;
  academicYear: string;              // "2026-2027"
  period: string;                    // e.g., "October 2026"
  lineItems: Array<{
    description: string;
    subjectId?: string;
    amount: number;                  // In paise
  }>;
  subtotal: number;                  // In paise
  discount: number;                  // In paise
  amountDue: number;                 // Subtotal - Discount (in paise)
  amountPaid: number;                // Sum of verified payments (in paise)
  balanceDue: number;                // amountDue - amountPaid (in paise)
  dueDate: string;                   // "YYYY-MM-DD"
  status: 'DRAFT' | 'ISSUED' | 'PARTIALLY_PAID' | 'PAID' | 'OVERDUE' | 'CANCELLED';
  createdBy: string;                 // Admin UID
  createdAt: FirebaseFirestore.Timestamp;
  updatedAt: FirebaseFirestore.Timestamp;
}
```

### 2.13 `payment_orders/{orderId}` & `payments/{paymentId}`
Payment gateway interaction records and verified receipts.
```typescript
interface PaymentOrderDocument {
  orderId: string;                   // Internal order ID
  invoiceId: string;
  studentId: string;
  gateway: 'RAZORPAY';
  gatewayOrderId: string;            // Razorpay order ID (e.g., "order_EKwxwAgIt4nlq6")
  amount: number;                    // In paise
  currency: 'INR';
  idempotencyKey: string;
  status: 'CREATED' | 'ATTEMPTED' | 'PAID' | 'EXPIRED';
  createdAt: FirebaseFirestore.Timestamp;
}

interface PaymentDocument {
  paymentId: string;                 // Internal payment record ID
  invoiceId: string;
  studentId: string;
  gatewayPaymentId: string;          // Razorpay payment ID ("pay_29QQoUBi66xm2f")
  gatewayOrderId: string;
  amount: number;                    // In paise
  currency: 'INR';
  status: 'SUCCESS' | 'FAILED' | 'REFUNDED';
  verifiedAt: FirebaseFirestore.Timestamp;
  receiptId: string;
  createdAt: FirebaseFirestore.Timestamp;
}

interface PaymentEventDocument {
  eventId: string;                   // Razorpay webhook event ID
  eventType: string;                 // e.g., "payment.captured"
  verificationStatus: 'VERIFIED' | 'INVALID_SIGNATURE';
  processedAt: FirebaseFirestore.Timestamp;
  processingResult: 'SUCCESS' | 'DUPLICATE_IGNORED' | 'ERROR';
  rawPayload?: any;
}
```

### 2.14 Supporting Collections
* `parent_link_requests/{requestId}`: Security tokens (`token`, `studentRollNumber`, `studentDob`, `parentPhone`, `expiresAt`, `status`).
* `receipt_records/{receiptId}`: Official verified institute receipts with invoice reference, receipt sequence number, tax identification, and payment breakdown.
* `announcements/{announcementId}`: Institute and batch-level announcements with targeted audiences (`['all', 'class_11', 'batch_phys11']`).
* `notifications/{notificationId}`: In-app user notifications (`recipientUid`, `title`, `body`, `read`, `category`, `deepLink`).
* `audit_logs/{logId}`: Append-only system audit log (`actorUid`, `action`, `resource`, `details`, `ipAddress`, `timestamp`).

---

## 3. Required Firestore Composite Indexes

1. `admission_enquiries`: `status` ASC, `createdAt` DESC
2. `attendance`: `batchId` ASC, `date` DESC, `status` ASC
3. `attendance`: `studentId` ASC, `date` DESC
4. `homework`: `batchId` ASC, `deadline` DESC
5. `tests`: `batchId` ASC, `testDate` DESC
6. `fee_invoices`: `studentId` ASC, `dueDate` DESC, `status` ASC
7. `fee_invoices`: `status` ASC, `dueDate` ASC
8. `audit_logs`: `resource` ASC, `timestamp` DESC

# Security Architecture & Permissions Specification
## Radiance Institute — Access Control, Cryptography & Compliance

**Document Version:** 1.0.0  
**Status:** Approved  

---

## 1. Authentication & Identity Management

1. **Identity Provider:** Firebase Authentication
2. **Authentication Mechanisms:**
   * **Administrators & Teachers:** Email and secure password (assigned by institute administration with forced password reset on first login).
   * **Students:** Institute-assigned student credentials or single sign-on with phone verification.
   * **Parents:** Phone OTP verification (via Firebase Phone Auth) to guarantee verified ownership of the parent's mobile number.
3. **Elevated Privileges & Custom Claims:**
   * Privileges are **never** determined by client-side Firestore documents alone.
   * Custom Auth Claims are cryptographically embedded in the Firebase ID Token:
     ```json
     {
       "role": "admin" | "teacher" | "parent" | "student",
       "instituteId": "radiance_amritsar",
       "studentIds": ["RAD-2026-0042"] // for parents
     }
     ```
   * Custom claims are issued **exclusively** by trusted Cloud Functions using the Firebase Admin SDK.

---

## 2. Role-Based Access Control (RBAC) Matrix

| Resource Collection | Student | Parent | Teacher | Institute Admin | Public Visitor |
|---|---|---|---|---|---|
| `users` | Read Own | Read Own | Read Own | Full Access | No Access |
| `students` | Read Own | Read Linked Children | Read Assigned Batches | Full Access | No Access |
| `parents` | No Access | Read/Update Own | No Access | Full Access | No Access |
| `teachers` | Read Profile | Read Profile | Read Own | Full Access | No Access |
| `subjects` | Read Only | Read Only | Read Only | Full Access | Read Only |
| `batches` | Read Enrolled | Read Linked Child's | Read Assigned | Full Access | No Access |
| `enrolments` | Read Own | Read Linked Child's | Read Assigned Batches | Full Access | No Access |
| `admission_enquiries` | No Access | No Access | No Access | Full Access | Create Only (Validated) |
| `attendance` | Read Own | Read Linked Child's | Mark/Read Assigned | Full Access | No Access |
| `homework` | Read Enrolled | Read Linked Child's | Create/Update Assigned | Full Access | No Access |
| `submissions` | Create/Read Own | Read Linked Child's | Grade Assigned | Full Access | No Access |
| `tests` | Read Enrolled | Read Linked Child's | Create/Update Assigned | Full Access | No Access |
| `results` | Read Own Published | Read Linked Child's Published | Enter Marks for Assigned | Full Access | No Access |
| `fee_plans` | No Access | No Access | No Access | Full Access | No Access |
| `fee_invoices` | Read Own | Read Linked Child's | No Access | Full Access | No Access |
| `payment_orders` | Read Own | Read Linked Child's | No Access | Full Access | No Access |
| `payments` | Read Own | Read Linked Child's | No Access | Full Access | No Access |
| `receipt_records` | Read Own | Read Linked Child's | No Access | Full Access | No Access |
| `audit_logs` | No Access | No Access | No Access | Read Only (Immutable) | No Access |

---

## 3. Cryptographic Parent-Child Linking Protocol

To prevent unauthorized access to minors' records, a phone number match alone is **insufficient**. Linking requires strict cryptographic validation:

1. **Initiation:** The parent logs in via Firebase Phone Auth (`request.auth.token.phone_number` verified).
2. **Challenge Request:** The parent enters the Student's official Institute Roll Number and Date of Birth (DOB).
3. **Verification in Cloud Function:**
   * Cloud Function queries `students/{studentId}` inside a secure transaction.
   * Compares `student.dateOfBirth` with the submitted DOB and checks if `student.emergencyContact` matches `request.auth.token.phone_number`.
   * If pre-authorized by institute admin, automatically appends `parentUid` to `student.parentUids` and records an audit log.
   * If manual approval is required, creates a `parent_link_requests/{requestId}` with status `PENDING_ADMIN_REVIEW`.
4. **Token Refresh:** Once approved, the backend updates the parent's Custom Claims with the linked student ID and dispatches a notification to both parent and student.

---

## 4. Public Form Security & Anti-Spam Architecture

1. **Route:** `/api/admissions/enquiry` or Cloud Function `submitAdmissionEnquiry`.
2. **Input Sanitization:** All string fields sanitized to prevent XSS and SQL/NoSQL injection.
3. **Rate Limiting:** IP-based and phone-based rate limiting (maximum 3 enquiry submissions per IP per hour).
4. **Phone Validation:** E.164 normalization ensuring valid 10-digit Indian mobile numbers (`^[6-9]\d{9}$`).
5. **Least Privilege:** Public users cannot read the `admission_enquiries` collection under any circumstances.

---

## 5. Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Homework submissions: Students can upload only their own PDFs/Images under 15MB
    match /submissions/{homeworkId}/{studentId}/{fileName} {
      allow read: if request.auth != null && (
        request.auth.token.role == 'admin' ||
        request.auth.token.role == 'teacher' ||
        request.auth.uid == studentId
      );
      allow write: if request.auth != null &&
        request.auth.uid == studentId &&
        request.resource.size < 15 * 1024 * 1024 &&
        (request.resource.contentType.matches('application/pdf') ||
         request.resource.contentType.matches('image/.*'));
    }

    // Study materials: Teachers and Admins can upload; Students & Parents read-only
    match /study_materials/{batchId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && (
        request.auth.token.role == 'admin' ||
        request.auth.token.role == 'teacher'
      );
    }
    
    // Payment receipts: Read-only for linked parent/student, created only by admin backend
    match /receipts/{receiptId}.pdf {
      allow read: if request.auth != null;
      allow write: if false; // Only Cloud Functions Admin SDK
    }
  }
}
```

---

## 6. Audit Logging & Compliance

All privileged mutations write immutable documents to `audit_logs/{logId}`:
* Actor UID and display name
* Target resource collection and document ID
* Action type (`FEE_ADJUSTMENT`, `ROLE_MODIFIED`, `RESULT_PUBLISHED`, `PARENT_LINKED`, `ATTENDANCE_CORRECTED`)
* State delta (before and after snapshots)
* Client IP address and User Agent
* Server timestamp

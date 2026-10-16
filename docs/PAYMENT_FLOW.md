# Payment Architecture & Financial Workflow
## Radiance Institute — Razorpay Integration & Reconciliation Specifications

**Document Version:** 1.0.0  
**Gateway Provider:** Razorpay (India Standard Gateway - UPI, RuPay, Visa, MasterCard, NetBanking)  
**Currency:** Indian Rupee (INR)  
**Internal Monetary Units:** Integer Minor Units (Paise, ₹1.00 = 100 paise)  
**Floating Point Arithmetic:** Strictly Prohibited  

---

## 1. End-to-End Sequence Diagram

```
Parent / Student Mobile/Web           Trusted Backend (Cloud Functions)           Razorpay Payment Gateway
            │                                         │                                      │
            ├─ 1. Request Checkout for Invoice ─────►│                                      │
            │     { invoiceId, studentId }            ├─ Verify Parent/Student Link          │
            │                                         ├─ Validate Unpaid Balance Due         │
            │                                         ├─ 2. Create Order (paise) ───────────►│
            │                                         │     POST /v1/orders                  │
            │                                         │◄─── 3. Return gatewayOrderId ────────┤
            │                                         ├─ Save payment_orders/{orderId}       │
            │◄── 4. Return Order Credentials ─────────┤                                      │
            │    { orderId, amountPaise, keyId }      │                                      │
            │                                         │                                      │
            │─── 5. Open Razorpay Checkout Modal ─────┼─────────────────────────────────────►│
            │    (UPI / Card / NetBanking)            │                                      │
            │◄── 6. Payment Success / Failure Callback┼──────────────────────────────────────┤
            │                                         │                                      │
            │─── 7. Client sends signature for check ─►│                                      │
            │                                         │                                      │
            │                                         │◄── 8. Webhook: payment.captured ─────┤
            │                                         │    (X-Razorpay-Signature)            │
            │                                         │                                      │
            │                                         ├─ 9. Cryptographic HMAC Check         │
            │                                         ├─ 10. Check Idempotency Table         │
            │                                         ├─ 11. Transactional Reconciliation    │
            │                                         │      - Decrement balanceDue          │
            │                                         │      - Increment amountPaid          │
            │                                         │      - Set invoice status (PAID)     │
            │                                         │      - Create payments record        │
            │                                         │      - Generate receipt record       │
            │                                         ├─ 12. Dispatch Push Notification      │
            │◄── 13. UI updates with Verified Receipt ─┤                                      │
```

---

## 2. Server-Side Order Generation (`createPaymentOrder`)

Client never calculates or passes the payment amount. The amount is determined strictly from the authoritative database record:

```typescript
// Privileged Cloud Function
export const createPaymentOrder = async (data: { invoiceId: string }, context: CallableContext) => {
  const { auth } = context;
  if (!auth) throw new HttpsError('unauthenticated', 'User must be authenticated.');

  const invoiceRef = db.collection('fee_invoices').doc(data.invoiceId);
  const invoiceSnap = await invoiceRef.get();
  if (!invoiceSnap.exists) throw new HttpsError('not-found', 'Invoice not found.');

  const invoice = invoiceSnap.data()!;
  
  // Verify authorization: User must be admin OR parent linked to student OR student themselves
  await verifyInvoiceAccess(auth, invoice.studentId);

  // Validate balance
  const balanceDuePaise = invoice.balanceDue;
  if (balanceDuePaise <= 0) {
    throw new HttpsError('failed-precondition', 'Invoice has no outstanding balance.');
  }

  // Create Razorpay order via official SDK
  const options = {
    amount: balanceDuePaise, // In paise (e.g., 350000 = ₹3500.00)
    currency: 'INR',
    receipt: invoice.invoiceId,
    notes: {
      studentId: invoice.studentId,
      invoiceId: data.invoiceId,
      academicYear: invoice.academicYear,
    }
  };

  const razorpayOrder = await razorpayInstance.orders.create(options);

  // Record internal order document
  const orderId = `ord_${razorpayOrder.id}`;
  await db.collection('payment_orders').doc(orderId).set({
    orderId,
    invoiceId: data.invoiceId,
    studentId: invoice.studentId,
    gateway: 'RAZORPAY',
    gatewayOrderId: razorpayOrder.id,
    amount: balanceDuePaise,
    currency: 'INR',
    status: 'CREATED',
    createdAt: FieldValue.serverTimestamp(),
  });

  return {
    orderId: razorpayOrder.id,
    amount: balanceDuePaise,
    currency: 'INR',
    keyId: process.env.RAZORPAY_KEY_ID,
  };
};
```

---

## 3. Cryptographic Signature & Webhook Verification

Webhooks deliver authoritative payment state. The backend validates the signature using HMAC-SHA256:

```typescript
import * as crypto from 'crypto';

export const verifyWebhookSignature = (
  rawBody: string,
  signatureHeader: string,
  webhookSecret: string
): boolean => {
  const expectedSignature = crypto
    .createHmac('sha256', webhookSecret)
    .update(rawBody)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(expectedSignature, 'utf8'),
    Buffer.from(signatureHeader, 'utf8')
  );
};
```

---

## 4. Idempotent Transactional Reconciliation

When `payment.captured` arrives:
1. Lookup `payment_events/{eventId}`: If status is `SUCCESS`, gracefully return HTTP 200 without reprocessing (prevent duplicate credit).
2. Execute a Firestore ACID transaction:
   * Read `fee_invoices/{invoiceId}`.
   * Verify previous payment is not duplicate: Check `payments` where `gatewayPaymentId == event.paymentId`.
   * Update invoice:
     ```typescript
     newAmountPaid = invoice.amountPaid + paymentAmountPaise;
     newBalanceDue = Math.max(0, invoice.amountDue - newAmountPaid);
     newStatus = newBalanceDue === 0 ? 'PAID' : 'PARTIALLY_PAID';
     ```
   * Write new `payments/{paymentId}` document.
   * Generate `receipt_records/{receiptId}` with sequential receipt number (e.g., `RAD-REC-2026-0034`).
   * Mark `payment_events/{eventId}` as `SUCCESS`.
3. Dispatch instant push notification to parent: *"Payment of ₹3,500.00 confirmed for Radiance Institute. Receipt #RAD-REC-2026-0034 is now available."*

---

## 5. Handling Edge Cases & Exception Workflows

* **Failed / Dropped Transactions:** Payment marked `FAILED` in event logs; invoice remains `ISSUED` or `OVERDUE`.
* **Disputed / Refunded Payments:** Refund webhook (`refund.processed`) decrements `amountPaid`, increments `balanceDue`, adjusts invoice status to `PARTIALLY_PAID` or `ISSUED`, and records a reversal audit record.
* **Sandbox / Production Switch:** Governed exclusively by environment variables `RAZORPAY_KEY_ID` and `RAZORPAY_KEY_SECRET`. No mock money or unverified payment confirmations are permitted.

import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';
import Razorpay = require('razorpay');
import { CryptoUtils } from '../utils/crypto';
import { MinorUnits } from '../utils/minorUnits';

const getRazorpayInstance = () => {
  const key_id = process.env.RAZORPAY_KEY_ID || 'rzp_test_placeholderKeyId';
  const key_secret = process.env.RAZORPAY_KEY_SECRET || 'placeholderSecretKey';
  return new Razorpay({ key_id, key_secret });
};

/**
 * 1. Creates a server-side order with Razorpay for an authoritative invoice balance.
 */
export const createPaymentOrder = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated.');
  }

  const { invoiceId } = data;
  if (!invoiceId) {
    throw new functions.https.HttpsError('invalid-argument', 'invoiceId is required.');
  }

  const db = admin.firestore();
  const invoiceRef = db.collection('fee_invoices').doc(invoiceId);
  const invoiceSnap = await invoiceRef.get();

  if (!invoiceSnap.exists) {
    throw new functions.https.HttpsError('not-found', 'Invoice not found.');
  }

  const invoice = invoiceSnap.data()!;

  // Authorization check: User must be admin OR linked parent OR student
  const callerUid = context.auth.uid;
  const userToken = context.auth.token;
  const isAdmin = userToken.role === 'admin';
  const isStudent = invoice.studentId === callerUid;
  const isParent = Array.isArray(userToken.linkedStudentIds) && userToken.linkedStudentIds.includes(invoice.studentId);

  if (!isAdmin && !isStudent && !isParent) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'You are not authorized to pay for this invoice.'
    );
  }

  // Check balance due (in integer paise)
  const balanceDue = invoice.balanceDue;
  if (!balanceDue || balanceDue <= 0) {
    throw new functions.https.HttpsError('failed-precondition', 'Invoice has no balance due.');
  }

  const razorpay = getRazorpayInstance();
  const orderOptions = {
    amount: balanceDue, // In paise
    currency: 'INR',
    receipt: invoice.invoiceId || invoiceId,
    notes: {
      invoiceId,
      studentId: invoice.studentId,
      academicYear: invoice.academicYear || '',
    },
  };

  const rzpOrder = await razorpay.orders.create(orderOptions);

  // Record internal payment order
  const orderDocId = `ord_${rzpOrder.id}`;
  await db.collection('payment_orders').doc(orderDocId).set({
    orderId: orderDocId,
    invoiceId,
    studentId: invoice.studentId,
    gateway: 'RAZORPAY',
    gatewayOrderId: rzpOrder.id,
    amount: balanceDue,
    currency: 'INR',
    status: 'CREATED',
    createdBy: callerUid,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return {
    orderId: rzpOrder.id,
    amount: balanceDue,
    currency: 'INR',
    keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_placeholderKeyId',
    invoiceId,
    studentId: invoice.studentId,
  };
});

/**
 * 2. Reconciles an invoice transactionally given confirmed payment details.
 */
export async function reconcileInvoicePayment(
  invoiceId: string,
  gatewayOrderId: string,
  gatewayPaymentId: string,
  amountPaidPaise: number
): Promise<{ receiptId: string; newBalance: number; newStatus: string }> {
  const db = admin.firestore();

  return await db.runTransaction(async (transaction) => {
    const invoiceRef = db.collection('fee_invoices').doc(invoiceId);
    const invoiceSnap = await transaction.get(invoiceRef);

    if (!invoiceSnap.exists) {
      throw new Error(`Invoice ${invoiceId} not found during reconciliation.`);
    }

    const invoice = invoiceSnap.data()!;

    // Check duplicate payment
    const paymentDocRef = db.collection('payments').doc(`pay_${gatewayPaymentId}`);
    const existingPayment = await transaction.get(paymentDocRef);
    if (existingPayment.exists) {
      return {
        receiptId: existingPayment.data()?.receiptId,
        newBalance: invoice.balanceDue,
        newStatus: invoice.status,
      };
    }

    const currentAmountPaid = invoice.amountPaid || 0;
    const newAmountPaid = MinorUnits.add(currentAmountPaid, amountPaidPaise);
    const newBalanceDue = MinorUnits.subtract(invoice.amountDue, newAmountPaid);
    const newStatus = newBalanceDue === 0 ? 'PAID' : 'PARTIALLY_PAID';

    // Update invoice
    transaction.update(invoiceRef, {
      amountPaid: newAmountPaid,
      balanceDue: newBalanceDue,
      status: newStatus,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Generate unique receipt ID: RAD-REC-YYYY-XXXX
    const year = new Date().getFullYear();
    const randomSeq = Math.floor(1000 + Math.random() * 9000);
    const receiptId = `RAD-REC-${year}-${randomSeq}`;

    // Create Payment Record
    transaction.set(paymentDocRef, {
      paymentId: `pay_${gatewayPaymentId}`,
      invoiceId,
      studentId: invoice.studentId,
      gatewayOrderId,
      gatewayPaymentId,
      amount: amountPaidPaise,
      currency: 'INR',
      status: 'SUCCESS',
      receiptId,
      verifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Create Receipt Record
    const receiptRef = db.collection('receipt_records').doc(receiptId);
    transaction.set(receiptRef, {
      receiptId,
      invoiceId,
      studentId: invoice.studentId,
      amount: amountPaidPaise,
      amountFormatted: MinorUnits.formatINR(amountPaidPaise),
      gatewayPaymentId,
      issuedTo: invoice.studentId,
      period: invoice.period || '',
      issuedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { receiptId, newBalance: newBalanceDue, newStatus };
  });
}

/**
 * 3. Client signature check endpoint
 */
export const verifyPaymentSignature = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated.');
  }

  const { razorpay_order_id, razorpay_payment_id, razorpay_signature, invoiceId } = data;
  if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature || !invoiceId) {
    throw new functions.https.HttpsError('invalid-argument', 'All payment verification fields are required.');
  }

  const secret = process.env.RAZORPAY_KEY_SECRET || 'placeholderSecretKey';
  const payload = `${razorpay_order_id}|${razorpay_payment_id}`;
  const isValid = CryptoUtils.verifyRazorpaySignature(payload, razorpay_signature, secret);

  if (!isValid) {
    throw new functions.https.HttpsError('permission-denied', 'Invalid cryptographic payment signature.');
  }

  // Fetch verified payment details from Razorpay
  const razorpay = getRazorpayInstance();
  const paymentDetails = await razorpay.payments.fetch(razorpay_payment_id);
  const amountPaidPaise = Number(paymentDetails.amount);

  const result = await reconcileInvoicePayment(
    invoiceId,
    razorpay_order_id,
    razorpay_payment_id,
    amountPaidPaise
  );

  return {
    success: true,
    receiptId: result.receiptId,
    newBalance: result.newBalance,
    newStatus: result.newStatus,
    amountFormatted: MinorUnits.formatINR(amountPaidPaise),
    message: 'Payment verified and receipt generated successfully.',
  };
});

/**
 * 4. Idempotent Razorpay Webhook Handler
 */
export const handleRazorpayWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method Not Allowed');
    return;
  }

  const signature = req.headers['x-razorpay-signature'] as string;
  const webhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET || 'placeholderWebhookSecret';

  const rawBody = JSON.stringify(req.body);
  const isValid = CryptoUtils.verifyRazorpaySignature(rawBody, signature, webhookSecret);

  if (!isValid) {
    res.status(400).send('Invalid signature');
    return;
  }

  const event = req.body;
  const eventId = event.event_id || `evt_${Date.now()}`;
  const db = admin.firestore();

  // Check Idempotency
  const eventRef = db.collection('payment_events').doc(eventId);
  const existingEvent = await eventRef.get();
  if (existingEvent.exists) {
    res.status(200).json({ status: 'duplicate_event_ignored' });
    return;
  }

  try {
    if (event.event === 'payment.captured') {
      const paymentEntity = event.payload.payment.entity;
      const notes = paymentEntity.notes || {};
      const invoiceId = notes.invoiceId;
      const orderId = paymentEntity.order_id;
      const paymentId = paymentEntity.id;
      const amount = paymentEntity.amount; // In paise

      if (invoiceId) {
        await reconcileInvoicePayment(invoiceId, orderId, paymentId, amount);
      }
    }

    await eventRef.set({
      eventId,
      eventType: event.event,
      verificationStatus: 'VERIFIED',
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
      processingResult: 'SUCCESS',
    });

    res.status(200).json({ status: 'success' });
  } catch (err: any) {
    await eventRef.set({
      eventId,
      eventType: event.event,
      verificationStatus: 'VERIFIED',
      processedAt: admin.firestore.FieldValue.serverTimestamp(),
      processingResult: 'ERROR',
      error: err.message,
    });
    res.status(500).json({ error: err.message });
  }
});

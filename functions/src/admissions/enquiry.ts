import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';

export const submitAdmissionEnquiry = functions.https.onCall(async (data, context) => {
  const {
    studentName,
    guardianName,
    contactNumber,
    classLevel,
    academicYear,
    subjectIds,
    preferredCallbackTime,
    message,
  } = data;

  // Validation
  if (!studentName || !guardianName || !contactNumber || !classLevel) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'studentName, guardianName, contactNumber, and classLevel are required.'
    );
  }

  // Sanitize phone number (must be 10 digits Indian mobile)
  const cleanedPhone = contactNumber.replace(/\D/g, '').slice(-10);
  if (!/^[6-9]\d{9}$/.test(cleanedPhone)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Please enter a valid 10-digit Indian mobile number.'
    );
  }

  // Rate Limiting: Check submissions in the last 2 hours from this phone
  const db = admin.firestore();
  const twoHoursAgo = new Date(Date.now() - 2 * 60 * 60 * 1000);
  const recentEnquiries = await db
    .collection('admission_enquiries')
    .where('contactNumber', '==', cleanedPhone)
    .where('createdAt', '>=', admin.firestore.Timestamp.fromDate(twoHoursAgo))
    .get();

  if (recentEnquiries.size >= 3) {
    throw new functions.https.HttpsError(
      'resource-exhausted',
      'Too many enquiries submitted from this number. Please wait or call the institute directly at +91 183 508 0005.'
    );
  }

  // Generate unique human-readable enquiry reference ID: ENQ-2026-XXXX
  const randomSuffix = Math.floor(1000 + Math.random() * 9000);
  const year = new Date().getFullYear();
  const enquiryReference = `ENQ-${year}-${randomSuffix}`;

  const enquiryDoc = {
    enquiryId: enquiryReference,
    studentName: studentName.trim(),
    guardianName: guardianName.trim(),
    contactNumber: cleanedPhone,
    classLevel: classLevel.toString().trim(),
    academicYear: academicYear || `${year}-${year + 1}`,
    subjectIds: Array.isArray(subjectIds) ? subjectIds : [],
    preferredCallbackTime: preferredCallbackTime || 'Anytime',
    message: message ? message.trim().slice(0, 500) : '',
    status: 'NEW',
    ipAddress: context.rawRequest?.ip || 'unknown',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await db.collection('admission_enquiries').doc(enquiryReference).set(enquiryDoc);

  // Notify Administrators via notifications collection
  await db.collection('notifications').add({
    recipientRole: 'admin',
    title: `New Admission Enquiry: ${studentName}`,
    body: `Class ${classLevel} enquiry received from ${guardianName} (${cleanedPhone}). Reference: ${enquiryReference}`,
    category: 'ADMISSION_ENQUIRY',
    enquiryId: enquiryReference,
    read: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return {
    success: true,
    enquiryReference,
    message:
      'Thank you! Your admission enquiry has been submitted. The Radiance Institute team will contact you shortly.',
  };
});

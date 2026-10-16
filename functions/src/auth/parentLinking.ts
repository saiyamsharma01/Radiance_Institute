import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';

export const requestParentChildLink = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated.');
  }

  const parentUid = context.auth.uid;
  const parentPhone = context.auth.token.phone_number;
  const { studentRollNumber, dateOfBirth, studentFullName } = data;

  if (!studentRollNumber || !dateOfBirth) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'studentRollNumber and dateOfBirth are required.'
    );
  }

  const db = admin.firestore();

  // Find student by rollNumber
  const studentQuery = await db
    .collection('students')
    .where('rollNumber', '==', studentRollNumber.trim().toUpperCase())
    .limit(1)
    .get();

  if (studentQuery.empty) {
    throw new functions.https.HttpsError('not-found', 'No student found with the provided roll number.');
  }

  const studentDoc = studentQuery.docs[0];
  const student = studentDoc.data();
  const studentId = studentDoc.id;

  // Validate Date of Birth
  if (student.dateOfBirth !== dateOfBirth.trim()) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'The provided verification details do not match institute records.'
    );
  }

  // Check if parent's verified phone number matches emergencyContact
  const phoneMatched =
    parentPhone &&
    student.emergencyContact &&
    (parentPhone.endsWith(student.emergencyContact.replace(/\D/g, '').slice(-10)) ||
      student.emergencyContact === parentPhone);

  if (phoneMatched) {
    // Automatic linking approved
    await db.runTransaction(async (transaction) => {
      // 1. Update Student
      const currentParentUids: string[] = student.parentUids || [];
      if (!currentParentUids.includes(parentUid)) {
        currentParentUids.push(parentUid);
        transaction.update(studentDoc.ref, {
          parentUids: currentParentUids,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      // 2. Update Parent
      const parentRef = db.collection('parents').doc(parentUid);
      const parentSnap = await transaction.get(parentRef);
      let linkedStudentIds: string[] = [];
      if (parentSnap.exists) {
        linkedStudentIds = parentSnap.data()?.linkedStudentIds || [];
      }
      if (!linkedStudentIds.includes(studentId)) {
        linkedStudentIds.push(studentId);
      }

      transaction.set(
        parentRef,
        {
          uid: parentUid,
          verifiedPhone: parentPhone || '',
          linkedStudentIds,
          accountStatus: 'active',
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        { merge: true }
      );

      // 3. Audit Log
      const auditRef = db.collection('audit_logs').doc();
      transaction.set(auditRef, {
        actorUid: parentUid,
        action: 'PARENT_CHILD_AUTO_LINKED',
        resource: `students/${studentId}`,
        details: { parentUid, studentId, studentRollNumber },
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    // Update parent's Custom Claims
    const currentClaims = (await admin.auth().getUser(parentUid)).customClaims || {};
    const updatedLinked = Array.from(
      new Set([...(currentClaims.linkedStudentIds || []), studentId])
    );
    await admin.auth().setCustomUserClaims(parentUid, {
      ...currentClaims,
      role: 'parent',
      linkedStudentIds: updatedLinked,
    });

    return {
      status: 'LINKED',
      studentId,
      studentName: student.fullName,
      message: 'Student account successfully linked.',
    };
  } else {
    // Phone didn't match pre-recorded emergency contact - submit for Admin Review
    const requestRef = db.collection('parent_link_requests').doc();
    await requestRef.set({
      requestId: requestRef.id,
      parentUid,
      parentPhone: parentPhone || '',
      studentId,
      studentRollNumber,
      studentFullName: studentFullName || student.fullName,
      status: 'PENDING_ADMIN_REVIEW',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      status: 'PENDING_REVIEW',
      requestId: requestRef.id,
      message:
        'Your link request has been submitted to the institute administration for manual verification.',
    };
  }
});

export const approveParentLinkRequest = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.role !== 'admin') {
    throw new functions.https.HttpsError('permission-denied', 'Only admins can approve link requests.');
  }

  const { requestId } = data;
  if (!requestId) {
    throw new functions.https.HttpsError('invalid-argument', 'requestId is required.');
  }

  const db = admin.firestore();
  const reqRef = db.collection('parent_link_requests').doc(requestId);
  const reqSnap = await reqRef.get();

  if (!reqSnap.exists) {
    throw new functions.https.HttpsError('not-found', 'Link request not found.');
  }

  const linkReq = reqSnap.data()!;
  if (linkReq.status !== 'PENDING_ADMIN_REVIEW') {
    throw new functions.https.HttpsError('failed-precondition', 'Request is not pending review.');
  }

  const { parentUid, studentId } = linkReq;

  await db.runTransaction(async (transaction) => {
    const studentRef = db.collection('students').doc(studentId);
    const studentSnap = await transaction.get(studentRef);
    if (!studentSnap.exists) throw new functions.https.HttpsError('not-found', 'Student not found.');

    const currentParents: string[] = studentSnap.data()?.parentUids || [];
    if (!currentParents.includes(parentUid)) {
      currentParents.push(parentUid);
      transaction.update(studentRef, {
        parentUids: currentParents,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    const parentRef = db.collection('parents').doc(parentUid);
    const parentSnap = await transaction.get(parentRef);
    const linkedStudentIds: string[] = parentSnap.exists ? parentSnap.data()?.linkedStudentIds || [] : [];
    if (!linkedStudentIds.includes(studentId)) {
      linkedStudentIds.push(studentId);
    }

    transaction.set(
      parentRef,
      {
        uid: parentUid,
        linkedStudentIds,
        accountStatus: 'active',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true }
    );

    transaction.update(reqRef, {
      status: 'APPROVED',
      approvedBy: context.auth!.uid,
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  return { success: true, message: 'Parent-child link approved.' };
});

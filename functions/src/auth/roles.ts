import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';

export type UserRole = 'admin' | 'teacher' | 'parent' | 'student';

export const assignUserRole = functions.https.onCall(async (data, context) => {
  // Authorization: Only existing admins can assign roles
  if (!context.auth || context.auth.token.role !== 'admin') {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Only authorized institute administrators can assign roles.'
    );
  }

  const { targetUid, role, linkedStudentIds } = data;
  if (!targetUid || !role) {
    throw new functions.https.HttpsError('invalid-argument', 'targetUid and role are required.');
  }

  const validRoles: UserRole[] = ['admin', 'teacher', 'parent', 'student'];
  if (!validRoles.includes(role)) {
    throw new functions.https.HttpsError('invalid-argument', `Invalid role: ${role}`);
  }

  const claims: Record<string, any> = {
    role,
    instituteId: 'radiance_amritsar',
  };

  if (role === 'parent' && Array.isArray(linkedStudentIds)) {
    claims.linkedStudentIds = linkedStudentIds;
  }

  // 1. Assign custom claims
  await admin.auth().setCustomUserClaims(targetUid, claims);

  // 2. Update user document in Firestore
  const db = admin.firestore();
  await db.collection('users').doc(targetUid).set(
    {
      role,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  // 3. Write immutable audit log
  await db.collection('audit_logs').add({
    actorUid: context.auth.uid,
    action: 'ROLE_MODIFIED',
    resource: `users/${targetUid}`,
    details: { targetUid, newRole: role, linkedStudentIds: linkedStudentIds || [] },
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
  });

  return { success: true, targetUid, assignedRole: role };
});

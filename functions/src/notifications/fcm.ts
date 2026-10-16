import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions/v1';

export const sendTargetedNotification = async (
  recipientUid: string,
  title: string,
  body: string,
  data?: Record<string, string>
) => {
  const db = admin.firestore();

  // 1. Persist notification in database
  await db.collection('notifications').add({
    recipientUid,
    title,
    body,
    data: data || {},
    read: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // 2. Fetch user's registered FCM device tokens
  const userDoc = await db.collection('users').doc(recipientUid).get();
  const fcmTokens: string[] = userDoc.data()?.fcmTokens || [];

  if (fcmTokens.length === 0) {
    return;
  }

  // 3. Dispatch to device tokens
  const message: admin.messaging.MulticastMessage = {
    tokens: fcmTokens,
    notification: {
      title,
      body,
    },
    data: data || {},
    android: {
      priority: 'high',
      notification: {
        color: '#2059A5', // Royal Blue
        channelId: 'radiance_primary_channel',
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
        },
      },
    },
  };

  try {
    await admin.messaging().sendEachForMulticast(message);
  } catch (error) {
    console.error(`Error sending FCM message to ${recipientUid}:`, error);
  }
};

/**
 * Trigger: On Result Published -> Notify Student and Linked Parents
 */
export const onResultPublished = functions.firestore
  .document('results/{resultId}')
  .onWrite(async (change, context) => {
    const afterData = change.after.exists ? change.after.data() : null;
    const beforeData = change.before.exists ? change.before.data() : null;

    if (!afterData) return;

    // Trigger only when publishedAt is set or changed
    if (afterData.publishedAt && (!beforeData || !beforeData.publishedAt)) {
      const db = admin.firestore();
      const studentId = afterData.studentId;

      // Find student and linked parents
      const studentDoc = await db.collection('students').doc(studentId).get();
      if (!studentDoc.exists) return;

      const student = studentDoc.data()!;
      const parents: string[] = student.parentUids || [];
      const title = `Academic Result Published: ${student.fullName}`;
      const body = `Marks obtained: ${afterData.marksObtained} (${afterData.percentage}%). Tap to view full report.`;

      // Notify student if user account is linked
      if (student.userUid) {
        await sendTargetedNotification(student.userUid, title, body, {
          route: '/results',
          resultId: context.params.resultId,
        });
      }

      // Notify all linked parents
      for (const parentUid of parents) {
        await sendTargetedNotification(parentUid, title, body, {
          route: '/parent/results',
          studentId,
          resultId: context.params.resultId,
        });
      }
    }
  });

/**
 * Trigger: On Attendance Marked as ABSENT -> Notify Parents Immediately
 */
export const onAttendanceMarked = functions.firestore
  .document('attendance/{attendanceId}')
  .onCreate(async (snap, context) => {
    const attendance = snap.data();
    if (attendance.status === 'ABSENT') {
      const db = admin.firestore();
      const studentDoc = await db.collection('students').doc(attendance.studentId).get();
      if (!studentDoc.exists) return;

      const student = studentDoc.data()!;
      const parents: string[] = student.parentUids || [];
      const title = `Absence Alert: ${student.fullName}`;
      const body = `${student.fullName} was marked absent for session on ${attendance.date}.`;

      for (const parentUid of parents) {
        await sendTargetedNotification(parentUid, title, body, {
          route: '/parent/attendance',
          studentId: attendance.studentId,
          date: attendance.date,
        });
      }
    }
  });

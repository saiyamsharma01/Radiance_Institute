import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp();
}

// Export Authentication & RBAC Functions
export { assignUserRole } from './auth/roles';
export { requestParentChildLink, approveParentLinkRequest } from './auth/parentLinking';

// Export Admissions Enquiry Functions
export { submitAdmissionEnquiry } from './admissions/enquiry';

// Export Razorpay Payments & Webhook Functions
export {
  createPaymentOrder,
  verifyPaymentSignature,
  handleRazorpayWebhook,
} from './payments/razorpay';

// Export Event Triggered Notification Functions
export { onResultPublished, onAttendanceMarked } from './notifications/fcm';

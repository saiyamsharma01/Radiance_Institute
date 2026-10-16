# Deployment & Operations Guide
## Radiance Institute — Cross-Platform Build, CI/CD & Production Setup

**Document Version:** 1.0.0  
**Target Environments:** Local Emulator Suite, Staging/Sandbox, Production  

---

## 1. Prerequisites & Tooling

* **Flutter SDK:** 3.41+ (Dart 3.11+)
* **Node.js:** v20.x or v22.x LTS (compatible with Firebase Functions Node 20/22 runtime)
* **Firebase CLI:** v13+ or v15+ (`npm install -g firebase-tools`)
* **Razorpay Merchant Sandbox Account:** API Key ID & Secret

---

## 2. Environment Configuration

### 2.1 Backend Functions (`functions/.env`)
Create `functions/.env` (do NOT commit secrets to Git):
```ini
# Firebase Project Config
PROJECT_ID=radiance-institute-prod

# Razorpay Sandbox / Production Gateway
RAZORPAY_KEY_ID=rzp_test_YourSandboxKeyHere
RAZORPAY_KEY_SECRET=YourRazorpaySecretHere
RAZORPAY_WEBHOOK_SECRET=YourWebhookSecretHere

# Institute Notifications
INSTITUTE_ADMIN_EMAIL=info@radianceinstitute.net
INSTITUTE_PHONE=+911835080005
```

### 2.2 Public Website (`apps/public_website/.env.local`)
```ini
NEXT_PUBLIC_SITE_URL=https://radianceinstitute.net
NEXT_PUBLIC_INSTITUTE_NAME="Radiance Institute"
NEXT_PUBLIC_INSTITUTE_TAGLINE="Committed to Quality Education"
NEXT_PUBLIC_INSTITUTE_PHONE="+91 183 508 0005"
NEXT_PUBLIC_INSTITUTE_EMAIL="info@radianceinstitute.net"
NEXT_PUBLIC_INSTITUTE_ADDRESS="85-A, Rani Ka Bagh, adjoining FCI Office, Amritsar, Punjab, India"

# Firebase Client SDK Configuration
NEXT_PUBLIC_FIREBASE_API_KEY="AIzaSyYourClientApiKey"
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN="radiance-institute.firebaseapp.com"
NEXT_PUBLIC_FIREBASE_PROJECT_ID="radiance-institute"
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET="radiance-institute.appspot.com"
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID="1234567890"
NEXT_PUBLIC_FIREBASE_APP_ID="1:1234567890:web:abcdef123456"
```

### 2.3 Flutter App (`apps/radiance_flutter/assets/config/app_config.json` or `.env`)
```json
{
  "apiBaseUrl": "https://us-central1-radiance-institute.cloudfunctions.net",
  "razorpayKeyId": "rzp_test_YourSandboxKeyHere",
  "enableEmulator": false,
  "institutePhone": "+91 183 508 0005",
  "instituteEmail": "info@radianceinstitute.net"
}
```

---

## 3. Local Development with Firebase Emulator Suite

1. **Install Firebase Emulators:**
   ```bash
   firebase setup:emulators:firestore
   firebase setup:emulators:storage
   firebase setup:emulators:functions
   firebase setup:emulators:auth
   ```

2. **Start Emulators:**
   ```bash
   firebase emulators:start --only auth,firestore,functions,storage
   ```

3. **Run Flutter App against Emulator:**
   ```bash
   cd apps/radiance_flutter
   flutter run -d chrome --dart-define=USE_EMULATOR=true
   ```

4. **Run Public Website against Local Backend:**
   ```bash
   cd apps/public_website
   npm run dev
   ```

---

## 4. Production Build & Deployment Commands

### 4.1 Firebase Rules, Indexes & Backend Functions
```bash
# Deploy Firestore security rules and composite indexes
firebase deploy --only firestore:rules,firestore:indexes

# Deploy Storage security rules
firebase deploy --only storage

# Deploy Cloud Functions
cd functions
npm run build
firebase deploy --only functions
```

### 4.2 Flutter Web Admin Dashboard Build
```bash
cd apps/radiance_flutter
flutter build web --release --web-renderer canvaskit
# The output in build/web can be hosted on Firebase Hosting:
firebase deploy --only hosting:admin
```

### 4.3 Flutter Android & iOS Native Builds
```bash
# Android App Bundle (AAB for Google Play Store)
flutter build appbundle --release

# Android APK for direct institute pilot testing
flutter build apk --release

# iOS Release Archive
flutter build ipa --release
```

### 4.4 Next.js Public Website Deployment
```bash
cd apps/public_website
npm run build
# Deploy to Vercel or Firebase App Hosting
```

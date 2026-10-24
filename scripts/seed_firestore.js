const fs = require('fs');
const path = require('path');
const https = require('https');

const PROJECT_ID = 'radiance-institute-amritsar';
const configPath = path.join(require('os').homedir(), '.config/configstore/firebase-tools.json');

if (!fs.existsSync(configPath)) {
  console.error('Firebase CLI configstore not found at:', configPath);
  process.exit(1);
}

const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
let accessToken = config.tokens?.access_token;
const refreshToken = config.tokens?.refresh_token;

function getFreshToken() {
  return new Promise((resolve, reject) => {
    if (!refreshToken) return resolve(accessToken);

    const postData = new URLSearchParams({
      client_id: '563584335869-fgrhgmd47bqnekij5i8b5pr03ho85qd6.apps.googleusercontent.com',
      client_secret: 'GOCSPX-Lq9g7T474F2922629631',
      grant_type: 'refresh_token',
      refresh_token: refreshToken
    }).toString();

    const req = https.request({
      hostname: 'oauth2.googleapis.com',
      path: '/token',
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(postData)
      }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          if (json.access_token) {
            resolve(json.access_token);
          } else {
            resolve(accessToken);
          }
        } catch (e) {
          resolve(accessToken);
        }
      });
    });

    req.on('error', () => resolve(accessToken));
    req.write(postData);
    req.end();
  });
}

function toFirestoreFields(obj) {
  const fields = {};
  for (const [key, value] of Object.entries(obj)) {
    if (value === null || value === undefined) {
      fields[key] = { nullValue: null };
    } else if (typeof value === 'string') {
      fields[key] = { stringValue: value };
    } else if (typeof value === 'number') {
      if (Number.isInteger(value)) {
        fields[key] = { integerValue: value.toString() };
      } else {
        fields[key] = { doubleValue: value };
      }
    } else if (typeof value === 'boolean') {
      fields[key] = { booleanValue: value };
    } else if (Array.isArray(value)) {
      fields[key] = {
        arrayValue: {
          values: value.map(v => {
            if (typeof v === 'string') return { stringValue: v };
            if (typeof v === 'number') return Number.isInteger(v) ? { integerValue: v.toString() } : { doubleValue: v };
            if (typeof v === 'object') return { mapValue: { fields: toFirestoreFields(v) } };
            return { stringValue: String(v) };
          })
        }
      };
    } else if (typeof value === 'object') {
      fields[key] = { mapValue: { fields: toFirestoreFields(value) } };
    }
  }
  return fields;
}

function writeFirestoreDoc(token, collection, docId, data) {
  return new Promise((resolve, reject) => {
    const postBody = JSON.stringify({
      fields: toFirestoreFields(data)
    });

    const endpoint = `/v1/projects/${PROJECT_ID}/databases/(default)/documents/${collection}/${docId}`;

    const req = https.request({
      hostname: 'firestore.googleapis.com',
      path: endpoint,
      method: 'PATCH',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(postBody)
      }
    }, (res) => {
      let body = '';
      res.on('data', chunk => body += chunk);
      res.on('end', () => {
        if (res.statusCode >= 200 && res.statusCode < 300) {
          console.log(`✔ [${collection}] -> ${docId} created`);
          resolve(JSON.parse(body));
        } else {
          console.error(`✖ Error writing [${collection}/${docId}]: ${res.statusCode} ${body}`);
          reject(new Error(body));
        }
      });
    });

    req.on('error', reject);
    req.write(postBody);
    req.end();
  });
}

const seedData = {
  users: [
    {
      id: 'usr_admin_1',
      displayName: 'Institute Administration',
      role: 'admin',
      phoneNumber: '+911835080005',
      email: 'admin@radianceinstitute.net',
      createdAt: new Date().toISOString()
    },
    {
      id: 'usr_teacher_phys',
      displayName: 'Er. Bedi Sir',
      role: 'teacher',
      phoneNumber: '+919876543210',
      email: 'physics@radianceinstitute.net',
      createdAt: new Date().toISOString()
    },
    {
      id: 'usr_teacher_chem',
      displayName: 'Faculty - Chemistry Dept',
      role: 'teacher',
      phoneNumber: '+919876543211',
      email: 'chemistry@radianceinstitute.net',
      createdAt: new Date().toISOString()
    },
    {
      id: 'usr_parent_1',
      displayName: 'Gurpreet Singh',
      role: 'parent',
      phoneNumber: '+919814012345',
      email: 'gurpreet.parent@radianceinstitute.net',
      createdAt: new Date().toISOString()
    },
    {
      id: 'usr_student_1',
      displayName: 'Aarav Sharma',
      role: 'student',
      phoneNumber: '+919814012345',
      email: 'aarav.student@radianceinstitute.net',
      createdAt: new Date().toISOString()
    }
  ],
  students: [
    {
      id: 'RAD-2026-0042',
      studentId: 'RAD-2026-0042',
      userUid: 'usr_student_1',
      fullName: 'Aarav Sharma',
      classLevel: '11',
      academicYear: '2026-2027',
      rollNumber: 'RAD11-042',
      parentPhone: '+919814012345',
      batchIds: ['BATCH-11-PHYS-A', 'BATCH-11-CHEM-A'],
      stream: 'Non-Medical (PCM)',
      enrolledAt: '2026-04-01T09:00:00Z'
    }
  ],
  teachers: [
    {
      id: 'TEA-2026-0001',
      userUid: 'usr_teacher_phys',
      fullName: 'Er. Bedi Sir',
      designation: 'Lead Faculty & HOD Physics',
      department: 'Physics',
      qualification: 'B.Tech, 26+ Years Pedagogy Excellence',
      subjects: ['Physics (Class 11)', 'Physics (Class 12)', 'Physics JEE/NEET']
    },
    {
      id: 'TEA-2026-0002',
      userUid: 'usr_teacher_chem',
      fullName: 'Dr. Raman Kumar',
      designation: 'Senior Faculty Chemistry',
      department: 'Chemistry',
      qualification: 'M.Sc, Ph.D. Chemistry',
      subjects: ['Chemistry (Class 11)', 'Chemistry (Class 12)']
    }
  ],
  batches: [
    {
      id: 'BATCH-11-PHYS-A',
      name: 'Class 11 - Physics Foundation & Numerical Mastery',
      subject: 'Physics',
      classLevel: '11',
      teacherUid: 'usr_teacher_phys',
      teacherName: 'Er. Bedi Sir',
      schedule: 'Mon, Wed, Fri 04:30 PM - 06:00 PM',
      room: 'Room 101 (Amritsar Campus)',
      totalSeats: 35,
      enrolledCount: 28
    },
    {
      id: 'BATCH-12-PHYS-A',
      name: 'Class 12 - Senior Secondary & Board Mastery',
      subject: 'Physics',
      classLevel: '12',
      teacherUid: 'usr_teacher_phys',
      teacherName: 'Er. Bedi Sir',
      schedule: 'Tue, Thu, Sat 05:00 PM - 06:30 PM',
      room: 'Lecture Hall A',
      totalSeats: 40,
      enrolledCount: 36
    },
    {
      id: 'BATCH-10-SCI-A',
      name: 'Class 10 - Comprehensive Science & Maths',
      subject: 'Science',
      classLevel: '10',
      teacherUid: 'usr_teacher_chem',
      teacherName: 'Dr. Raman Kumar',
      schedule: 'Daily 03:30 PM - 04:45 PM',
      room: 'Room 203',
      totalSeats: 30,
      enrolledCount: 24
    }
  ],
  fee_invoices: [
    {
      id: 'INV-2026-001',
      invoiceNumber: 'INV-2026-001',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      title: 'Q1 Academic Tuition & Practical Lab Fee',
      amountPaise: 1800000,
      paidAmountPaise: 1800000,
      balanceDuePaise: 0,
      status: 'PAID',
      dueDate: '2026-04-10',
      paidAt: '2026-04-05T14:30:00Z',
      receiptNumber: 'RCPT-2026-0042'
    },
    {
      id: 'INV-2026-002',
      invoiceNumber: 'INV-2026-002',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      title: 'Q2 Academic Tuition Fee (Upcoming)',
      amountPaise: 1800000,
      paidAmountPaise: 0,
      balanceDuePaise: 1800000,
      status: 'PENDING',
      dueDate: '2026-07-10',
      paidAt: ''
    }
  ],
  admission_enquiries: [
    {
      id: 'ENQ-2026-0089',
      studentName: 'Simranpreet Kaur',
      classLevel: 'Class 11',
      subjects: ['Physics (Er. Bedi Sir)', 'Chemistry', 'Mathematics'],
      parentName: 'Harjeet Singh',
      contactPhone: '+919815099881',
      status: 'NEW',
      notes: 'Interested in offline classroom batch at Rani Ka Bagh campus',
      createdAt: '2026-10-24T11:00:00Z'
    }
  ],
  attendance: [
    {
      id: 'ATT-2026-10-24-001',
      batchId: 'BATCH-11-PHYS-A',
      studentId: 'RAD-2026-0042',
      date: '2026-10-24',
      status: 'PRESENT',
      markedByUid: 'usr_teacher_phys',
      markedAt: '2026-10-24T16:45:00Z'
    }
  ],
  homework: [
    {
      id: 'HW-2026-101',
      batchId: 'BATCH-11-PHYS-A',
      title: 'Rotational Dynamics & Moment of Inertia DPP-04',
      description: 'Solve Questions 1 through 25 from Chapter 7 Practice Module.',
      dueDate: '2026-10-26T23:59:00Z',
      teacherUid: 'usr_teacher_phys',
      assignedDate: '2026-10-24'
    }
  ],
  tests: [
    {
      id: 'TEST-2026-101',
      batchId: 'BATCH-11-PHYS-A',
      title: 'Electrostatics & Capacitance Unit Test',
      date: '2026-10-20',
      maxMarks: 50,
      published: true
    }
  ],
  results: [
    {
      id: 'RES-2026-101',
      testId: 'TEST-2026-101',
      studentId: 'RAD-2026-0042',
      studentName: 'Aarav Sharma',
      marksObtained: 48,
      maxMarks: 50,
      percentage: 96.0,
      rank: 1,
      remarks: 'Excellent analytical grasp on Gauss Law'
    }
  ]
};

async function runSeed() {
  console.log(`Connecting to Cloud Firestore on project: ${PROJECT_ID}...`);
  const token = await getFreshToken();

  for (const [collection, items] of Object.entries(seedData)) {
    console.log(`\n--- Seeding collection: ${collection} (${items.length} records) ---`);
    for (const item of items) {
      const docId = item.id;
      const data = { ...item };
      delete data.id;
      await writeFirestoreDoc(token, collection, docId, data);
    }
  }

  console.log('\n🎉 ALL INITIAL FIRESTORE COLLECTIONS SEEDED SUCCESSFULLY!');
}

runSeed().catch(err => {
  console.error('Seed script error:', err);
  process.exit(1);
});

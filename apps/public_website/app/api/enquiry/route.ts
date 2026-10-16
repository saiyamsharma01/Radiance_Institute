import { NextResponse } from "next/server";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const {
      studentName,
      guardianName,
      contactNumber,
      classLevel,
      academicYear,
      subjectIds,
      preferredCallbackTime,
      message,
    } = body;

    // 1. Validate required fields
    if (!studentName?.trim() || !guardianName?.trim() || !contactNumber?.trim() || !classLevel) {
      return NextResponse.json(
        { error: "Student name, guardian name, contact number, and class level are required." },
        { status: 400 }
      );
    }

    // 2. Validate phone number (10-digit Indian phone)
    const cleanedPhone = contactNumber.replace(/\D/g, "").slice(-10);
    if (!/^[6-9]\d{9}$/.test(cleanedPhone)) {
      return NextResponse.json(
        { error: "Please provide a valid 10-digit Indian mobile number." },
        { status: 400 }
      );
    }

    // 3. Generate reference ID
    const year = new Date().getFullYear();
    const randomSeq = Math.floor(1000 + Math.random() * 9000);
    const enquiryReference = `ENQ-${year}-${randomSeq}`;

    // 4. Return success response (In production, writes to Firestore or Cloud Functions)
    return NextResponse.json({
      success: true,
      enquiryReference,
      message:
        "Thank you! Your admission enquiry has been recorded. Our academic team at Rani Ka Bagh will contact you shortly.",
    });
  } catch (error: any) {
    return NextResponse.json(
      { error: "Internal server error while processing admission enquiry." },
      { status: 500 }
    );
  }
}

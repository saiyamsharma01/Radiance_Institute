import * as crypto from 'crypto';

export class CryptoUtils {
  /**
   * Verifies Razorpay HMAC-SHA256 signature for webhooks or checkout returns.
   */
  static verifyRazorpaySignature(
    payload: string,
    signature: string,
    secret: string
  ): boolean {
    if (!payload || !signature || !secret) {
      return false;
    }
    const expectedSignature = crypto
      .createHmac('sha256', secret)
      .update(payload)
      .digest('hex');

    try {
      return crypto.timingSafeEqual(
        Buffer.from(expectedSignature, 'utf8'),
        Buffer.from(signature, 'utf8')
      );
    } catch {
      return false;
    }
  }

  /**
   * Generates a cryptographically random linking challenge token.
   */
  static generateSecureToken(length: number = 32): string {
    return crypto.randomBytes(length).toString('hex');
  }

  /**
   * Hashes a verification string (e.g., student DOB + roll number + secret).
   */
  static hashVerificationChallenge(input: string, salt: string): string {
    return crypto
      .createHash('sha256')
      .update(`${input}:${salt}`)
      .digest('hex');
  }
}

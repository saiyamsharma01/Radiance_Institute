import { MinorUnits } from '../src/utils/minorUnits';
import { CryptoUtils } from '../src/utils/crypto';
import * as crypto from 'crypto';

describe('Financial Integer Minor Units (Paise) Calculations', () => {
  test('fromRupees converts standard currency to integer paise correctly', () => {
    expect(MinorUnits.fromRupees(1500)).toBe(150000);
    expect(MinorUnits.fromRupees(3500.50)).toBe(350050);
    expect(MinorUnits.fromRupees(0.99)).toBe(99);
    expect(MinorUnits.fromRupees(0)).toBe(0);
  });

  test('formatINR formats integer paise into Indian currency format', () => {
    expect(MinorUnits.formatINR(150000)).toBe('₹1,500.00');
    expect(MinorUnits.formatINR(350050)).toBe('₹3,500.50');
    expect(MinorUnits.formatINR(10000000)).toBe('₹1,00,000.00'); // 1 Lakh INR
    expect(MinorUnits.formatINR(50)).toBe('₹0.50');
  });

  test('add and subtract execute precise integer arithmetic without precision loss', () => {
    const subtotal = 450000; // ₹4,500
    const payment = 200000;  // ₹2,000
    const remaining = MinorUnits.subtract(subtotal, payment);
    expect(remaining).toBe(250000); // ₹2,500

    const total = MinorUnits.add(remaining, 50000);
    expect(total).toBe(300000); // ₹3,000
  });

  test('applyDiscount caps discount at subtotal and returns integer values', () => {
    const subtotal = 500000; // ₹5,000
    const discount = 100000; // ₹1,000
    const result = MinorUnits.applyDiscount(subtotal, discount);

    expect(result.discountAppliedPaise).toBe(100000);
    expect(result.amountDuePaise).toBe(400000); // ₹4,000
  });

  test('applyDiscount handles excess discount without negative balance', () => {
    const subtotal = 200000; // ₹2,000
    const excessDiscount = 300000; // ₹3,000
    const result = MinorUnits.applyDiscount(subtotal, excessDiscount);

    expect(result.discountAppliedPaise).toBe(200000);
    expect(result.amountDuePaise).toBe(0);
  });

  test('throws error when non-integer minor unit is supplied', () => {
    expect(() => MinorUnits.formatINR(1500.5)).toThrow();
    expect(() => MinorUnits.add(100.2, 200)).toThrow();
  });
});

describe('Cryptographic Signature & Security Verification', () => {
  const secret = 'rzp_test_secret_1234567890';
  const orderId = 'order_EKwxwAgIt4nlq6';
  const paymentId = 'pay_29QQoUBi66xm2f';
  const payload = `${orderId}|${paymentId}`;

  // Generate authentic HMAC-SHA256 signature
  const validSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');

  test('valid signature is successfully verified', () => {
    const isValid = CryptoUtils.verifyRazorpaySignature(payload, validSignature, secret);
    expect(isValid).toBe(true);
  });

  test('tampered payload fails signature verification', () => {
    const tamperedPayload = `${orderId}|pay_tampered_attacker_id`;
    const isValid = CryptoUtils.verifyRazorpaySignature(tamperedPayload, validSignature, secret);
    expect(isValid).toBe(false);
  });

  test('incorrect secret fails signature verification', () => {
    const wrongSecret = 'wrong_secret_key';
    const isValid = CryptoUtils.verifyRazorpaySignature(payload, validSignature, wrongSecret);
    expect(isValid).toBe(false);
  });

  test('random tokens generated have correct length and uniqueness', () => {
    const token1 = CryptoUtils.generateSecureToken(16);
    const token2 = CryptoUtils.generateSecureToken(16);
    expect(token1.length).toBe(32); // 16 bytes = 32 hex chars
    expect(token2.length).toBe(32);
    expect(token1).not.toBe(token2);
  });
});

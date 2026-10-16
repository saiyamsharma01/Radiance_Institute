/**
 * Utility functions for precise financial calculations using integer minor units (Paise for INR).
 * 1 INR = 100 Paise.
 * Floating point arithmetic is strictly forbidden in financial paths.
 */

export class MinorUnits {
  /**
   * Converts Rupee decimal (e.g., 1500.50) to integer paise (150050).
   */
  static fromRupees(rupees: number): number {
    if (isNaN(rupees) || !isFinite(rupees)) {
      throw new Error('Invalid rupee amount provided.');
    }
    return Math.round(rupees * 100);
  }

  /**
   * Formats integer paise (e.g., 150050) into standard Indian Currency string: "₹1,500.50".
   */
  static formatINR(paise: number): string {
    if (!Number.isInteger(paise)) {
      throw new Error('Amount must be an integer in minor units (paise).');
    }
    const rupees = (paise / 100).toFixed(2);
    const parts = rupees.split('.');
    let integerPart = parts[0];
    const decimalPart = parts[1];

    // Format according to Indian Numbering System (e.g., 1,00,000)
    const lastThree = integerPart.substring(integerPart.length - 3);
    const otherNumbers = integerPart.substring(0, integerPart.length - 3);
    if (otherNumbers !== '') {
      integerPart = otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ',') + ',' + lastThree;
    } else {
      integerPart = lastThree;
    }

    return `₹${integerPart}.${decimalPart}`;
  }

  /**
   * Safely adds integer amounts.
   */
  static add(aPaise: number, bPaise: number): number {
    this.assertInteger(aPaise, 'a');
    this.assertInteger(bPaise, 'b');
    return aPaise + bPaise;
  }

  /**
   * Safely subtracts integer amounts, with optional lower bound check.
   */
  static subtract(aPaise: number, bPaise: number, allowNegative: boolean = false): number {
    this.assertInteger(aPaise, 'a');
    this.assertInteger(bPaise, 'b');
    const result = aPaise - bPaise;
    if (!allowNegative && result < 0) {
      return 0;
    }
    return result;
  }

  /**
   * Applies an authorized discount percentage or fixed amount in paise.
   */
  static applyDiscount(subtotalPaise: number, discountPaise: number): {
    amountDuePaise: number;
    discountAppliedPaise: number;
  } {
    this.assertInteger(subtotalPaise, 'subtotal');
    this.assertInteger(discountPaise, 'discount');
    if (discountPaise < 0) throw new Error('Discount cannot be negative.');

    const discountApplied = Math.min(subtotalPaise, discountPaise);
    const amountDue = subtotalPaise - discountApplied;
    return {
      amountDuePaise: amountDue,
      discountAppliedPaise: discountApplied,
    };
  }

  private static assertInteger(val: number, name: string): void {
    if (!Number.isInteger(val)) {
      throw new Error(`Financial value ${name} must be an integer, received: ${val}`);
    }
  }
}

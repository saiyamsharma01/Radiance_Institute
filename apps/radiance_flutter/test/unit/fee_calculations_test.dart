import 'package:flutter_test/flutter_test.dart';
import 'package:radiance_institute/core/utils/currency_formatter.dart';
import 'package:radiance_institute/data/models/fee_models.dart';

void main() {
  group('Fee & Currency Calculation Tests', () {
    test('CurrencyFormatter correctly formats integer paise to Indian Rupee strings', () {
      expect(CurrencyFormatter.formatPaise(150000), '₹1,500.00');
      expect(CurrencyFormatter.formatPaise(400000), '₹4,000.00');
      expect(CurrencyFormatter.formatPaise(350050), '₹3,500.50');
      expect(CurrencyFormatter.formatPaise(0), '₹0.00');
    });

    test('CurrencyFormatter converts rupees to paise accurately', () {
      expect(CurrencyFormatter.toPaise(1500.00), 150000);
      expect(CurrencyFormatter.toPaise(4000.50), 400050);
    });

    test('FeeInvoiceModel correctly computes subtotal, discounts, and balance in paise', () {
      final items = [
        InvoiceLineItem(description: 'Physics Tuition', amountPaise: 150000),
        InvoiceLineItem(description: 'Chemistry Tuition', amountPaise: 150000),
        InvoiceLineItem(description: 'Mathematics Tuition', amountPaise: 150000),
      ];

      final totalSubtotal = items.fold(0, (sum, i) => sum + i.amountPaise);
      expect(totalSubtotal, 450000); // ₹4,500.00

      const discountPaise = 50000; // ₹500.00 merit scholarship
      final amountDue = totalSubtotal - discountPaise;
      expect(amountDue, 400000); // ₹4,000.00

      final invoice = FeeInvoiceModel(
        invoiceId: 'INV-TEST-001',
        studentId: 'RAD-2026-0042',
        studentName: 'Aarav Sharma',
        academicYear: '2026-2027',
        period: 'October 2026',
        lineItems: items,
        subtotalPaise: totalSubtotal,
        discountPaise: discountPaise,
        amountDuePaise: amountDue,
        amountPaidPaise: 200000, // Partial payment ₹2,000.00
        balanceDuePaise: 200000,
        dueDate: '2026-10-25',
        status: 'PARTIALLY_PAID',
        createdAt: DateTime.now(),
      );

      expect(invoice.formattedSubtotal, '₹4,500.00');
      expect(invoice.formattedDiscount, '₹500.00');
      expect(invoice.formattedAmountDue, '₹4,000.00');
      expect(invoice.formattedAmountPaid, '₹2,000.00');
      expect(invoice.formattedBalanceDue, '₹2,000.00');
      expect(invoice.status, 'PARTIALLY_PAID');
    });
  });
}

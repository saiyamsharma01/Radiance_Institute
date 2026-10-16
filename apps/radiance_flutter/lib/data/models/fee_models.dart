import '../../core/utils/currency_formatter.dart';

class InvoiceLineItem {
  final String description;
  final String? subject;
  final int amountPaise; // Integer minor units (e.g. 150000 = ₹1500.00)

  InvoiceLineItem({
    required this.description,
    this.subject,
    required this.amountPaise,
  });

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) {
    return InvoiceLineItem(
      description: json['description'] ?? '',
      subject: json['subject'],
      amountPaise: json['amountPaise'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'subject': subject,
      'amountPaise': amountPaise,
    };
  }

  String get formattedAmount => CurrencyFormatter.formatPaise(amountPaise);
}

class FeeInvoiceModel {
  final String invoiceId; // e.g. "INV-2026-0089"
  final String studentId;
  final String studentName;
  final String academicYear;
  final String period; // "October 2026"
  final List<InvoiceLineItem> lineItems;
  final int subtotalPaise;
  final int discountPaise;
  final int amountDuePaise;
  final int amountPaidPaise;
  final int balanceDuePaise;
  final String dueDate; // "YYYY-MM-DD"
  final String status; // 'DRAFT' | 'ISSUED' | 'PARTIALLY_PAID' | 'PAID' | 'OVERDUE'
  final DateTime createdAt;

  FeeInvoiceModel({
    required this.invoiceId,
    required this.studentId,
    required this.studentName,
    required this.academicYear,
    required this.period,
    required this.lineItems,
    required this.subtotalPaise,
    this.discountPaise = 0,
    required this.amountDuePaise,
    this.amountPaidPaise = 0,
    required this.balanceDuePaise,
    required this.dueDate,
    this.status = 'ISSUED',
    required this.createdAt,
  });

  factory FeeInvoiceModel.fromJson(Map<String, dynamic> json) {
    final subtotal = json['subtotalPaise'] ?? 0;
    final discount = json['discountPaise'] ?? 0;
    final amountDue = json['amountDuePaise'] ?? (subtotal - discount);
    final amountPaid = json['amountPaidPaise'] ?? 0;
    final balance = json['balanceDuePaise'] ?? (amountDue - amountPaid);

    return FeeInvoiceModel(
      invoiceId: json['invoiceId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      academicYear: json['academicYear'] ?? '2026-2027',
      period: json['period'] ?? '',
      lineItems: (json['lineItems'] as List<dynamic>? ?? [])
          .map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotalPaise: subtotal,
      discountPaise: discount,
      amountDuePaise: amountDue,
      amountPaidPaise: amountPaid,
      balanceDuePaise: balance,
      dueDate: json['dueDate'] ?? '',
      status: json['status'] ?? 'ISSUED',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceId': invoiceId,
      'studentId': studentId,
      'studentName': studentName,
      'academicYear': academicYear,
      'period': period,
      'lineItems': lineItems.map((e) => e.toJson()).toList(),
      'subtotalPaise': subtotalPaise,
      'discountPaise': discountPaise,
      'amountDuePaise': amountDuePaise,
      'amountPaidPaise': amountPaidPaise,
      'balanceDuePaise': balanceDuePaise,
      'dueDate': dueDate,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedSubtotal => CurrencyFormatter.formatPaise(subtotalPaise);
  String get formattedDiscount => CurrencyFormatter.formatPaise(discountPaise);
  String get formattedAmountDue => CurrencyFormatter.formatPaise(amountDuePaise);
  String get formattedAmountPaid => CurrencyFormatter.formatPaise(amountPaidPaise);
  String get formattedBalanceDue => CurrencyFormatter.formatPaise(balanceDuePaise);
}

class PaymentReceiptModel {
  final String receiptId; // e.g. "RAD-REC-2026-1042"
  final String invoiceId;
  final String studentId;
  final String studentName;
  final String gatewayPaymentId;
  final int amountPaise;
  final String period;
  final DateTime issuedAt;

  PaymentReceiptModel({
    required this.receiptId,
    required this.invoiceId,
    required this.studentId,
    required this.studentName,
    required this.gatewayPaymentId,
    required this.amountPaise,
    required this.period,
    required this.issuedAt,
  });

  factory PaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    return PaymentReceiptModel(
      receiptId: json['receiptId'] ?? '',
      invoiceId: json['invoiceId'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'] ?? '',
      gatewayPaymentId: json['gatewayPaymentId'] ?? '',
      amountPaise: json['amountPaise'] ?? 0,
      period: json['period'] ?? '',
      issuedAt: json['issuedAt'] != null
          ? DateTime.parse(json['issuedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiptId': receiptId,
      'invoiceId': invoiceId,
      'studentId': studentId,
      'studentName': studentName,
      'gatewayPaymentId': gatewayPaymentId,
      'amountPaise': amountPaise,
      'period': period,
      'issuedAt': issuedAt.toIso8601String(),
    };
  }

  String get formattedAmount => CurrencyFormatter.formatPaise(amountPaise);
}

import 'package:intl/intl.dart';

/// Formatter for financial amounts stored as integer paise.
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Converts paise (e.g. 150000) to Indian Rupee string: "₹1,500.00".
  static String formatPaise(int paise) {
    final double rupees = paise / 100.0;
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(rupees);
  }

  /// Converts rupees to paise.
  static int toPaise(double rupees) {
    return (rupees * 100).round();
  }
}

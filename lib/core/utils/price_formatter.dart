import 'package:intl/intl.dart';

/// Price Formatter Utility
/// Formats prices as Canadian Dollar (CAD) currency
class PriceFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.simpleCurrency(
    locale: 'en_CA',
    name: 'CAD',
  );

  /// Format price as CAD currency string
  /// Example: formatPriceCAD(25.50) returns "CA\$25.50"
  static String formatPriceCAD(double value) {
    return _currencyFormat.format(value);
  }

  /// Format price without currency symbol (for display flexibility)
  /// Example: formatPrice(25.50) returns "25.50"
  static String formatPrice(double value) {
    return value.toStringAsFixed(2);
  }
}

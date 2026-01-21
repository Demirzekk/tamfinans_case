import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _rateFormat = NumberFormat('#,##0.0000', 'tr_TR');
  static final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'tr_TR');
  static final NumberFormat _compactFormat = NumberFormat.compact(
    locale: 'tr_TR',
  );

  static String formatRate(double rate) {
    return _rateFormat.format(rate);
  }

  static String formatAmount(double amount) {
    return _amountFormat.format(amount);
  }

  static String formatTlAmount(double amount) {
    return '₺${_amountFormat.format(amount)}';
  }

  static String formatCurrencyAmount(double amount, String currencyCode) {
    final symbol = _currencySymbols[currencyCode] ?? currencyCode;
    return '$symbol${_amountFormat.format(amount)}';
  }

  static String formatCompact(double amount) {
    return _compactFormat.format(amount);
  }

  static double? parseAmount(String value) {
    try {
      final normalized = value.replaceAll('.', '').replaceAll(',', '.');
      return double.tryParse(normalized);
    } catch (_) {
      return null;
    }
  }

  static const Map<String, String> _currencySymbols = {
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'CHF': '₣',
    'TRY': '₺',
    'CAD': 'C\$',
    'AUD': 'A\$',
  };
}

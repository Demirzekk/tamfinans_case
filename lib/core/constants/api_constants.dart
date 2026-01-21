/// TCMB API sabitleri
class ApiConstants {
  ApiConstants._();

  static const String tcmbBaseUrl = 'https://www.tcmb.gov.tr/kurlar';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// URL Format: https://www.tcmb.gov.tr/kurlar/YYYYMM/DDMMYYYY.xml
  static String getExchangeRateUrl(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$tcmbBaseUrl/$year$month/$day$month$year.xml';
  }

  static String get todayExchangeRateUrl => getExchangeRateUrl(DateTime.now());

  static const List<String> primaryCurrencies = [
    'EUR',
    'GBP',
    'JPY',
    'CHF',
    'USD',
    'CAD',
    'AUD',
  ];
}

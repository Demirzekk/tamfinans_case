import '../../domain/entities/currency.dart';
import '../../domain/repositories/currency_repository.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;
import '../datasources/tcmb_remote_datasource.dart';

class ExchangeRatesResult {
  final List<Currency> currencies;
  final DateTime actualDate;
  final bool isFromFallback;
  final String? infoMessage;

  ExchangeRatesResult({
    required this.currencies,
    required this.actualDate,
    this.isFromFallback = false,
    this.infoMessage,
  });
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  final TcmbRemoteDatasource _remoteDatasource;

  CurrencyRepositoryImpl({required TcmbRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  @override
  Future<List<Currency>> getExchangeRates(DateTime date) async {
    final result = await getExchangeRatesWithInfo(date);
    return result.currencies;
  }

  Future<ExchangeRatesResult> getExchangeRatesWithInfo(DateTime date) async {
    if (!app_date_utils.DateUtils.isWeekday(date)) {
      final businessDay = app_date_utils.DateUtils.findLastBusinessDay(date);
      return _fetchWithFallback(
        businessDay,
        infoMessage:
            'Hafta sonu veri yayınlanmaz. ${_formatDate(businessDay)} tarihi gösteriliyor.',
      );
    }

    return _fetchWithFallback(date);
  }

  Future<ExchangeRatesResult> _fetchWithFallback(
    DateTime date, {
    String? infoMessage,
  }) async {
    try {
      final models = await _remoteDatasource.getExchangeRates(date);
      return ExchangeRatesResult(
        currencies: models.map((model) => model.toEntity()).toList(),
        actualDate: date,
        isFromFallback: infoMessage != null,
        infoMessage: infoMessage,
      );
    } on NotFoundException {
      return _tryPreviousDates(date);
    }
  }

  Future<ExchangeRatesResult> _tryPreviousDates(DateTime startDate) async {
    for (int i = 1; i <= 7; i++) {
      final previousDate = startDate.subtract(Duration(days: i));

      if (!app_date_utils.DateUtils.isWeekday(previousDate)) {
        continue;
      }

      try {
        final models = await _remoteDatasource.getExchangeRates(previousDate);
        return ExchangeRatesResult(
          currencies: models.map((model) => model.toEntity()).toList(),
          actualDate: previousDate,
          isFromFallback: true,
          infoMessage:
              'Seçilen tarihte veri bulunamadı. ${_formatDate(previousDate)} tarihi gösteriliyor.',
        );
      } on NotFoundException {
        continue;
      }
    }

    try {
      final fallbackDate = DateTime(2026, 1, 01);
      final models = await _remoteDatasource.getExchangeRates(fallbackDate);
      return ExchangeRatesResult(
        currencies: models.map((model) => model.toEntity()).toList(),
        actualDate: fallbackDate,
        isFromFallback: true,
        infoMessage: 'Demo verisi gösteriliyor (17 Ocak 2026).',
      );
    } catch (_) {
      throw const NotFoundException(
        message:
            'Döviz kuru verisi bulunamadı. Lütfen internet bağlantınızı kontrol edin.',
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  Future<List<Currency>> getTodayRates() => getExchangeRates(DateTime.now());
}

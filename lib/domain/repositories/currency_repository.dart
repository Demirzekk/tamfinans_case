import '../entities/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getExchangeRates(DateTime date);

  Future<List<Currency>> getTodayRates();
}

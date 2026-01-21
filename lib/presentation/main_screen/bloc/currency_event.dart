import 'package:flutter/foundation.dart';

@immutable
sealed class CurrencyEvent {
  const CurrencyEvent();
}

class LoadExchangeRates extends CurrencyEvent {
  final DateTime date;

  const LoadExchangeRates({required this.date});
}

class UpdateTlAmount extends CurrencyEvent {
  final double? amount;

  const UpdateTlAmount({required this.amount});
}

class ChangeDate extends CurrencyEvent {
  final DateTime date;

  const ChangeDate({required this.date});
}

class RefreshRates extends CurrencyEvent {
  const RefreshRates();
}

class SearchCurrencies extends CurrencyEvent {
  final String query;

  const SearchCurrencies({required this.query});
}

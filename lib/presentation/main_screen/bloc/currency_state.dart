import 'package:flutter/foundation.dart';

import '../../../../domain/entities/currency.dart';

@immutable
sealed class CurrencyState {
  final DateTime selectedDate;
  final double? tlAmount;

  const CurrencyState({required this.selectedDate, this.tlAmount});
}

class CurrencyInitial extends CurrencyState {
  CurrencyInitial() : super(selectedDate: DateTime.now());
}

class CurrencyLoading extends CurrencyState {
  const CurrencyLoading({required super.selectedDate, super.tlAmount});
}

class CurrencyLoaded extends CurrencyState {
  final List<Currency> currencies;
  final DateTime lastUpdate;

  final String searchQuery;

  const CurrencyLoaded({
    required this.currencies,
    required this.lastUpdate,
    required super.selectedDate,
    super.tlAmount,
    this.searchQuery = '',
  });

  List<Currency> get filteredCurrencies {
    if (searchQuery.isEmpty) return currencies;
    final query = searchQuery.toLowerCase();
    return currencies.where((c) {
      return c.code?.toLowerCase().contains(query) == true ||
          c.name?.toLowerCase().contains(query) == true ||
          c.nameEnglish?.toLowerCase().contains(query) == true;
    }).toList();
  }

  CurrencyLoaded copyWith({
    List<Currency>? currencies,
    DateTime? lastUpdate,
    DateTime? selectedDate,
    double? tlAmount,
    String? searchQuery,
  }) {
    return CurrencyLoaded(
      currencies: currencies ?? this.currencies,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      selectedDate: selectedDate ?? this.selectedDate,
      tlAmount: tlAmount ?? this.tlAmount,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CurrencyError extends CurrencyState {
  final String message;
  final List<Currency>? previousCurrencies;

  const CurrencyError({
    required this.message,
    required super.selectedDate,
    super.tlAmount,
    this.previousCurrencies,
  });
}

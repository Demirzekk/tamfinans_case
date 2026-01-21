// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CurrencyStore on CurrencyStoreBase, Store {
  Computed<bool>? _$hasErrorComputed;

  @override
  bool get hasError => (_$hasErrorComputed ??= Computed<bool>(
    () => super.hasError,
    name: 'CurrencyStoreBase.hasError',
  )).value;
  Computed<bool>? _$hasDataComputed;

  @override
  bool get hasData => (_$hasDataComputed ??= Computed<bool>(
    () => super.hasData,
    name: 'CurrencyStoreBase.hasData',
  )).value;
  Computed<List<Currency>>? _$filteredCurrenciesComputed;

  @override
  List<Currency> get filteredCurrencies =>
      (_$filteredCurrenciesComputed ??= Computed<List<Currency>>(
        () => super.filteredCurrencies,
        name: 'CurrencyStoreBase.filteredCurrencies',
      )).value;

  late final _$currenciesAtom = Atom(
    name: 'CurrencyStoreBase.currencies',
    context: context,
  );

  @override
  ObservableList<Currency> get currencies {
    _$currenciesAtom.reportRead();
    return super.currencies;
  }

  @override
  set currencies(ObservableList<Currency> value) {
    _$currenciesAtom.reportWrite(value, super.currencies, () {
      super.currencies = value;
    });
  }

  late final _$selectedDateAtom = Atom(
    name: 'CurrencyStoreBase.selectedDate',
    context: context,
  );

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$tlAmountAtom = Atom(
    name: 'CurrencyStoreBase.tlAmount',
    context: context,
  );

  @override
  double? get tlAmount {
    _$tlAmountAtom.reportRead();
    return super.tlAmount;
  }

  @override
  set tlAmount(double? value) {
    _$tlAmountAtom.reportWrite(value, super.tlAmount, () {
      super.tlAmount = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: 'CurrencyStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: 'CurrencyStoreBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$lastUpdateAtom = Atom(
    name: 'CurrencyStoreBase.lastUpdate',
    context: context,
  );

  @override
  DateTime? get lastUpdate {
    _$lastUpdateAtom.reportRead();
    return super.lastUpdate;
  }

  @override
  set lastUpdate(DateTime? value) {
    _$lastUpdateAtom.reportWrite(value, super.lastUpdate, () {
      super.lastUpdate = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: 'CurrencyStoreBase.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$loadExchangeRatesAsyncAction = AsyncAction(
    'CurrencyStoreBase.loadExchangeRates',
    context: context,
  );

  @override
  Future<void> loadExchangeRates(DateTime date) {
    return _$loadExchangeRatesAsyncAction.run(
      () => super.loadExchangeRates(date),
    );
  }

  late final _$refreshRatesAsyncAction = AsyncAction(
    'CurrencyStoreBase.refreshRates',
    context: context,
  );

  @override
  Future<void> refreshRates() {
    return _$refreshRatesAsyncAction.run(() => super.refreshRates());
  }

  late final _$CurrencyStoreBaseActionController = ActionController(
    name: 'CurrencyStoreBase',
    context: context,
  );

  @override
  void updateTlAmount(double? amount) {
    final _$actionInfo = _$CurrencyStoreBaseActionController.startAction(
      name: 'CurrencyStoreBase.updateTlAmount',
    );
    try {
      return super.updateTlAmount(amount);
    } finally {
      _$CurrencyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDate(DateTime date) {
    final _$actionInfo = _$CurrencyStoreBaseActionController.startAction(
      name: 'CurrencyStoreBase.changeDate',
    );
    try {
      return super.changeDate(date);
    } finally {
      _$CurrencyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void search(String query) {
    final _$actionInfo = _$CurrencyStoreBaseActionController.startAction(
      name: 'CurrencyStoreBase.search',
    );
    try {
      return super.search(query);
    } finally {
      _$CurrencyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearError() {
    final _$actionInfo = _$CurrencyStoreBaseActionController.startAction(
      name: 'CurrencyStoreBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$CurrencyStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currencies: ${currencies},
selectedDate: ${selectedDate},
tlAmount: ${tlAmount},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
lastUpdate: ${lastUpdate},
searchQuery: ${searchQuery},
hasError: ${hasError},
hasData: ${hasData},
filteredCurrencies: ${filteredCurrencies}
    ''';
  }
}

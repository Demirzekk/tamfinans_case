import 'package:mobx/mobx.dart';

import '../../../../domain/entities/currency.dart';
import '../../../../domain/repositories/currency_repository.dart';
import '../../../../core/network/api_exceptions.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';

part 'currency_store.g.dart';

class CurrencyStore = CurrencyStoreBase with _$CurrencyStore;

abstract class CurrencyStoreBase with Store {
  final CurrencyRepository _repository;

  CurrencyStoreBase({required CurrencyRepository repository})
    : _repository = repository;

  @observable
  ObservableList<Currency> currencies = ObservableList<Currency>();

  @observable
  DateTime selectedDate = AppConfig.defaultDate;

  @observable
  double? tlAmount;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  DateTime? lastUpdate;

  @observable
  String searchQuery = '';

  @computed
  bool get hasError => errorMessage != null;

  @computed
  bool get hasData => currencies.isNotEmpty;

  @computed
  List<Currency> get filteredCurrencies {
    if (searchQuery.isEmpty) return currencies;
    final query = searchQuery.toLowerCase();
    return currencies.where((c) {
      return c.code?.toLowerCase().contains(query) == true ||
          c.name?.toLowerCase().contains(query) == true ||
          c.nameEnglish?.toLowerCase().contains(query) == true;
    }).toList();
  }

  @action
  Future<void> loadExchangeRates(DateTime date) async {
    isLoading = true;
    errorMessage = null;
    selectedDate = date;

    try {
      final result = await _repository.getExchangeRates(date);
      currencies = ObservableList.of(result);
      lastUpdate = DateTime.now();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (e) {
      errorMessage = AppStrings.unexpectedError;
    } finally {
      isLoading = false;
    }
  }

  @action
  void updateTlAmount(double? amount) {
    tlAmount = amount;
  }

  @action
  void changeDate(DateTime date) {
    loadExchangeRates(date);
  }

  @action
  Future<void> refreshRates() async {
    await loadExchangeRates(selectedDate);
  }

  @action
  void search(String query) {
    searchQuery = query;
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}

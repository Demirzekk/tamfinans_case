import 'package:get/get.dart';

import '../../../../domain/entities/currency.dart';
import '../../../../domain/repositories/currency_repository.dart';
import '../../../../core/network/api_exceptions.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';

class CurrencyController extends GetxController {
  final CurrencyRepository _repository;

  CurrencyController({required CurrencyRepository repository})
    : _repository = repository;

  final currencies = <Currency>[].obs;
  final selectedDate = AppConfig.defaultDate.obs;
  final tlAmount = Rxn<double>();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final lastUpdate = Rxn<DateTime>();
  final searchQuery = ''.obs;

  bool get hasError => errorMessage.value != null;
  bool get hasData => currencies.isNotEmpty;

  List<Currency> get filteredCurrencies {
    if (searchQuery.isEmpty) return currencies;
    final query = searchQuery.value.toLowerCase();
    return currencies.where((c) {
      return c.code?.toLowerCase().contains(query) == true ||
          c.name?.toLowerCase().contains(query) == true ||
          c.nameEnglish?.toLowerCase().contains(query) == true;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadExchangeRates(AppConfig.defaultDate);
  }

  Future<void> loadExchangeRates(DateTime date) async {
    isLoading.value = true;
    errorMessage.value = null;
    selectedDate.value = date;

    try {
      final result = await _repository.getExchangeRates(date);
      currencies.assignAll(result);
      lastUpdate.value = DateTime.now();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = AppStrings.unexpectedError;
    } finally {
      isLoading.value = false;
    }
  }

  void updateTlAmount(double? amount) {
    tlAmount.value = amount;
  }

  void changeDate(DateTime date) {
    loadExchangeRates(date);
  }

  Future<void> refreshRates() async {
    await loadExchangeRates(selectedDate.value);
  }

  void clearError() {
    errorMessage.value = null;
  }

  void search(String query) {
    searchQuery.value = query;
  }
}

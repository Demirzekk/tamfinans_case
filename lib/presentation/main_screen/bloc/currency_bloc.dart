import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/currency_repository.dart';
import '../../../../core/network/api_exceptions.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _repository;

  CurrencyBloc({required CurrencyRepository repository})
    : _repository = repository,
      super(CurrencyLoading(selectedDate: DateTime.now())) {
    on<LoadExchangeRates>(_onLoadExchangeRates);
    on<UpdateTlAmount>(_onUpdateTlAmount);
    on<ChangeDate>(_onChangeDate);
    on<RefreshRates>(_onRefreshRates);
    on<SearchCurrencies>(_onSearchCurrencies);
  }

  void _onSearchCurrencies(
    SearchCurrencies event,
    Emitter<CurrencyState> emit,
  ) {
    if (state is CurrencyLoaded) {
      emit((state as CurrencyLoaded).copyWith(searchQuery: event.query));
    }
  }

  Future<void> _onLoadExchangeRates(
    LoadExchangeRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading(selectedDate: event.date, tlAmount: state.tlAmount));

    try {
      final currencies = await _repository.getExchangeRates(event.date);

      emit(
        CurrencyLoaded(
          currencies: currencies,
          lastUpdate: DateTime.now(),
          selectedDate: event.date,
          tlAmount: state.tlAmount,
        ),
      );
    } on ApiException catch (e) {
      emit(
        CurrencyError(
          message: e.message,
          selectedDate: event.date,
          tlAmount: state.tlAmount,
          previousCurrencies: state is CurrencyLoaded
              ? (state as CurrencyLoaded).currencies
              : null,
        ),
      );
    } catch (e) {
      emit(
        CurrencyError(
          message: 'Beklenmeyen bir hata oluştu',
          selectedDate: event.date,
          tlAmount: state.tlAmount,
        ),
      );
    }
  }

  void _onUpdateTlAmount(UpdateTlAmount event, Emitter<CurrencyState> emit) {
    if (state is CurrencyLoaded) {
      emit((state as CurrencyLoaded).copyWith(tlAmount: event.amount));
    }
  }

  void _onChangeDate(ChangeDate event, Emitter<CurrencyState> emit) {
    add(LoadExchangeRates(date: event.date));
  }

  void _onRefreshRates(RefreshRates event, Emitter<CurrencyState> emit) {
    add(LoadExchangeRates(date: state.selectedDate));
  }
}

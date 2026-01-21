import 'package:flutter_test/flutter_test.dart';
import 'package:tamfinans_case/domain/entities/currency.dart';
import 'package:tamfinans_case/domain/repositories/currency_repository.dart';
import 'package:tamfinans_case/presentation/main_screen/bloc/currency_bloc.dart';
import 'package:tamfinans_case/presentation/main_screen/bloc/currency_event.dart';
import 'package:tamfinans_case/presentation/main_screen/bloc/currency_state.dart';
import 'package:tamfinans_case/core/network/api_exceptions.dart';

class MockCurrencyRepository implements CurrencyRepository {
  List<Currency>? currenciesToReturn;
  ApiException? exceptionToThrow;

  @override
  Future<List<Currency>> getExchangeRates(DateTime date) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return currenciesToReturn ?? [];
  }

  @override
  Future<List<Currency>> getTodayRates() => getExchangeRates(DateTime.now());
}

void main() {
  late CurrencyBloc bloc;
  late MockCurrencyRepository mockRepository;

  final testDate = DateTime(2025, 1, 17);

  final testCurrencies = [
    const Currency(
      code: 'USD',
      name: 'ABD DOLARI',
      nameEnglish: 'US DOLLAR',
      unit: 1,
      forexBuying: 35.4119,
      forexSelling: 35.4757,
    ),
    const Currency(
      code: 'EUR',
      name: 'EURO',
      nameEnglish: 'EURO',
      unit: 1,
      forexBuying: 36.4321,
      forexSelling: 36.5000,
    ),
  ];

  setUp(() {
    mockRepository = MockCurrencyRepository();
    bloc = CurrencyBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('CurrencyBloc', () {
    test('initial state should be CurrencyLoading', () {
      expect(bloc.state, isA<CurrencyLoading>());
    });

    test('emits CurrencyLoaded when LoadExchangeRates succeeds', () async {
      mockRepository.currenciesToReturn = testCurrencies;

      bloc.add(LoadExchangeRates(date: testDate));

      await expectLater(
        bloc.stream,
        emitsInOrder([isA<CurrencyLoading>(), isA<CurrencyLoaded>()]),
      );

      final state = bloc.state as CurrencyLoaded;
      expect(state.currencies.length, 2);
      expect(state.currencies.first.code, 'USD');
    });

    test('emits CurrencyError when LoadExchangeRates fails', () async {
      mockRepository.exceptionToThrow = const NetworkException(
        message: 'İnternet bağlantısı yok',
      );

      bloc.add(LoadExchangeRates(date: testDate));

      await expectLater(
        bloc.stream,
        emitsInOrder([isA<CurrencyLoading>(), isA<CurrencyError>()]),
      );

      final state = bloc.state as CurrencyError;
      expect(state.message, 'İnternet bağlantısı yok');
    });

    test('updates tlAmount when UpdateTlAmount is added', () async {
      mockRepository.currenciesToReturn = testCurrencies;

      bloc.add(LoadExchangeRates(date: testDate));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const UpdateTlAmount(amount: 1000));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as CurrencyLoaded;
      expect(state.tlAmount, 1000);
    });
  });
}

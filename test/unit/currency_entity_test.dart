import 'package:flutter_test/flutter_test.dart';
import 'package:tamfinans_case/domain/entities/currency.dart';

void main() {
  group('Currency Entity', () {
    late Currency testCurrency;

    setUp(() {
      testCurrency = const Currency(
        code: 'USD',
        name: 'ABD DOLARI',
        nameEnglish: 'US DOLLAR',
        unit: 1,
        forexBuying: 35.4119,
        forexSelling: 35.4757,
        banknoteBuying: 35.3500,
        banknoteSelling: 35.5500,
      );
    });

    test('should create Currency with correct values', () {
      expect(testCurrency.code, 'USD');
      expect(testCurrency.name, 'ABD DOLARI');
      expect(testCurrency.unit, 1);
      expect(testCurrency.forexBuying, 35.4119);
      expect(testCurrency.forexSelling, 35.4757);
    });

    test('should return correct icon for common currencies', () {
      expect(testCurrency.icon, '\$');

      const eurCurrency = Currency(
        code: 'EUR',
        name: 'EURO',
        nameEnglish: 'EURO',
        unit: 1,
        forexBuying: 38.0,
        forexSelling: 38.5,
      );
      expect(eurCurrency.icon, '€');

      const gbpCurrency = Currency(
        code: 'GBP',
        name: 'İNGİLİZ STERLİNİ',
        nameEnglish: 'BRITISH POUND',
        unit: 1,
        forexBuying: 44.0,
        forexSelling: 44.5,
      );
      expect(gbpCurrency.icon, '£');
    });

    test('should convert TL to currency correctly', () {
      final result = testCurrency.convertFromTl(1000);
      expect(result, closeTo(28.19, 0.01));
    });

    test('should convert currency to TL correctly', () {
      final result = testCurrency.convertToTl(100);
      expect(result, closeTo(3541.19, 0.01));
    });

    test('should handle unit conversion for JPY', () {
      const jpyCurrency = Currency(
        code: 'JPY',
        name: 'JAPON YENİ',
        nameEnglish: 'JAPANESE YEN',
        unit: 100,
        forexBuying: 22.5,
        forexSelling: 23.0,
      );

      final result = jpyCurrency.convertFromTl(1000);
      expect(result, closeTo(4347.83, 0.01));
    });

    test('should return 0 when forex selling is 0', () {
      const zeroCurrency = Currency(
        code: 'TEST',
        name: 'Test',
        nameEnglish: 'Test',
        unit: 1,
        forexBuying: 0,
        forexSelling: 0,
      );

      expect(zeroCurrency.convertFromTl(1000), 0);
    });
  });
}

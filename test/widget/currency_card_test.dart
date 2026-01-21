import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamfinans_case/presentation/common/widgets/currency_card.dart';
import 'package:tamfinans_case/domain/entities/currency.dart';

void main() {
  group('CurrencyCard Widget', () {
    const testCurrency = Currency(
      code: 'USD',
      name: 'ABD DOLARI',
      nameEnglish: 'US DOLLAR',
      unit: 1,
      forexBuying: 35.4119,
      forexSelling: 35.4757,
    );

    Widget createTestWidget({double? tlAmount}) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: CurrencyCard(currency: testCurrency, tlAmount: tlAmount),
        ),
      );
    }

    testWidgets('should display currency code and name', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('USD'), findsOneWidget);
      expect(find.text('ABD DOLARI'), findsOneWidget);
    });

    testWidgets('should display forex buying and selling rates', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('35.4119'), findsOneWidget);
      expect(find.text('35.4757'), findsOneWidget);
      expect(find.text('Alış'), findsOneWidget);
      expect(find.text('Satış'), findsOneWidget);
    });

    testWidgets('should display currency icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('\$'), findsOneWidget);
    });

    testWidgets('should display converted amount when tlAmount is provided', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(tlAmount: 1000));

      expect(find.textContaining('28.'), findsOneWidget);
    });

    testWidgets('should not display converted amount when tlAmount is 0', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(tlAmount: 0));

      expect(find.text('USD'), findsOneWidget);
    });
  });
}

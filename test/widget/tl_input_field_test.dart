import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tamfinans_case/presentation/common/widgets/tl_input_field.dart';

void main() {
  group('TlInputField Widget', () {
    Widget createTestWidget({
      required TextEditingController controller,
      ValueChanged<double?>? onChanged,
    }) {
      return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: TlInputField(controller: controller, onChanged: onChanged),
        ),
      );
    }

    testWidgets('should display TL symbol', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(createTestWidget(controller: controller));

      expect(find.text('₺'), findsOneWidget);
    });

    testWidgets('should display hint text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(createTestWidget(controller: controller));

      expect(find.text('Tutar Giriniz'), findsOneWidget);
    });

    testWidgets(
      'should call onChanged with parsed value when text is entered',
      (tester) async {
        final controller = TextEditingController();
        double? receivedValue;

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
            onChanged: (value) => receivedValue = value,
          ),
        );

        await tester.enterText(find.byType(TextField), '1000');
        await tester.pump();

        expect(receivedValue, 1000.0);
      },
    );

    testWidgets('should handle Turkish number format with comma', (
      tester,
    ) async {
      final controller = TextEditingController();
      double? receivedValue;

      await tester.pumpWidget(
        createTestWidget(
          controller: controller,
          onChanged: (value) => receivedValue = value,
        ),
      );

      // Türkçe format: 1000,50
      await tester.enterText(find.byType(TextField), '1000,50');
      await tester.pump();

      expect(receivedValue, 1000.50);
    });

    testWidgets('should call onChanged with null when text is cleared', (
      tester,
    ) async {
      final controller = TextEditingController(text: '1000');
      double? receivedValue = 1000;

      await tester.pumpWidget(
        createTestWidget(
          controller: controller,
          onChanged: (value) => receivedValue = value,
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(receivedValue, isNull);
    });

    testWidgets('should show clear button when text is not empty', (
      tester,
    ) async {
      final controller = TextEditingController(text: '1000');

      await tester.pumpWidget(createTestWidget(controller: controller));
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets(
      'should clear text and call onChanged when clear button is tapped',
      (tester) async {
        final controller = TextEditingController(text: '1000');
        double? receivedValue = 1000;

        await tester.pumpWidget(
          createTestWidget(
            controller: controller,
            onChanged: (value) => receivedValue = value,
          ),
        );
        await tester.pump();

        await tester.tap(find.byIcon(Icons.clear));
        await tester.pump();

        expect(controller.text, isEmpty);
        expect(receivedValue, isNull);
      },
    );
  });
}

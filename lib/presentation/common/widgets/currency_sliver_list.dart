import 'package:flutter/material.dart';

import '../../../domain/entities/currency.dart';
import 'currency_card.dart';
import 'state_indicators.dart';

class CurrencySliverList extends StatelessWidget {
  const CurrencySliverList({
    super.key,
    required this.isLoading,
    this.errorMessage,
    required this.currencies,
    this.tlAmount,
    required this.onRetry,
  });

  final bool isLoading;
  final String? errorMessage;
  final List<Currency> currencies;
  final double? tlAmount;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading && currencies.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: LoadingIndicator(message: 'Kurlar yükleniyor...'),
      );
    }

    if (errorMessage != null && currencies.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorIndicator(message: errorMessage!, onRetry: onRetry),
      );
    }

    if (currencies.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: EmptyIndicator(message: 'Bu tarih için kur verisi bulunamadı'),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final currency = currencies[index];
        return CurrencyCard(
          currency: currency,
          tlAmount: tlAmount,
          index: index,
        );
      }, childCount: currencies.length),
    );
  }
}

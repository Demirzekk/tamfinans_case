import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injection.dart';
import '../../../../domain/repositories/currency_repository.dart';
import '../../../common/dialogs/app_date_picker.dart';
import '../../../common/widgets/currency_sliver_app_bar.dart';
import '../../../common/widgets/currency_sliver_list.dart';
import '../../../common/widgets/rates_header.dart';
import '../currency_store.dart';

class CurrencyScreenMobx extends StatefulWidget {
  const CurrencyScreenMobx({super.key});

  @override
  State<CurrencyScreenMobx> createState() => _CurrencyScreenMobxState();
}

class _CurrencyScreenMobxState extends State<CurrencyScreenMobx> {
  late final CurrencyStore _store;
  final _tlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _store = CurrencyStore(repository: getIt<CurrencyRepository>());
    _store.loadExchangeRates(_store.selectedDate);
  }

  @override
  void dispose() {
    _tlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Observer(
      builder: (_) {
        final currentTlAmount = _store.tlAmount;
        final selectedDate = _store.selectedDate;
        final isLoading = _store.isLoading;
        final errorMessage = _store.hasError ? _store.errorMessage : null;

        return RefreshIndicator(
          onRefresh: () => _store.refreshRates(),
          color: theme.colorScheme.primary,
          edgeOffset: 70,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              CurrencySliverAppBar(
                selectedDate: selectedDate,
                tlController: _tlController,
                onDateSelected: (date) => _store.changeDate(date),
                onChangeTapped: () => _showDatePicker(context, selectedDate),
                onTlAmountChanged: (amount) => _store.updateTlAmount(amount),
              ),

              SliverToBoxAdapter(
                child: RatesHeader(
                  isLoading: isLoading,
                  updateTime: _store.lastUpdate != null
                      ? DateFormat('HH:mm').format(_store.lastUpdate!)
                      : '--:--',
                  onSearch: _store.search,
                ),
              ),

              CurrencySliverList(
                isLoading: isLoading,
                errorMessage: errorMessage,
                currencies: _store.filteredCurrencies.toList(),
                tlAmount: currentTlAmount,
                onRetry: () => _store.refreshRates(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    DateTime currentDate,
  ) async {
    final picked = await AppDatePicker.show(
      context: context,
      currentDate: currentDate,
    );

    if (picked != null) {
      _store.changeDate(picked);
    }
  }
}

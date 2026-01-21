import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/injection.dart';
import '../../../../domain/repositories/currency_repository.dart';
import '../../../common/dialogs/app_date_picker.dart';
import '../../../common/widgets/currency_sliver_app_bar.dart';
import '../../../common/widgets/currency_sliver_list.dart';
import '../../../common/widgets/rates_header.dart';
import '../currency_controller.dart';

class CurrencyScreenGetx extends StatefulWidget {
  const CurrencyScreenGetx({super.key});

  @override
  State<CurrencyScreenGetx> createState() => _CurrencyScreenContentState();
}

class _CurrencyScreenContentState extends State<CurrencyScreenGetx> {
  final _tlController = TextEditingController();

  CurrencyController get controller => Get.find<CurrencyController>();

  @override
  void initState() {
    Get.lazyPut<CurrencyController>(
      () => CurrencyController(repository: getIt<CurrencyRepository>()),
    );
    super.initState();
  }

  @override
  void dispose() {
    _tlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final currentTlAmount = controller.tlAmount.value;
      final selectedDate = controller.selectedDate.value;
      final currencies = controller.filteredCurrencies;
      final isLoading = controller.isLoading.value;

      return RefreshIndicator(
        onRefresh: () => controller.refreshRates(),
        color: theme.colorScheme.primary,
        edgeOffset: 70,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CurrencySliverAppBar(
              selectedDate: selectedDate,
              tlController: _tlController,
              onDateSelected: (date) => controller.changeDate(date),
              onChangeTapped: () => _showDatePicker(context, selectedDate),
              onTlAmountChanged: (amount) => controller.updateTlAmount(amount),
            ),

            SliverToBoxAdapter(
              child: RatesHeader(
                isLoading: isLoading,
                updateTime: controller.lastUpdate.value != null
                    ? DateFormat('HH:mm').format(controller.lastUpdate.value!)
                    : '--:--',
                onSearch: controller.search,
              ),
            ),

            CurrencySliverList(
              isLoading: isLoading,
              errorMessage: controller.errorMessage.value,
              currencies: currencies,
              tlAmount: currentTlAmount,
              onRetry: () => controller.refreshRates(),
            ),
          ],
        ),
      );
    });
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
      controller.changeDate(picked);
    }
  }
}

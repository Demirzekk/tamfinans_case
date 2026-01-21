import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tamfinans_case/domain/entities/currency.dart';

import '../../../../app/di/injection.dart';
import '../../../../domain/repositories/currency_repository.dart';
import '../../../common/dialogs/app_date_picker.dart';
import '../../../common/widgets/currency_sliver_app_bar.dart';
import '../../../common/widgets/currency_sliver_list.dart';
import '../../../common/widgets/rates_header.dart';

import '../currency_bloc.dart';
import '../currency_event.dart';
import '../currency_state.dart';

class CurrencyScreenBloc extends StatefulWidget {
  const CurrencyScreenBloc({super.key});

  @override
  State<CurrencyScreenBloc> createState() => _CurrencyScreenBlocState();
}

class _CurrencyScreenBlocState extends State<CurrencyScreenBloc> {
  late final CurrencyBloc _bloc;
  final _tlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = CurrencyBloc(repository: getIt<CurrencyRepository>());
    _bloc.add(LoadExchangeRates(date: DateTime.now()));
  }

  @override
  void dispose() {
    _bloc.close();
    _tlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          return _buildContent(context, state);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CurrencyState state) {
    final theme = Theme.of(context);

    DateTime selectedDate = DateTime.now();
    double? tlAmount;

    bool isLoading = state is CurrencyLoading;
    String? errorMessage;
    List<Currency> currencies = [];

    if (state is CurrencyError) {
      errorMessage = state.message;
    }

    if (state is CurrencyLoaded) {
      selectedDate = state.selectedDate;
      tlAmount = state.tlAmount;

      currencies = state.currencies;
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<CurrencyBloc>().add(const RefreshRates());
      },
      color: theme.colorScheme.primary,
      edgeOffset: 70,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CurrencySliverAppBar(
              selectedDate: selectedDate,
              tlController: _tlController,
              onDateSelected: (date) {
                context.read<CurrencyBloc>().add(ChangeDate(date: date));
              },
              onChangeTapped: () => _showDatePicker(context, selectedDate),
              onTlAmountChanged: (amount) {
                context.read<CurrencyBloc>().add(
                  UpdateTlAmount(amount: amount),
                );
              },
            ),

            SliverToBoxAdapter(
              child: RatesHeader(
                isLoading: isLoading,
                updateTime: state is CurrencyLoaded
                    ? DateFormat('HH:mm').format(state.lastUpdate)
                    : '--:--',
                onSearch: (query) {
                  context.read<CurrencyBloc>().add(
                    SearchCurrencies(query: query),
                  );
                },
              ),
            ),

            CurrencySliverList(
              isLoading: isLoading,
              errorMessage: errorMessage,
              currencies: state is CurrencyLoaded
                  ? state.filteredCurrencies
                  : currencies,
              tlAmount: tlAmount,
              onRetry: () {
                context.read<CurrencyBloc>().add(const RefreshRates());
              },
            ),
          ],
        ),
      ),
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

    if (picked != null && context.mounted) {
      context.read<CurrencyBloc>().add(ChangeDate(date: picked));
    }
  }
}

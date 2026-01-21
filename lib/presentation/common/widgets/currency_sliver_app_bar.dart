import 'package:flutter/material.dart';
import 'package:tamfinans_case/presentation/common/widgets/date_picker_row.dart';

import 'package:tamfinans_case/presentation/common/widgets/tl_input_field.dart';
import '../../../core/constants/app_strings.dart';

class CurrencySliverAppBar extends StatelessWidget {
  const CurrencySliverAppBar({
    super.key,
    required this.selectedDate,
    required this.tlController,
    required this.onDateSelected,
    required this.onChangeTapped,
    required this.onTlAmountChanged,
  });

  final DateTime selectedDate;
  final TextEditingController tlController;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onChangeTapped;
  final ValueChanged<double?> onTlAmountChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;

    return SliverAppBar(
      expandedHeight: 270,
      toolbarHeight: 0,
      collapsedHeight: 20,
      pinned: true,
      backgroundColor: bgColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            const SizedBox(height: 16),
            DatePickerRow(
              selectedDate: selectedDate,
              onDateSelected: onDateSelected,
              onChangeTapped: onChangeTapped,
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                AppStrings.quickConvertTl,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 12,
                  color: theme.hintColor,
                ),
              ),
            ),

            TlInputField(
              controller: tlController,
              onChanged: onTlAmountChanged,
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

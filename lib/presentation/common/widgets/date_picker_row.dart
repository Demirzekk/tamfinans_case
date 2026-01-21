import 'package:flutter/material.dart';

import 'package:tamfinans_case/core/constants/app_strings.dart';
import 'package:tamfinans_case/core/theme/app_colors_extension.dart';
import 'package:tamfinans_case/core/constants/app_icons_constant.dart';
import 'package:tamfinans_case/presentation/common/widgets/custom_svg_widget.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final VoidCallback? onChangeTapped;

  const DatePickerRow({
    super.key,
    required this.selectedDate,
    this.onDateSelected,
    this.onChangeTapped,
  });

  bool _isSelectableDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAfter(today)) return false;

    if (date.weekday == 6 || date.weekday == 7) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary =
        appColors.textSecondary ?? theme.colorScheme.onSurface;
    final surfaceColor =
        appColors.iconBackground ?? theme.colorScheme.surfaceContainerHighest;
    final disabledColor = appColors.textHint ?? theme.hintColor;
    final primaryColor = theme.colorScheme.primary;

    final dates = List.generate(10, (index) {
      return selectedDate.subtract(Duration(days: 5 - index));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.selectedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text(
                    _formatDisplayDate(selectedDate),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: onChangeTapped,
                icon: SvgIconFromAssets(
                  iconName: AppIcons.calendarMonth,
                  height: 16,
                ),
                label: const Text('Değiştir'),
                style: TextButton.styleFrom(
                  backgroundColor: surfaceColor,
                  foregroundColor: textPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.blueGrey.shade600,
                      width: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = _isSameDay(date, selectedDate);
              final isSelectable = _isSelectableDate(date);

              return GestureDetector(
                onTap: isSelectable ? () => onDateSelected?.call(date) : null,
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor
                        : isSelectable
                        ? surfaceColor
                        : surfaceColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !isSelectable
                          ? Colors.transparent
                          : primaryColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDayName(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white
                              : isSelectable
                              ? textSecondary
                              : disabledColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : isSelectable
                              ? textPrimary
                              : disabledColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDisplayDate(DateTime date) {
    final months = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatDayName(DateTime date) {
    final days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return days[date.weekday - 1];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

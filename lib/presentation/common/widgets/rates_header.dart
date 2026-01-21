import 'package:flutter/material.dart';
import 'package:tamfinans_case/core/constants/app_strings.dart';
import 'package:tamfinans_case/core/theme/app_colors_extension.dart';

class RatesHeader extends StatefulWidget {
  const RatesHeader({
    super.key,
    required this.isLoading,
    this.updateTime = '--:--',
    this.onSearch,
  });

  final bool isLoading;
  final String updateTime;
  final ValueChanged<String>? onSearch;

  @override
  State<RatesHeader> createState() => _RatesHeaderState();
}

class _RatesHeaderState extends State<RatesHeader> {
  late final ValueNotifier<bool> _isSearchActiveNotifier;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSearchActiveNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _isSearchActiveNotifier.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    final isActive = !_isSearchActiveNotifier.value;
    _isSearchActiveNotifier.value = isActive;

    if (!isActive) {
      _searchController.clear();
      widget.onSearch?.call('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;
    final textSecondary = appColors.textSecondary ?? theme.hintColor;
    final surfaceColor = appColors.surfaceContainerLowest ?? theme.cardColor;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isSearchActiveNotifier,
        builder: (context, isSearchActive, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: isSearchActive
                    ? TextField(
                        controller: _searchController,
                        autofocus: true,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: AppStrings.searchHint,
                          hintStyle: TextStyle(color: textSecondary),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: widget.onSearch,
                      )
                    : Text(
                        AppStrings.rates,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textSecondary,
                        ),
                      ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  if (widget.isLoading) ...[
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: _toggleSearch,
                    icon: Icon(
                      isSearchActive ? Icons.close : Icons.search,
                      color: textSecondary,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${widget.updateTime} ${AppStrings.updateSuffix}',
                      style: TextStyle(
                        fontSize: 12,
                        color: textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

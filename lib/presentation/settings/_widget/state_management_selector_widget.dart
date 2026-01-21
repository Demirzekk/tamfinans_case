import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamfinans_case/app/di/injection.dart';
import 'package:tamfinans_case/core/extension/state_management_type.dart';
import 'package:tamfinans_case/core/theme/app_colors_extension.dart';

import 'package:tamfinans_case/presentation/settings/_widget/section_header_widget.dart';

class StateManagementSelectorWidget extends StatefulWidget {
  const StateManagementSelectorWidget({
    super.key,
    required this.selectedType,
    this.onStateManagementChanged,
  });
  final ValueChanged<StateManagementType>? onStateManagementChanged;
  final StateManagementType selectedType;

  @override
  State<StateManagementSelectorWidget> createState() =>
      _StateManagementSelectorWidgetState();
}

class _StateManagementSelectorWidgetState
    extends State<StateManagementSelectorWidget> {
  late StateManagementType _currentType;

  @override
  void initState() {
    super.initState();
    _currentType = widget.selectedType;
  }

  @override
  void didUpdateWidget(covariant StateManagementSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedType != oldWidget.selectedType) {
      _currentType = widget.selectedType;
    }
  }

  Future<void> _handleSelection(StateManagementType type) async {
    setState(() {
      _currentType = type;
    });

    final prefs = getIt<SharedPreferences>();
    await prefs.setInt('stateManagementType', type.index);
    widget.onStateManagementChanged?.call(type);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    final cardColor = theme.scaffoldBackgroundColor;
    final secondaryColor = theme.colorScheme.onSurface;
    final surfaceSelected =
        appColors.iconBackground ?? theme.colorScheme.surfaceContainerHighest;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: theme.cardTheme.color,
      child: Column(
        children: [
          const SectionHeaderWidget(),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: cardColor,
            ),
            child: Row(
              children: StateManagementType.values.map((type) {
                final isSelected = type == _currentType;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _handleSelection(type),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? surfaceSelected
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          type.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? theme.colorScheme.onSurface
                                : secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

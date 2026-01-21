import 'package:flutter/material.dart';
import 'package:tamfinans_case/core/constants/app_strings.dart';
import 'package:tamfinans_case/presentation/common/widgets/amount_badge.dart';
import '../../../domain/entities/currency.dart';

class CurrencyCard extends StatefulWidget {
  final Currency currency;
  final double? tlAmount;
  final VoidCallback? onTap;
  final int index;
  final bool animateEntry;

  const CurrencyCard({
    super.key,
    required this.currency,
    this.tlAmount,
    this.onTap,
    this.index = 0,
    this.animateEntry = true,
  });

  @override
  State<CurrencyCard> createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutQuart),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutQuart),
        );

    if (widget.animateEntry && !_hasAnimated) {
      Future.delayed(Duration(milliseconds: widget.index * 80), () {
        if (mounted) {
          _entryController.forward();
          _hasAnimated = true;
        }
      });
    } else {
      _entryController.value = 1.0;
      _hasAnimated = true;
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surfaceColor = theme.colorScheme.surfaceContainerHighest;
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary = theme.hintColor;
    final primaryColor = theme.colorScheme.primary;

    final convertedAmount = widget.tlAmount != null && widget.tlAmount! > 0
        ? widget.currency.convertFromTl(widget.tlAmount!)
        : null;

    Widget cardContent = Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: surfaceColor,
                    child: Center(
                      child: Text(
                        widget.currency.icon,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currency.code ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          widget.currency.name ?? '',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  AnimatedAmountBadge(
                    amount: convertedAmount,
                    currencyCode: widget.currency.code ?? '',
                    primaryColor: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: surfaceColor.withValues(alpha: 1), thickness: 1.5),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.buy,
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.currency.forexBuying?.toStringAsFixed(4) ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppStrings.sell,
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.currency.forexSelling?.toStringAsFixed(4) ??
                              '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.animateEntry) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(position: _slideAnimation, child: cardContent),
      );
    }

    return cardContent;
  }
}

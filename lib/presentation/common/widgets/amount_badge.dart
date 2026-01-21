import 'package:flutter/material.dart';

class AnimatedAmountBadge extends StatefulWidget {
  final double? amount;
  final String currencyCode;
  final Color primaryColor;

  const AnimatedAmountBadge({
    super.key,
    required this.amount,
    required this.currencyCode,
    required this.primaryColor,
  });

  @override
  State<AnimatedAmountBadge> createState() => _AnimatedAmountBadgeState();
}

class _AnimatedAmountBadgeState extends State<AnimatedAmountBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousAmount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _previousAmount = widget.amount ?? 0;
    _animation = Tween<double>(
      begin: _previousAmount,
      end: _previousAmount,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(AnimatedAmountBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.amount != oldWidget.amount) {
      _previousAmount = _animation.value;
      _animation =
          Tween<double>(
            begin: _previousAmount,
            end: widget.amount ?? 0,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.amount == null || (widget.amount ?? 0) <= 0) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: widget.primaryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${_animation.value.toStringAsFixed(2)} ${widget.currencyCode}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
          ),
        );
      },
    );
  }
}

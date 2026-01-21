import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TlInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<double?>? onChanged;
  final String hintText;

  const TlInputField({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Tutar Giriniz',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary = theme.hintColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            style: TextStyle(fontSize: 16, color: textPrimary),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Container(
                width: 48,
                alignment: Alignment.center,
                child: Text(
                  '₺',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textSecondary,
                  ),
                ),
              ),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: textSecondary),
                      onPressed: () {
                        controller.clear();
                        onChanged?.call(null);
                      },
                    )
                  : null,
            ),
            onChanged: (text) {
              if (text.isEmpty) {
                onChanged?.call(null);
                return;
              }

              final normalized = text.replaceAll('.', '').replaceAll(',', '.');
              final parsed = double.tryParse(normalized);
              onChanged?.call(parsed);
            },
          );
        },
      ),
    );
  }
}

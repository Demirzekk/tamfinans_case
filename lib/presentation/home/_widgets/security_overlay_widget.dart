import 'package:flutter/material.dart';

class SecurityOverlayWidget extends StatelessWidget {
  const SecurityOverlayWidget({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF0D0D0F) : Colors.grey[100]!;
    final textPrimary = isDark ? Colors.white : Colors.grey[900]!;
    final textSecondary = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      color: bgColor.withValues(alpha: 0.98),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 64, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              'Güvenlik Uyarısı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Ekran kaydı algılandı.\nGüvenlik nedeniyle içerik gizlendi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: textSecondary),
              ),
            ),
            const SizedBox(height: 32),
            Icon(Icons.videocam_off, size: 48, color: textSecondary),
          ],
        ),
      ),
    );
  }
}

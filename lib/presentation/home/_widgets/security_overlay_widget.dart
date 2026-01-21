import 'package:flutter/material.dart';
import 'package:tamfinans_case/core/theme/app_colors_extension.dart';

class SecurityOverlayWidget extends StatelessWidget {
  const SecurityOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorsExtension>()!;

    final bgColor = appColors.securityOverlayBackground!;
    final textPrimary = theme.colorScheme.onSurface;
    final textSecondary = appColors.textSecondary ?? theme.hintColor;

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

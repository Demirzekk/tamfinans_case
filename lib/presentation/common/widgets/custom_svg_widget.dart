import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconFromAssets extends StatelessWidget {
  const SvgIconFromAssets({
    super.key,
    required this.iconName,
    this.color,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(2),
    this.boxfit = BoxFit.contain,
  });

  final String iconName;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final BoxFit boxfit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: !_isImage
          ? SvgPicture.asset(
              iconName,
              colorFilter: color != null
                  ? ColorFilter.mode(color!, BlendMode.srcIn)
                  : null,
              width: width,
              height: height,
              fit: boxfit,
            )
          : Image.asset(
              iconName,
              color: color,
              width: width,
              height: height,
              fit: boxfit,
            ),
    );
  }

  bool get _isImage =>
      iconName.toLowerCase().contains(".png") ||
      iconName.toLowerCase().contains(".jpg") ||
      iconName.toLowerCase().contains(".jpeg");
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({
    super.key,
    required this.icon,
    this.size,
    this.color,
  });

  const AppIconWidget.iconData(
    IconData iconData, {
    super.key,
    this.size,
    this.color,
  }) : icon = iconData;

  const AppIconWidget.svgAsset(
    String assetName, {
    super.key,
    this.size,
    this.color,
  }) : icon = 'assets/icons/$assetName.svg';

  final dynamic icon;
  final double? size;
  final Color? color;

  String _getImageType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'svg':
        return 'svg';
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
        return 'raster';
      default:
        return 'unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (icon is IconData) {
      return Icon(icon as IconData, size: size, color: color);
    }

    if (icon is String) {
      final imageType = _getImageType(icon as String);

      if (imageType == 'svg') {
        return SvgPicture.asset(
          icon as String,
          width: size,
          height: size,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      }

      if (imageType == 'raster') {
        return Image.asset(
          icon as String,
          width: size,
          height: size,
          color: color,
        );
      }
    }

    return const SizedBox.shrink();
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/tokens/color_tokens.dart';
import 'app_icon_widget.dart';
import 'shimmer_place_holder_widget.dart';

class AppNetworkImageWidget extends StatelessWidget {
  const AppNetworkImageWidget(
    this.imageUrl, {
    super.key,
    this.cached = true,
    this.fadeInDuration = const Duration(milliseconds: 1),
    this.fadeOutDuration = const Duration(milliseconds: 1),
    this.fit,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholderImageUrl,
  });

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final bool cached;
  final String? placeholderImageUrl;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    final baseProvider = cached
        ? CachedNetworkImageProvider(imageUrl)
        : NetworkImage(imageUrl) as ImageProvider;

    final imageProvider = cacheWidth != null || cacheHeight != null
        ? ResizeImage(baseProvider, width: cacheWidth, height: cacheHeight)
        : baseProvider;

    final placeholderProvider = placeholderImageUrl == null
        ? null
        : cached
        ? CachedNetworkImageProvider(placeholderImageUrl!)
        : NetworkImage(placeholderImageUrl!) as ImageProvider;

    if (placeholderProvider != null) {
      return FadeInImage(
        placeholder: placeholderProvider,
        image: imageProvider,
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: fadeInDuration,
        fadeOutDuration: fadeOutDuration,
        imageErrorBuilder: (context, error, stackTrace) =>
            const AppIconWidget.svgAsset(
              'alert_circle',
              size: 24,
              color: AppColors.gray200,
            ),
      );
    }

    return Image(
      image: imageProvider,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) =>
          const AppIconWidget.svgAsset(
            'alert_circle',
            size: 24,
            color: AppColors.gray200,
          ),
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
          ? child
          : ShimmerPlaceHolderWidget(width: width, height: height),
    );
  }
}

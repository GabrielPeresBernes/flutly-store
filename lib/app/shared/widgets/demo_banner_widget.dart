import 'package:flutter/material.dart';

import '../theme/tokens/color_tokens.dart';

class DemoBannerWidget extends StatelessWidget {
  const DemoBannerWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Banner(
      message: 'DEMO',
      location: BannerLocation.topEnd,
      color: AppColors.error,
      child: child,
    );
  }
}

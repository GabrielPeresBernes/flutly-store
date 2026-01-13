import 'package:flutter/material.dart';

class ProductHeroWidget extends StatelessWidget {
  const ProductHeroWidget({
    super.key,
    required this.tag,
    required this.child,
  });

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_$tag',
      flightShuttleBuilder: (_, __, flightDirection, ___, toHeroContext) {
        // Cancel the pop animation hero flight
        return flightDirection == HeroFlightDirection.pop
            ? const SizedBox()
            : toHeroContext.widget;
      },
      placeholderBuilder: (context, size, child) => child,
      child: child,
    );
  }
}

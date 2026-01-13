import 'package:flutter/widgets.dart';

class CatalogUtils {
  CatalogUtils(BuildContext context)
    : _screenWidth = MediaQuery.of(context).size.width;

  final double _screenWidth;
  final double _screenPadding = 24 + 24; // horizontal padding (left + right)
  final double _productCardHeight = 255;

  final int nProductsPerRow = 2;

  final double axisSpacing = 12; // spacing between grid items

  double get productsAspectRatio =>
      (_screenWidth - _screenPadding - axisSpacing) /
      nProductsPerRow /
      _productCardHeight;

  double get rowAspectRatio =>
      (_screenWidth - _screenPadding) / _productCardHeight;
}

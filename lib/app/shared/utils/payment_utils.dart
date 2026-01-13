import '../../features/checkout/checkout.dart';

class PaymentUtils {
  static String getCardBrandIcon(CardBrand brand) {
    switch (brand) {
      case CardBrand.visa:
        return 'brand_visa';
      case CardBrand.mastercard:
        return 'brand_mastercard';
      case CardBrand.unknown:
        return '';
    }
  }
}

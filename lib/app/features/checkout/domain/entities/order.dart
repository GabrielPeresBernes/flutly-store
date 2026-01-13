import '../../../cart/domain/entities/cart_product.dart';
import 'address.dart';
import 'payment_card.dart';
import 'shipping.dart';

class Order {
  Order({
    required this.id,
    required this.address,
    required this.shipping,
    required this.payment,
    required this.products,
    required this.totalPrice,
    required this.totalItems,
  });

  final String id;
  final Address address;
  final Shipping shipping;
  final PaymentCard payment;
  final List<CartProduct> products;
  final double totalPrice;
  final int totalItems;
}

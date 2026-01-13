import '../../../../shared/utils/json_parser.dart';
import '../../../cart/data/models/cart_product_model.dart';
import '../../domain/entities/order.dart';
import 'address_model.dart';
import 'payment_card_model.dart';
import 'shipping_model.dart';

class OrderModel {
  OrderModel({
    required this.id,
    required this.address,
    required this.shipping,
    required this.payment,
    required this.products,
    required this.totalPrice,
    required this.totalItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
      shipping: ShippingModel.fromJson(
        json['shipping'] as Map<String, dynamic>,
      ),
      payment: PaymentCardModel.fromJson(
        json['payment'] as Map<String, dynamic>,
      ),
      products: (json['products'] as List<dynamic>)
          .map((e) => CartProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: JsonParser.parseDouble(json['totalPrice']),
      totalItems: JsonParser.parseInt(json['totalItems']),
    );
  }

  factory OrderModel.fromEntity(Order entity) => OrderModel(
    id: entity.id,
    address: AddressModel.fromEntity(entity.address),
    shipping: ShippingModel.fromEntity(entity.shipping),
    payment: PaymentCardModel.fromEntity(entity.payment),
    products: entity.products.map(CartProductModel.fromEntity).toList(),
    totalPrice: entity.totalPrice,
    totalItems: entity.totalItems,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'address': address.toJson(),
    'shipping': shipping.toJson(),
    'payment': payment.toJson(),
    'products': products.map((e) => e.toJson()).toList(),
    'totalPrice': totalPrice,
    'totalItems': totalItems,
  };

  Order toEntity() => Order(
    id: id,
    address: address.toEntity(),
    shipping: shipping.toEntity(),
    payment: payment.toEntity(),
    products: products.map((e) => e.toEntity()).toList(),
    totalPrice: totalPrice,
    totalItems: totalItems,
  );

  final String id;
  final AddressModel address;
  final ShippingModel shipping;
  final PaymentCardModel payment;
  final List<CartProductModel> products;
  final double totalPrice;
  final int totalItems;
}

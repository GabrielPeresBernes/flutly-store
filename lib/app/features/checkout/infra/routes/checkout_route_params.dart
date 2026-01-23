import '../../../../core/router/router.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order.dart';

class CheckoutRouteParams extends CoreRouteParams {
  const CheckoutRouteParams({required this.order});

  factory CheckoutRouteParams.fromJson(Map<String, dynamic> data) {
    return CheckoutRouteParams(
      order: OrderModel.fromJson(
        data['order'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }

  final Order order;

  @override
  Map<String, dynamic> toJson() => {
    'order': OrderModel.fromEntity(order).toJson(),
  };
}

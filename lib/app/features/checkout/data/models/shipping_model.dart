import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/shipping.dart';

class ShippingModel {
  ShippingModel({
    required this.name,
    required this.cost,
    required this.duration,
  });

  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      name: JsonParser.parseString(json['name']),
      cost: JsonParser.parseDouble(json['cost']),
      duration: JsonParser.parseString(json['duration']),
    );
  }

  factory ShippingModel.fromEntity(Shipping shipping) {
    return ShippingModel(
      name: shipping.name,
      cost: shipping.cost,
      duration: shipping.duration,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'cost': cost,
    'duration': duration,
  };

  Shipping toEntity() => Shipping(
    name: name,
    cost: cost,
    duration: duration,
  );

  final String name;
  final double cost;
  final String duration;
}

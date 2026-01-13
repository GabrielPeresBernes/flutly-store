import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/payment_card.dart';

class PaymentCardModel {
  PaymentCardModel({
    required this.name,
    required this.last4Digits,
    required this.expirationDate,
    required this.token,
    required this.brand,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      name: JsonParser.parseString(json['name']),
      last4Digits: JsonParser.parseString(json['last4Digits']),
      expirationDate: JsonParser.parseString(json['expirationDate']),
      token: JsonParser.parseString(json['token']),
      brand: JsonParser.parseString(json['brand']),
    );
  }

  factory PaymentCardModel.fromEntity(PaymentCard entity) {
    return PaymentCardModel(
      name: entity.name,
      last4Digits: entity.last4Digits,
      expirationDate: entity.expirationDate,
      token: entity.token,
      brand: entity.brand.name,
    );
  }

  PaymentCard toEntity() => PaymentCard(
    name: name,
    last4Digits: last4Digits,
    expirationDate: expirationDate,
    token: token,
    brand: CardBrand.fromString(brand),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'last4Digits': last4Digits,
    'expirationDate': expirationDate,
    'token': token,
    'brand': brand,
  };

  final String name;
  final String last4Digits;
  final String expirationDate;
  final String token;
  final String brand;
}

enum CardBrand {
  visa('visa'),
  mastercard('mastercard'),
  unknown('unknown');

  const CardBrand(this.name);

  factory CardBrand.fromString(String brand) {
    return CardBrand.values.firstWhere(
      (e) => e.name == brand,
      orElse: () => CardBrand.unknown,
    );
  }

  final String name;
}

class PaymentCard {
  const PaymentCard({
    required this.name,
    required this.last4Digits,
    required this.expirationDate,
    required this.token,
    required this.brand,
  });

  final String name;
  final String last4Digits;
  final String expirationDate;
  final String token;
  final CardBrand brand;
}

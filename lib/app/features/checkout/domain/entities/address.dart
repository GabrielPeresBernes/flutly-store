import 'package:equatable/equatable.dart';

class Address extends Equatable {
  const Address({
    required this.title,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  final String title;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  String get fullAddress => '$street, $zipCode, $city, $country';

  @override
  List<Object?> get props => [title, street, city, state, zipCode, country];
}

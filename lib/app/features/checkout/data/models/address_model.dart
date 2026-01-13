import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/address.dart';

class AddressModel {
  const AddressModel({
    required this.title,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      title: JsonParser.parseString(json['title']),
      street: JsonParser.parseString(json['street']),
      city: JsonParser.parseString(json['city']),
      state: JsonParser.parseString(json['state']),
      zipCode: JsonParser.parseString(json['zipCode']),
      country: JsonParser.parseString(json['country']),
    );
  }

  factory AddressModel.fromEntity(Address entity) {
    return AddressModel(
      title: entity.title,
      street: entity.street,
      city: entity.city,
      state: entity.state,
      zipCode: entity.zipCode,
      country: entity.country,
    );
  }

  Address toEntity() => Address(
    title: title,
    street: street,
    city: city,
    state: state,
    zipCode: zipCode,
    country: country,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'street': street,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'country': country,
  };

  final String title;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
}

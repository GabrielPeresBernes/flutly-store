import '../../../../core/local_storage/local_storage.dart';
import '../../../../shared/utils/json_parser.dart';
import '../../domain/entities/credentials.dart';

class CredentialsModel with JsonSerializableMixin {
  const CredentialsModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.provider,
  });

  factory CredentialsModel.fromJson(Map<String, dynamic> data) =>
      CredentialsModel(
        userId: JsonParser.parseString(data['userId']),
        name: JsonParser.parseString(data['name']),
        email: JsonParser.parseString(data['email']),
        provider: JsonParser.parseString(data['provider']),
      );

  @override
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'name': name,
    'email': email,
    'provider': provider,
  };

  Credentials toEntity() => Credentials(
    userId: userId,
    name: name,
    email: email,
    provider: AuthProvider.fromString(provider),
  );

  final String userId;
  final String name;
  final String email;
  final String provider;
}

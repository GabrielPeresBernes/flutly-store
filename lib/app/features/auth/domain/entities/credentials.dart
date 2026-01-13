enum AuthProvider {
  email('email'),
  google('google'),
  apple('apple');

  const AuthProvider(this.name);

  factory AuthProvider.fromString(String value) {
    return AuthProvider.values.firstWhere(
      (provider) => provider.name == value,
      orElse: () => AuthProvider.email,
    );
  }

  final String name;
}

class Credentials {
  Credentials({
    required this.userId,
    required this.name,
    required this.email,
    required this.provider,
  });

  final String userId;
  final String name;
  final String email;
  final AuthProvider provider;
}

/// Environment configuration class.
class Env {
  static final Map<String, String> _variables = {
    'apiBaseUrl': const String.fromEnvironment('API_BASE_URL'),
    'crmBaseUrl': const String.fromEnvironment('CRM_BASE_URL'),
  };

  static String get apiBaseUrl => _variables['apiBaseUrl']!;
  static String get crmBaseUrl => _variables['crmBaseUrl']!;

  /// Validates that all required environment variables are set.
  static void validate() {
    final missing = _variables.entries
        .where((entry) => entry.value.isEmpty)
        .map((entry) => entry.key)
        .toList();

    if (missing.isNotEmpty) {
      throw StateError('Missing environment variables: ${missing.join(', ')}');
    }
  }
}

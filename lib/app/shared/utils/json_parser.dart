/// A utility class for parsing JSON values safely.
final class JsonParser {
  static String parseString(dynamic value) =>
      value is String ? value : value?.toString() ?? '';

  static String? parseStringOrNull(dynamic value) =>
      value is String ? value : value?.toString();

  static int parseInt(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;

  static int? parseIntOrNull(dynamic value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '');

  static double parseDouble(dynamic value) =>
      value is double ? value : double.tryParse(value?.toString() ?? '') ?? 0.0;

  static double? parseDoubleOrNull(dynamic value) =>
      value is double ? value : double.tryParse(value?.toString() ?? '');

  static bool parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    final v = value?.toString().trim().toLowerCase();

    if (v == 'true') {
      return true;
    }
    if (v == 'false') {
      return false;
    }

    return false;
  }

  static List<T> parseList<T>(
    dynamic value,
    T Function(dynamic item) itemParser,
  ) {
    if (value is List) {
      return value.map(itemParser).toList();
    }
    return const [];
  }

  static Map<String, dynamic> parseMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return {};
  }
}

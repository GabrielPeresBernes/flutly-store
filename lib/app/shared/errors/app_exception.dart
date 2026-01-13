/// Represents a custom application exception
class AppException implements Exception {
  AppException({
    required this.message,
    this.details,
    this.stackTrace,
  });

  final String message;
  final Object? details;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Error: $message, Details: $details';
}

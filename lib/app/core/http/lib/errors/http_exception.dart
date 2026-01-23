/// HTTP exception class to represent HTTP errors.
class HttpException implements Exception {
  HttpException(
    this.message, {
    this.statusCode,
    this.path,
  });

  final String message;
  final int? statusCode;
  final String? path;

  @override
  String toString() =>
      'HttpException: $message (Status code: $statusCode) (Path: $path)';
}

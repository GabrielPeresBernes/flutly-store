/// Defines the interface for core HTTP operations.
abstract interface class CoreHttp {
  /// Sends a GET request to the specified [path]
  /// with optional [queryParameters] and [headers].
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    required T Function(Map<String, dynamic> json) decoder,
  });

  /// Sends a POST request to the specified [path]
  /// with optional [body] and [headers].
  Future<void> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Sends a PUT request to the specified [path]
  /// with optional [body] and [headers].
  Future<void> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Sends a PATCH request to the specified [path]
  /// with optional [body] and [headers].
  Future<void> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  });

  /// Sends a DELETE request to the specified [path]
  /// with optional [headers].
  Future<void> delete(
    String path, {
    Map<String, String>? headers,
  });
}

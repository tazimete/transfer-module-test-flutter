/// Configuration constants and defaults for network operations.
class NetworkConfig {
  NetworkConfig._();

  /// Default fixed Base URL for the API (updated to live mock server).
  static const String baseUrl = 'http://15.232.228.139/api/';

  /// Connection timeout duration (used to detect weak network / slow initial handshake).
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Receive timeout duration.
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Send timeout duration (increased threshold for multi-part file uploads).
  static const Duration sendTimeout = Duration(seconds: 120);

  /// Default HTTP headers.
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };
}

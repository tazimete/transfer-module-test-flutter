/// Configuration constants and defaults for network operations.
class NetworkConfig {
  NetworkConfig._();

  /// Default fixed Base URL for the API.
  static const String baseUrl = 'https://api.example.com/api/v1/';

  /// Connection timeout duration (used to detect weak network / slow initial handshake).
  static const Duration connectTimeout = Duration(seconds: 15);

  /// Receive timeout duration.
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Send timeout duration (increased threshold for multi-part file uploads).
  static const Duration sendTimeout = Duration(seconds: 60);

  /// Default HTTP headers.
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

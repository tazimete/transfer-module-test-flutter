import 'package:dio/dio.dart';

/// Base custom exception for network operations.
abstract class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const NetworkException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() => 'NetworkException: $message (StatusCode: $statusCode)';
}

/// Thrown when no active internet connection is detected.
class NoInternetException extends NetworkException {
  const NoInternetException([super.message = 'No active internet connection available']);
}

/// Thrown when a weak network or connection timeout occurs.
class WeakNetworkException extends NetworkException {
  const WeakNetworkException([super.message = 'Weak network connection detected. Request timed out.']);
}

/// Thrown when user authentication is missing or expired (401/403).
class UnauthorizedException extends NetworkException {
  const UnauthorizedException([
    super.message = 'User is not authenticated or session has expired',
    int? statusCode = 401,
  ]) : super(statusCode: statusCode);
}

/// Thrown when the server returns a non-2xx status code.
class ServerResponseException extends NetworkException {
  const ServerResponseException(super.message, {super.statusCode, super.errorData});
}

/// Helper extension mapping [DioException] to domain [NetworkException].
extension DioExceptionExtension on DioException {
  NetworkException toNetworkException() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const WeakNetworkException();
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.badResponse:
        final code = response?.statusCode;
        if (code == 401 || code == 403) {
          return UnauthorizedException(
            response?.statusMessage ?? 'Unauthorized access',
            code,
          );
        }
        return ServerResponseException(
          response?.statusMessage ?? 'Server error ($code)',
          statusCode: code,
          errorData: response?.data,
        );
      case DioExceptionType.cancel:
        return const ServerResponseException('Request was cancelled');
      default:
        return ServerResponseException(
          message ?? 'An unexpected network error occurred',
          errorData: error,
        );
    }
  }
}

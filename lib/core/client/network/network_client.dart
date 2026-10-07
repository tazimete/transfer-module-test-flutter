import 'dart:io';
import 'package:dio/dio.dart';

/// Payload helper for multi-part file uploads.
class MultiPartFilePayload {
  final String fieldName;
  final File? file;
  final List<int>? bytes;
  final String? filename;

  MultiPartFilePayload.fromFile({
    required this.fieldName,
    required this.file,
    this.filename,
  }) : bytes = null;

  MultiPartFilePayload.fromBytes({
    required this.fieldName,
    required this.bytes,
    required this.filename,
  }) : file = null;
}

/// Abstract network client contract for testability and dependency injection.
abstract class INetworkClient {
  /// Returns the base URL of the network client.
  String get baseUrl;

  /// Exposes the underlying [Dio] instance for Retrofit or custom configurations.
  Dio get dio;

  /// Executes an HTTP GET request against a relative [endpoint].
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });

  /// Executes an HTTP POST request against a relative [endpoint].
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  /// Executes an HTTP PUT request against a relative [endpoint].
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  /// Executes an HTTP PATCH request against a relative [endpoint].
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });

  /// Executes an HTTP DELETE request against a relative [endpoint].
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });

  /// Executes a multi-part upload request with files and form data to a relative [endpoint].
  Future<Response<T>> uploadMultiPart<T>(
    String endpoint, {
    required List<MultiPartFilePayload> files,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  });
}

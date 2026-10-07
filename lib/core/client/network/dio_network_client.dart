import 'package:dio/dio.dart';
import 'auth_session.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/weak_network_interceptor.dart';
import 'network_client.dart';
import 'network_config.dart';
import 'network_exception.dart';

/// Modular, production-ready implementation of [INetworkClient] powered by [Dio].
class DioNetworkClient implements INetworkClient {
  final Dio _dio;
  final String _baseUrl;

  DioNetworkClient({
    Dio? dio,
    AuthSession? authSession,
    String? baseUrl,
    List<Interceptor>? additionalInterceptors,
    bool enableLogging = true,
  })  : _baseUrl = baseUrl ?? NetworkConfig.baseUrl,
        _dio = dio ?? Dio() {
    _configureDio(authSession, additionalInterceptors, enableLogging);
  }

  void _configureDio(
    AuthSession? authSession,
    List<Interceptor>? additionalInterceptors,
    bool enableLogging,
  ) {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: NetworkConfig.connectTimeout,
      receiveTimeout: NetworkConfig.receiveTimeout,
      sendTimeout: NetworkConfig.sendTimeout,
      headers: Map.from(NetworkConfig.defaultHeaders),
    );

    // Attach interceptors in logical order
    _dio.interceptors.add(WeakNetworkInterceptor());

    if (authSession != null) {
      _dio.interceptors.add(AuthInterceptor(authSession: authSession));
    }

    if (additionalInterceptors != null) {
      _dio.interceptors.addAll(additionalInterceptors);
    }

    if (enableLogging) {
      _dio.interceptors.add(createLoggingInterceptor());
    }
  }

  @override
  String get baseUrl => _baseUrl;

  @override
  Dio get dio => _dio;

  @override
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw e.toNetworkException();
    }
  }

  @override
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw e.toNetworkException();
    }
  }

  @override
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw e.toNetworkException();
    }
  }

  @override
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw e.toNetworkException();
    }
  }

  @override
  Future<Response<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.toNetworkException();
    }
  }

  @override
  Future<Response<T>> uploadMultiPart<T>(
    String endpoint, {
    required List<MultiPartFilePayload> files,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final formDataMap = <String, dynamic>{};

      if (fields != null) {
        formDataMap.addAll(fields);
      }

      for (final filePayload in files) {
        if (filePayload.file != null) {
          final multipartFile = await MultipartFile.fromFile(
            filePayload.file!.path,
            filename: filePayload.filename,
          );
          formDataMap[filePayload.fieldName] = multipartFile;
        } else if (filePayload.bytes != null) {
          final multipartFile = MultipartFile.fromBytes(
            filePayload.bytes!,
            filename: filePayload.filename ?? 'file',
          );
          formDataMap[filePayload.fieldName] = multipartFile;
        }
      }

      final formData = FormData.fromMap(formDataMap);

      return await _dio.post<T>(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw e.toNetworkException();
    }
  }
}

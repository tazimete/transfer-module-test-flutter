import 'package:dio/dio.dart';
import '../network_exception.dart';

/// Interceptor that monitors network stability, handles connection timeouts,
/// and retries requests under weak network conditions.
class WeakNetworkInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  WeakNetworkInterceptor({
    this.maxRetries = 2,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isWeakNetworkError(err)) {
      final int currentRetry = err.requestOptions.extra['retryCount'] as int? ?? 0;

      if (currentRetry < maxRetries) {
        err.requestOptions.extra['retryCount'] = currentRetry + 1;
        await Future.delayed(retryDelay * (currentRetry + 1));

        try {
          final dio = Dio(BaseOptions(
            connectTimeout: err.requestOptions.connectTimeout,
            receiveTimeout: err.requestOptions.receiveTimeout,
            sendTimeout: err.requestOptions.sendTimeout,
          ));

          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryError) {
          return handler.next(_wrapWeakNetworkError(retryError));
        } catch (_) {
          return handler.next(_wrapWeakNetworkError(err));
        }
      }

      return handler.next(_wrapWeakNetworkError(err));
    }

    return handler.next(err);
  }

  bool _isWeakNetworkError(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }

  DioException _wrapWeakNetworkError(DioException err) {
    return DioException(
      requestOptions: err.requestOptions,
      error: const WeakNetworkException(),
      type: DioExceptionType.connectionTimeout,
      response: err.response,
    );
  }
}

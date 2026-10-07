import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Utility function creating a clean logger interceptor using [PrettyDioLogger].
PrettyDioLogger createLoggingInterceptor({bool enabled = true}) {
  return PrettyDioLogger(
    requestHeader: enabled,
    requestBody: enabled,
    responseHeader: false,
    responseBody: enabled,
    error: enabled,
    compact: true,
    maxWidth: 90,
  );
}

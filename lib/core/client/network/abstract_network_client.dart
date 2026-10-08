import 'dart:io';
import 'package:dio/dio.dart';

class MultiPartFilePayload {
  final String fieldName;
  final File? file;
  final List<int>? bytes;
  final String? filename;

  MultiPartFilePayload.fromFile({required this.fieldName, required this.file, this.filename}) : bytes = null;
  MultiPartFilePayload.fromBytes({required this.fieldName, required this.bytes, required this.filename}) : file = null;
}

/// Abstract network client contract.
abstract class AbstractNetworkClient {
  String get baseUrl;
  Dio get dio;

  Future<Response<T>> get<T>(String endpoint, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiveProgress});
  Future<Response<T>> post<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress});
  Future<Response<T>> put<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress});
  Future<Response<T>> patch<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress});
  Future<Response<T>> delete<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken});
  Future<Response<T>> uploadMultiPart<T>(String endpoint, {required List<MultiPartFilePayload> files, Map<String, dynamic>? fields, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress});
}

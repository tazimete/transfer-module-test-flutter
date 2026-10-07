import 'dart:io';
import 'package:dio/dio.dart';
import 'network_client.dart';

/// Modular API Service demonstrating endpoint consumption, fixed base URL utilization,
/// and multi-part file request capabilities.
class ApiService {
  final INetworkClient _networkClient;

  ApiService(this._networkClient);

  /// Returns the fixed base URL used across all endpoints.
  String get baseUrl => _networkClient.baseUrl;

  /// GET request with query parameters (e.g. `/transfers?page=1&limit=20`).
  Future<Response<dynamic>> getItems({
    required String endpoint,
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? queryParameters,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (queryParameters != null) ...queryParameters,
    };
    return await _networkClient.get(endpoint, queryParameters: params);
  }

  /// GET request for a specific item by ID (e.g. `/transfers/123`).
  Future<Response<dynamic>> getItemById({
    required String endpoint,
    required String id,
  }) async {
    return await _networkClient.get('$endpoint/$id');
  }

  /// POST request to submit JSON body payload (e.g. `/transfers`).
  Future<Response<dynamic>> createItem({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    return await _networkClient.post(endpoint, data: data);
  }

  /// Multi-part upload request support for sending files and text form fields.
  Future<Response<dynamic>> uploadFile({
    required String endpoint,
    required File file,
    required String fileFieldName,
    Map<String, dynamic>? fields,
    ProgressCallback? onSendProgress,
  }) async {
    final payload = MultiPartFilePayload.fromFile(
      fieldName: fileFieldName,
      file: file,
    );
    return await _networkClient.uploadMultiPart(
      endpoint,
      files: [payload],
      fields: fields,
      onSendProgress: onSendProgress,
    );
  }
}

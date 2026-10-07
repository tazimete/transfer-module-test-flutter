import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transfermodule/core/client/network/network.dart';

class MockNetworkClient implements INetworkClient {
  bool getCalled = false;
  bool uploadCalled = false;

  @override
  String get baseUrl => 'https://mock.api.com/';

  @override
  Dio get dio => Dio();

  @override
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    getCalled = true;
    return Response<T>(
      requestOptions: RequestOptions(path: endpoint),
      statusCode: 200,
      data: {'status': 'success', 'items': []} as T,
    );
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
    uploadCalled = true;

    // Simulate progress updates
    onSendProgress?.call(50, 100);
    onSendProgress?.call(100, 100);

    return Response<T>(
      requestOptions: RequestOptions(path: endpoint),
      statusCode: 201,
      data: {'status': 'uploaded', 'fileId': '99'} as T,
    );
  }

  @override
  Future<Response<T>> delete<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async => throw UnimplementedError();

  @override
  Future<Response<T>> patch<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) async => throw UnimplementedError();

  @override
  Future<Response<T>> post<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) async => throw UnimplementedError();

  @override
  Future<Response<T>> put<T>(String endpoint, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onSendProgress, ProgressCallback? onReceiveProgress}) async => throw UnimplementedError();
}

void main() {
  late MockNetworkClient mockClient;
  late NetworkClientExample example;

  setUp(() {
    mockClient = MockNetworkClient();
    example = NetworkClientExample(client: mockClient);
  });

  test('fetchTransferHistory executes GET request with parameters', () async {
    await example.fetchTransferHistory(page: 1, limit: 5);
    expect(mockClient.getCalled, true);
  });

  test('uploadFileWithProgress executes multi-part file upload with progress listener', () async {
    final tempFile = File('${Directory.systemTemp.path}/test_upload.txt');
    await tempFile.writeAsString('Test file content');

    double lastReportedPercentage = 0.0;
    await example.uploadFileWithProgress(
      file: tempFile,
      fileFieldName: 'file',
      title: 'Test Document',
      onProgress: (percentage) {
        lastReportedPercentage = percentage;
      },
    );

    expect(mockClient.uploadCalled, true);
    expect(lastReportedPercentage, 100.0);

    if (await tempFile.exists()) {
      await tempFile.delete();
    }
  });
}

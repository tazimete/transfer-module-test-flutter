import 'dart:developer';
import 'dart:io';

import 'auth_session.dart';
import 'dio_network_client.dart';
import 'network_client.dart';
import 'network_exception.dart';

/// Complete, self-contained example demonstrating GET requests and multi-part file uploads
/// with upload progress tracking, custom interceptors, and error handling.
class NetworkClientExample {
  final INetworkClient networkClient;

  NetworkClientExample({INetworkClient? client, AuthSession? authSession})
      : networkClient = client ??
            DioNetworkClient(
              authSession: authSession ??
                  InMemoryAuthSession(
                    isLoggedIn: true,
                    authToken: 'sample_jwt_bearer_token_12345',
                    onUnauthenticated: () {
                      log('User session expired or unauthorized. Redirecting to login...');
                    },
                  ),
              enableLogging: true,
            );

  /// Example 1: Executing a GET request with query parameters and custom error handling.
  Future<void> fetchTransferHistory({
    int page = 1,
    int limit = 10,
    String status = 'pending',
  }) async {
    try {
      log('--> Fetching transfer history (Page: $page, Status: $status)');

      final response = await networkClient.get<Map<String, dynamic>>(
        '/transfers',
        queryParameters: {
          'page': page,
          'limit': limit,
          'status': status,
        },
      );

      log('<-- Transfer history fetched successfully! Status code: ${response.statusCode}');
      log('Data: ${response.data}');
    } on NetworkException catch (e) {
      log('Network Error encountered while fetching transfers: ${e.message} (Code: ${e.statusCode})');
    } catch (e) {
      log('Unexpected Error: $e');
    }
  }

  /// Example 2: Executing a Multi-part form request to upload files with real-time progress.
  Future<void> uploadFileWithProgress({
    required File file,
    required String fileFieldName,
    String? title,
    String? description,
    void Function(double progressPercentage)? onProgress,
  }) async {
    try {
      log('--> Starting multi-part file upload for: ${file.path}');

      final payload = MultiPartFilePayload.fromFile(
        fieldName: fileFieldName,
        file: file,
        filename: file.path.split(Platform.pathSeparator).last,
      );

      final response = await networkClient.uploadMultiPart<Map<String, dynamic>>(
        '/transfers/upload',
        files: [payload],
        fields: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          'timestamp': DateTime.now().toIso8601String(),
        },
        onSendProgress: (int count, int total) {
          if (total > 0) {
            final double percentage = (count / total) * 100;
            log('Upload Progress: ${percentage.toStringAsFixed(1)}% ($count / $total bytes)');
            onProgress?.call(percentage);
          }
        },
      );

      log('<-- File upload complete! Status code: ${response.statusCode}');
      log('Response Data: ${response.data}');
    } on NetworkException catch (e) {
      log('Upload Network Error: ${e.message} (Code: ${e.statusCode})');
    } catch (e) {
      log('Upload Error: $e');
    }
  }
}

/// Runnable entrypoint to execute the example scenario.
Future<void> runNetworkClientExample() async {
  final example = NetworkClientExample();

  log('--- Running GET Request Example ---');
  await example.fetchTransferHistory(page: 1, limit: 10, status: 'completed');

  log('--- Running Multi-part Upload Request Example ---');
  // Create a temporary sample file for demonstration
  final tempDir = Directory.systemTemp;
  final tempFile = File('${tempDir.path}/sample_document.pdf');
  await tempFile.writeAsString('Sample PDF content for file upload test');

  await example.uploadFileWithProgress(
    file: tempFile,
    fileFieldName: 'document',
    title: 'Transfer Proof Document',
    description: 'Receipt copy for transfer #10092',
    onProgress: (percentage) {
      // Progress update listener callback
    },
  );

  if (await tempFile.exists()) {
    await tempFile.delete();
  }
}

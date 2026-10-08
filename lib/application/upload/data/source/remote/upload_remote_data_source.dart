import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../../core/client/network/abstract_network_client.dart';
import '../../entity/upload_response_model.dart';
import 'abstract_upload_remote_data_source.dart';

class UploadRemoteDataSource implements AbstractUploadRemoteDataSource {
  final AbstractNetworkClient networkClient;

  UploadRemoteDataSource({required this.networkClient});

  @override
  Future<UploadResponseModel> uploadFile({
    required File file,
    required String fieldName,
    ProgressCallback? onSendProgress,
  }) async {
    final payload = MultiPartFilePayload.fromFile(
      fieldName: fieldName,
      file: file,
    );

    final response = await networkClient.uploadMultiPart<Map<String, dynamic>>(
      'upload',
      files: [payload],
      onSendProgress: onSendProgress,
    );

    final data = response.data;
    if (data == null) {
      return const UploadResponseModel(message: 'File uploaded successfully', success: true);
    }
    return UploadResponseModel.fromJson(data);
  }
}

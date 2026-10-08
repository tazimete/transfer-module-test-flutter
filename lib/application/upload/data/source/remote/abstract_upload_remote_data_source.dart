import 'dart:io';
import 'package:dio/dio.dart';
import '../../entity/upload_response_model.dart';

abstract class AbstractUploadRemoteDataSource {
  Future<UploadResponseModel> uploadFile({
    required File file,
    required String fieldName,
    ProgressCallback? onSendProgress,
  });
}

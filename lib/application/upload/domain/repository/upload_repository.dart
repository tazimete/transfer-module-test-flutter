import 'dart:io';
import 'package:dio/dio.dart';
import '../entity/upload_entity.dart';

abstract class UploadRepository {
  Future<UploadEntity> uploadFile({
    required File file,
    required String fieldName,
    ProgressCallback? onSendProgress,
  });
}

import 'dart:io';
import 'package:dio/dio.dart';
import '../entity/upload_entity.dart';

abstract class AbstractUploadRepository {
  Future<UploadEntity> uploadFile({
    required File file,
    required String fieldName,
    ProgressCallback? onSendProgress,
  });
}

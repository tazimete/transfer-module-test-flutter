import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../foundation/base/base_usecase.dart';
import '../entity/upload_entity.dart';
import '../repository/abstract_upload_repository.dart';

class UploadFileParams {
  final File file;
  final String fieldName;
  final ProgressCallback? onSendProgress;

  const UploadFileParams({
    required this.file,
    this.fieldName = 'file',
    this.onSendProgress,
  });
}

class UploadFileUseCase extends BaseUseCaseParam<UploadFileParams, UploadEntity> {
  final AbstractUploadRepository repository;

  UploadFileUseCase({required this.repository});

  @override
  Future<UploadEntity> invoke(UploadFileParams params) async {
    return await repository.uploadFile(
      file: params.file,
      fieldName: params.fieldName,
      onSendProgress: params.onSendProgress,
    );
  }
}

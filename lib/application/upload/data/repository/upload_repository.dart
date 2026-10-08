import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/entity/upload_entity.dart';
import '../../domain/repository/abstract_upload_repository.dart';
import '../source/remote/abstract_upload_remote_data_source.dart';

class UploadRepository implements AbstractUploadRepository {
  final AbstractUploadRemoteDataSource remoteDataSource;

  UploadRepository({required this.remoteDataSource});

  @override
  Future<UploadEntity> uploadFile({
    required File file,
    required String fieldName,
    ProgressCallback? onSendProgress,
  }) async {
    final model = await remoteDataSource.uploadFile(
      file: file,
      fieldName: fieldName,
      onSendProgress: onSendProgress,
    );
    return model.toDomain();
  }
}

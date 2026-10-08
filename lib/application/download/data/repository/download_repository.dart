import 'package:dio/dio.dart';
import '../../domain/repository/abstract_download_repository.dart';
import '../source/remote/download_remote_data_source.dart';

class DownloadRepository implements AbstractDownloadRepository {
  final AbstractDownloadRemoteDataSource remoteDataSource;

  DownloadRepository({required this.remoteDataSource});

  @override
  Future<void> downloadFile({
    required String fileUrl,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    await remoteDataSource.downloadFile(
      fileUrl: fileUrl,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

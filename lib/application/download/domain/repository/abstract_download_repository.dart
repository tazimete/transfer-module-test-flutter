import 'package:dio/dio.dart';

abstract class AbstractDownloadRepository {
  Future<void> downloadFile({
    required String fileUrl,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  });
}

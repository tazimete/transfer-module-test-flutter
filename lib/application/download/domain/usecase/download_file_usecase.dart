import 'package:dio/dio.dart';
import '../../../../foundation/base/base_usecase.dart';
import '../repository/abstract_download_repository.dart';

class DownloadFileParams {
  final String fileUrl;
  final String savePath;
  final ProgressCallback? onReceiveProgress;

  const DownloadFileParams({
    required this.fileUrl,
    required this.savePath,
    this.onReceiveProgress,
  });
}

class DownloadFileUseCase extends BaseUseCaseParam<DownloadFileParams, void> {
  final AbstractDownloadRepository repository;

  DownloadFileUseCase({required this.repository});

  @override
  Future<void> invoke(DownloadFileParams params) async {
    return await repository.downloadFile(
      fileUrl: params.fileUrl,
      savePath: params.savePath,
      onReceiveProgress: params.onReceiveProgress,
    );
  }
}

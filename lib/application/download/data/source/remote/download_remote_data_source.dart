import 'package:dio/dio.dart';
import '../../../../../../core/client/network/abstract_network_client.dart';

abstract class AbstractDownloadRemoteDataSource {
  Future<void> downloadFile({
    required String fileUrl,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  });
}

class DownloadRemoteDataSource implements AbstractDownloadRemoteDataSource {
  final AbstractNetworkClient networkClient;

  DownloadRemoteDataSource({required this.networkClient});

  @override
  Future<void> downloadFile({
    required String fileUrl,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    String targetUrl = fileUrl;
    if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
      targetUrl = '${networkClient.baseUrl}$fileUrl';
    }

    await networkClient.dio.download(
      targetUrl,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

import '../../../../../../core/client/network/abstract_network_client.dart';
import '../../entity/file_item_model.dart';

abstract class AbstractFileRemoteDataSource {
  Future<List<FileItemModel>> getUploadedFiles();
}

class FileRemoteDataSource implements AbstractFileRemoteDataSource {
  final AbstractNetworkClient networkClient;

  FileRemoteDataSource({required this.networkClient});

  @override
  Future<List<FileItemModel>> getUploadedFiles() async {
    final response = await networkClient.get<dynamic>('get');
    final data = response.data;

    if (data == null) {
      return [];
    }

    if (data is List) {
      return data.map((item) => FileItemModel.fromJson(item as Map<String, dynamic>)).toList();
    } else if (data is Map<String, dynamic>) {
      final list = data['files'] ?? data['data'] ?? data['result'] ?? data['items'];
      if (list is List) {
        return list.map((item) => FileItemModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    }

    return [];
  }
}

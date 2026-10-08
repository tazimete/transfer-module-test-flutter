import '../../domain/entity/file_item_entity.dart';
import '../../domain/repository/abstract_file_repository.dart';
import '../source/remote/file_remote_data_source.dart';

class FileRepository implements AbstractFileRepository {
  final AbstractFileRemoteDataSource remoteDataSource;

  FileRepository({required this.remoteDataSource});

  @override
  Future<List<FileItemEntity>> getUploadedFiles() async {
    final models = await remoteDataSource.getUploadedFiles();
    return models.map((m) => m.toDomain()).toList();
  }
}

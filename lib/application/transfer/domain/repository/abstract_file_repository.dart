import '../entity/file_item_entity.dart';

abstract class AbstractFileRepository {
  Future<List<FileItemEntity>> getUploadedFiles();
}

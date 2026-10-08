import '../../../../foundation/base/base_usecase.dart';
import '../entity/file_item_entity.dart';
import '../repository/abstract_file_repository.dart';

class GetUploadedFilesUseCase extends BaseUseCase<List<FileItemEntity>> {
  final AbstractFileRepository repository;

  GetUploadedFilesUseCase({required this.repository});

  @override
  Future<List<FileItemEntity>> invoke() async {
    return await repository.getUploadedFiles();
  }
}

import '../../domain/entity/file_item_entity.dart';
import '../../domain/usecase/get_uploaded_files_usecase.dart';
import '../../../../foundation/base/base_viewmodel.dart';

class TransferHistoryViewModel extends BaseViewModel {
  final GetUploadedFilesUseCase _getUploadedFilesUseCase;

  List<FileItemEntity> _files = [];
  bool _isLoadingFiles = false;
  String? _errorMessage;

  List<FileItemEntity> get files => _files;
  bool get isLoadingFiles => _isLoadingFiles;
  String? get errorMessage => _errorMessage;

  TransferHistoryViewModel({
    required GetUploadedFilesUseCase getUploadedFilesUseCase,
  }) : _getUploadedFilesUseCase = getUploadedFilesUseCase;

  @override
  Future<void> init() async {
    await fetchUploadedFiles();
  }

  Future<void> fetchUploadedFiles() async {
    _isLoadingFiles = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _files = await _getUploadedFilesUseCase.invoke();
      _isLoadingFiles = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoadingFiles = false;
      _errorMessage = 'Failed to load uploaded files: $e';
      notifyListeners();
    }
  }
}

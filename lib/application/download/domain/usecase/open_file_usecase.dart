import 'package:open_filex/open_filex.dart';
import '../../../../foundation/base/base_usecase.dart';

class OpenFileParams {
  final String filePath;
  const OpenFileParams({required this.filePath});
}

/// UseCase responsible for opening a downloaded file using device intent / native viewer.
class OpenFileUseCase extends BaseUseCaseParam<OpenFileParams, void> {
  @override
  Future<void> invoke(OpenFileParams params) async {
    await OpenFilex.open(params.filePath);
  }
}

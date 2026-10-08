import '../../../../core/client/preference/preference_manager.dart';
import '../../../../core/client/preference/shared_preferences_client.dart';
import '../../../../core/services/download_service.dart';
import '../../presentation/viewmodel/download_file_viewmodel.dart';
import '../../../upload/domain/utility/abstract_view_model_builder.dart';

class DownloadFileViewModelBuilder implements AbstractViewModelBuilder<DownloadFileViewModel> {
  final String? fileUrl;
  final String? fileName;

  DownloadFileViewModelBuilder({this.fileUrl, this.fileName});

  @override
  DownloadFileViewModel build() {
    final preferenceClient = SharedPreferencesClient();
    final preferenceManager = PreferenceManager(preferenceClient: preferenceClient);
    final downloadService = DownloadService();

    return DownloadFileViewModel(
      downloadService: downloadService,
      preferenceManager: preferenceManager,
      initialFileUrl: fileUrl,
      initialFileName: fileName,
    );
  }
}

import '../../../../core/client/network/dio_network_client.dart';
import '../../../../core/client/preference/preference_manager.dart';
import '../../../../core/client/preference/shared_preferences_client.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/repository/download_repository.dart';
import '../../data/source/remote/download_remote_data_source.dart';
import '../../presentation/viewmodel/download_file_viewmodel.dart';
import '../usecase/download_file_usecase.dart';
import '../usecase/open_file_usecase.dart';
import '../../../upload/domain/utility/abstract_view_model_builder.dart';

class DownloadFileViewModelBuilder implements AbstractViewModelBuilder<DownloadFileViewModel> {
  final String? fileUrl;
  final String? fileName;

  DownloadFileViewModelBuilder({this.fileUrl, this.fileName});

  @override
  DownloadFileViewModel build() {
    final preferenceClient = SharedPreferencesClient();
    final preferenceManager = PreferenceManager(preferenceClient: preferenceClient);

    final networkClient = DioNetworkClient(
      authSession: preferenceManager,
      enableLogging: true,
    );

    final remoteDataSource = DownloadRemoteDataSource(networkClient: networkClient);
    final repository = DownloadRepository(remoteDataSource: remoteDataSource);
    final downloadFileUseCase = DownloadFileUseCase(repository: repository);
    final openFileUseCase = OpenFileUseCase();
    final notificationService = NotificationService();

    return DownloadFileViewModel(
      downloadFileUseCase: downloadFileUseCase,
      openFileUseCase: openFileUseCase,
      notificationService: notificationService,
      initialFileUrl: fileUrl,
      initialFileName: fileName,
    );
  }
}

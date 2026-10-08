import '../../../../core/client/network/dio_network_client.dart';
import '../../../../core/client/preference/preference_manager.dart';
import '../../../../core/client/preference/shared_preferences_client.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/repository/upload_repository.dart';
import '../../data/source/remote/upload_remote_data_source.dart';
import '../../presentation/viewmodel/upload_file_viewmodel.dart';
import '../usecase/upload_file_usecase.dart';
import 'abstract_view_model_builder.dart';

/// Builder class responsible for assembling dependencies for [UploadFileViewModel].
class UploadFileViewModelBuilder implements AbstractViewModelBuilder<UploadFileViewModel> {
  @override
  UploadFileViewModel build() {
    final preferenceClient = SharedPreferencesClient();
    final preferenceManager = PreferenceManager(preferenceClient: preferenceClient);

    // Pass preferenceManager as authSession so AuthInterceptor automatically attaches Bearer token to requests
    final networkClient = DioNetworkClient(
      authSession: preferenceManager,
      enableLogging: true,
    );

    final uploadRemoteDataSource = UploadRemoteDataSource(networkClient: networkClient);
    final uploadRepository = UploadRepository(remoteDataSource: uploadRemoteDataSource);
    final uploadFileUseCase = UploadFileUseCase(repository: uploadRepository);
    final notificationService = NotificationService();

    return UploadFileViewModel(
      uploadFileUseCase: uploadFileUseCase,
      preferenceManager: preferenceManager,
      notificationService: notificationService,
    );
  }
}

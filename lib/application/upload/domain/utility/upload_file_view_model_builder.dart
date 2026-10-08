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
    final networkClient = DioNetworkClient(enableLogging: true);
    final preferenceClient = SharedPreferencesClient();
    final preferenceManager = PreferenceManager(preferenceClient: preferenceClient);

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

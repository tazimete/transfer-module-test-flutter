import '../../../../core/client/network/dio_network_client.dart';
import '../../../../core/client/preference/preference_manager.dart';
import '../../../../core/client/preference/shared_preferences_client.dart';
import '../../../transfer/data/repository/file_repository.dart';
import '../../../transfer/data/source/remote/file_remote_data_source.dart';
import '../../../transfer/domain/usecase/get_uploaded_files_usecase.dart';
import '../../../transfer/presentation/viewmodel/dashboard_viewmodel.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/source/remote/auth_remote_data_source.dart';
import '../usecase/authenticate_usecase.dart';
import '../usecase/check_auth_status_usecase.dart';
import 'abstract_view_model_builder.dart';

/// Builder class responsible for assembling dependencies for [DashboardViewmodel].
class DashboardViewModelBuilder implements AbstractViewModelBuilder<DashboardViewmodel> {
  @override
  DashboardViewmodel build() {
    final preferenceClient = SharedPreferencesClient();
    final preferenceManager = PreferenceManager(preferenceClient: preferenceClient);

    final networkClient = DioNetworkClient(
      authSession: preferenceManager,
      enableLogging: true,
    );

    final authRemoteDataSource = AuthRemoteDataSource(networkClient: networkClient);
    final authRepository = AuthRepository(remoteDataSource: authRemoteDataSource);

    final fileRemoteDataSource = FileRemoteDataSource(networkClient: networkClient);
    final fileRepository = FileRepository(remoteDataSource: fileRemoteDataSource);

    final checkAuthStatusUseCase = CheckAuthStatusUseCase(preferenceManager: preferenceManager);
    final authenticateUseCase = AuthenticateUseCase(repository: authRepository);
    final getUploadedFilesUseCase = GetUploadedFilesUseCase(repository: fileRepository);

    return DashboardViewmodel(
      checkAuthStatusUseCase: checkAuthStatusUseCase,
      authenticateUseCase: authenticateUseCase,
      getUploadedFilesUseCase: getUploadedFilesUseCase,
      preferenceManager: preferenceManager,
    );
  }
}

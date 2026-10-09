import '../../../../core/client/network/dio_network_client.dart';
import '../../../../core/client/preference/preference_manager.dart';
import '../../../../core/client/preference/shared_preferences_client.dart';
import '../../../upload/domain/utility/abstract_view_model_builder.dart';
import '../../data/repository/file_repository.dart';
import '../../data/source/remote/file_remote_data_source.dart';
import '../../domain/usecase/get_uploaded_files_usecase.dart';
import '../../presentation/viewmodel/transfer_history_viewmodel.dart';

class TransferHistoryViewModelBuilder implements AbstractViewModelBuilder<TransferHistoryViewModel> {
  @override
  TransferHistoryViewModel build() {
    final preferenceClient = SharedPreferencesClient();
    final preferenceManager = PreferenceManager(preferenceClient: preferenceClient);

    final networkClient = DioNetworkClient(
      authSession: preferenceManager,
      enableLogging: true,
    );

    final fileRemoteDataSource = FileRemoteDataSource(networkClient: networkClient);
    final fileRepository = FileRepository(remoteDataSource: fileRemoteDataSource);
    final getUploadedFilesUseCase = GetUploadedFilesUseCase(repository: fileRepository);

    return TransferHistoryViewModel(
      getUploadedFilesUseCase: getUploadedFilesUseCase,
    );
  }
}

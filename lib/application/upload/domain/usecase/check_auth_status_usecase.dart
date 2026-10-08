import '../../../../core/client/preference/abstract_preference_manager.dart';
import '../../../../foundation/base/base_usecase.dart';

class CheckAuthStatusUseCase extends BaseUseCase<bool> {
  final AbstractPreferenceManager preferenceManager;

  CheckAuthStatusUseCase({required this.preferenceManager});

  @override
  Future<bool> invoke() async {
    return await preferenceManager.isLoggedIn;
  }
}

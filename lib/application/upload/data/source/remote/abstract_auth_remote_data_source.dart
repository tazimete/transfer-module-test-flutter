import '../../entity/token_model.dart';

abstract class AbstractAuthRemoteDataSource {
  Future<TokenModel> authenticate(String username, String password);
}

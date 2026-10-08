import '../../../../foundation/base/base_usecase.dart';
import '../entity/token_entity.dart';
import '../repository/abstract_auth_repository.dart';

class AuthenticateParams {
  final String username;
  final String password;

  const AuthenticateParams({
    required this.username,
    required this.password,
  });
}

class AuthenticateUseCase extends BaseUseCaseParam<AuthenticateParams, TokenEntity> {
  final AbstractAuthRepository repository;

  AuthenticateUseCase({required this.repository});

  @override
  Future<TokenEntity> invoke(AuthenticateParams params) async {
    return await repository.authenticate(params.username, params.password);
  }
}

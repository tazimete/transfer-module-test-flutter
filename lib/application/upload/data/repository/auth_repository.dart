import '../../domain/entity/token_entity.dart';
import '../../domain/repository/abstract_auth_repository.dart';
import '../source/remote/abstract_auth_remote_data_source.dart';

class AuthRepository implements AbstractAuthRepository {
  final AbstractAuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  @override
  Future<TokenEntity> authenticate(String username, String password) async {
    final tokenModel = await remoteDataSource.authenticate(username, password);
    return tokenModel.toDomain();
  }
}

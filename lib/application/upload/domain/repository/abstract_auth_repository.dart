import '../entity/token_entity.dart';

abstract class AbstractAuthRepository {
  Future<TokenEntity> authenticate(String username, String password);
}

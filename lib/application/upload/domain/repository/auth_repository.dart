import '../entity/token_entity.dart';

abstract class AuthRepository {
  Future<TokenEntity> authenticate(String username, String password);
  Future<bool> isUserLoggedIn();
}

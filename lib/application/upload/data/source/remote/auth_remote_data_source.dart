import 'package:dio/dio.dart';
import '../../../../../../core/client/network/abstract_network_client.dart';
import '../../entity/token_model.dart';
import 'abstract_auth_remote_data_source.dart';

class AuthRemoteDataSource implements AbstractAuthRemoteDataSource {
  final AbstractNetworkClient networkClient;

  AuthRemoteDataSource({required this.networkClient});

  @override
  Future<TokenModel> authenticate(String username, String password) async {
    final response = await networkClient.post<Map<String, dynamic>>(
      'token',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    final data = response.data;
    if (data == null) {
      throw Exception('Empty response from authentication server');
    }
    return TokenModel.fromJson(data);
  }
}

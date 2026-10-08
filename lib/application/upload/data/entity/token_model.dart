import '../../domain/entity/token_entity.dart';

class TokenModel {
  final String? accessToken;
  final String? tokenType;
  final String? token;

  const TokenModel({
    this.accessToken,
    this.tokenType,
    this.token,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] as String?,
      tokenType: json['token_type'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'token': token,
    };
  }

  TokenEntity toDomain() {
    return TokenEntity(
      accessToken: accessToken ?? token ?? '',
      tokenType: tokenType ?? 'Bearer',
    );
  }
}

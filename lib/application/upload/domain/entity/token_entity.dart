/// Domain entity representing authentication token information.
class TokenEntity {
  final String accessToken;
  final String tokenType;

  const TokenEntity({
    required this.accessToken,
    this.tokenType = 'Bearer',
  });
}

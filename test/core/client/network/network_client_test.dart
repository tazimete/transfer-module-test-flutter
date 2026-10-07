import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transfermodule/core/client/network/network.dart';

void main() {
  group('AuthSession & AuthInterceptor Tests', () {
    test('InMemoryAuthSession toggles session state and token correctly', () async {
      final session = InMemoryAuthSession(isLoggedIn: false);
      expect(await session.isLoggedIn, false);
      expect(await session.authToken, null);

      session.setSession(loggedIn: true, token: 'sample_jwt_123');
      expect(await session.isLoggedIn, true);
      expect(await session.authToken, 'sample_jwt_123');

      session.onUnauthenticated();
      expect(await session.isLoggedIn, false);
      expect(await session.authToken, null);
    });

    test('AuthInterceptor attaches Bearer token when isLoggedIn is true', () async {
      final session = InMemoryAuthSession(
        isLoggedIn: true,
        authToken: 'secret_token',
      );

      final interceptor = AuthInterceptor(authSession: session);
      final options = RequestOptions(path: '/user/profile');
      final handler = RequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer secret_token');
      expect(options.extra['isLoggedIn'], true);
    });

    test('AuthInterceptor omits Bearer token when isLoggedIn is false', () async {
      final session = InMemoryAuthSession(isLoggedIn: false);

      final interceptor = AuthInterceptor(authSession: session);
      final options = RequestOptions(path: '/public/config');
      final handler = RequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('Authorization'), false);
      expect(options.extra['isLoggedIn'], false);
    });
  });

  group('NetworkException Mapping Tests', () {
    test('DioExceptionType.connectionTimeout maps to WeakNetworkException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/data'),
        type: DioExceptionType.connectionTimeout,
      );

      final exception = dioException.toNetworkException();
      expect(exception, isA<WeakNetworkException>());
    });

    test('DioExceptionType.badResponse (401) maps to UnauthorizedException', () {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/secure'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/secure'),
          statusCode: 401,
        ),
      );

      final exception = dioException.toNetworkException();
      expect(exception, isA<UnauthorizedException>());
      expect(exception.statusCode, 401);
    });
  });

  group('DioNetworkClient Client Initialization', () {
    test('DioNetworkClient uses NetworkConfig.baseUrl by default', () {
      final client = DioNetworkClient(enableLogging: false);
      expect(client.baseUrl, NetworkConfig.baseUrl);
    });

    test('DioNetworkClient allows custom Base URL and AuthSession injection', () {
      final session = InMemoryAuthSession(isLoggedIn: true, authToken: 'token_x');
      final client = DioNetworkClient(
        baseUrl: 'https://api.staging.com/',
        authSession: session,
        enableLogging: false,
      );

      expect(client.baseUrl, 'https://api.staging.com/');
    });
  });
}

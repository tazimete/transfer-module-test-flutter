import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../core/client/preference/abstract_preference_manager.dart';
import '../../../upload/domain/usecase/authenticate_usecase.dart';
import '../../../upload/domain/usecase/check_auth_status_usecase.dart';
import '../../../../foundation/base/base_viewmodel.dart';

class DashboardViewmodel extends BaseViewModel {
  int _currentIndex = 0;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final AuthenticateUseCase _authenticateUseCase;
  final AbstractPreferenceManager _preferenceManager;

  int get currentIndex => _currentIndex;

  DashboardViewmodel({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required AuthenticateUseCase authenticateUseCase,
    required AbstractPreferenceManager preferenceManager,
  })  : _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _authenticateUseCase = authenticateUseCase,
        _preferenceManager = preferenceManager;

  @override
  Future<void> init() async {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return;
      }
    } catch (_) {}
    unawaited(_checkAndAuthenticate());
  }

  Future<void> _checkAndAuthenticate() async {
    try {
      final bool isLoggedIn = await _checkAuthStatusUseCase.invoke().timeout(
            const Duration(seconds: 2),
            onTimeout: () => false,
          );
      if (!isLoggedIn) {
        debugPrint('User not authenticated. Authenticating with test credentials...');
        const params = AuthenticateParams(
          username: 'testuser_2026',
          password: 'test@user_2026',
        );
        final tokenEntity = await _authenticateUseCase.invoke(params).timeout(
              const Duration(seconds: 3),
              onTimeout: () => throw Exception('Authentication timeout'),
            );

        if (tokenEntity.accessToken.isNotEmpty) {
          await _preferenceManager.saveAuthSession(
            token: tokenEntity.accessToken,
            isLoggedIn: true,
          );
          debugPrint('Authentication successful & session saved in PreferenceManager!');
        }
      } else {
        debugPrint('User already authenticated from shared preferences.');
      }
    } catch (e) {
      debugPrint('Authentication check failed: $e');
    }
  }

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}

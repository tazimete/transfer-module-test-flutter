import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../core/client/preference/abstract_preference_manager.dart';
import '../../../upload/domain/usecase/authenticate_usecase.dart';
import '../../../upload/domain/usecase/check_auth_status_usecase.dart';
import '../../domain/entity/file_item_entity.dart';
import '../../domain/usecase/get_uploaded_files_usecase.dart';
import '../../../../foundation/base/base_viewmodel.dart';

class DashboardViewmodel extends BaseViewModel {
  int _currentIndex = 0;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final AuthenticateUseCase _authenticateUseCase;
  final GetUploadedFilesUseCase _getUploadedFilesUseCase;
  final AbstractPreferenceManager _preferenceManager;

  List<FileItemEntity> _files = [];
  bool _isLoadingFiles = false;
  String? _errorMessage;

  int get currentIndex => _currentIndex;
  List<FileItemEntity> get files => _files;
  bool get isLoadingFiles => _isLoadingFiles;
  String? get errorMessage => _errorMessage;

  DashboardViewmodel({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required AuthenticateUseCase authenticateUseCase,
    required GetUploadedFilesUseCase getUploadedFilesUseCase,
    required AbstractPreferenceManager preferenceManager,
  })  : _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _authenticateUseCase = authenticateUseCase,
        _getUploadedFilesUseCase = getUploadedFilesUseCase,
        _preferenceManager = preferenceManager;

  @override
  Future<void> init() async {
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return;
      }
    } catch (_) {}
    unawaited(_checkAndAuthenticateAndFetchFiles());
  }

  Future<void> _checkAndAuthenticateAndFetchFiles() async {
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
          debugPrint('Authentication successful & session saved!');
        }
      }

      await fetchUploadedFiles();
    } catch (e) {
      debugPrint('Auth & fetch error: $e');
      _errorMessage = 'Failed to authenticate or load files: $e';
      notifyListeners();
    }
  }

  Future<void> fetchUploadedFiles() async {
    _isLoadingFiles = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _files = await _getUploadedFilesUseCase.invoke();
      _isLoadingFiles = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoadingFiles = false;
      _errorMessage = 'Failed to load uploaded files: $e';
      notifyListeners();
    }
  }

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
      if (index == 0) {
        fetchUploadedFiles();
      }
    }
  }
}

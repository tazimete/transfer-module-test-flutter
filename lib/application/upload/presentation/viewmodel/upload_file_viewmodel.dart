import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/client/preference/abstract_preference_manager.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/usecase/upload_file_usecase.dart';
import '../../../../foundation/base/base_viewmodel.dart';

class UploadFileViewModel extends BaseViewModel {
  final UploadFileUseCase _uploadFileUseCase;
  final AbstractPreferenceManager _preferenceManager;
  final NotificationService _notificationService;

  File? _selectedFile;
  String? _selectedFileName;
  double _progress = 0.0;
  bool _isUploading = false;

  File? get selectedFile => _selectedFile;
  String? get selectedFileName => _selectedFileName;
  double get progress => _progress;
  bool get isUploading => _isUploading;

  UploadFileViewModel({
    required UploadFileUseCase uploadFileUseCase,
    required AbstractPreferenceManager preferenceManager,
    required NotificationService notificationService,
  })  : _uploadFileUseCase = uploadFileUseCase,
        _preferenceManager = preferenceManager,
        _notificationService = notificationService;

  @override
  Future<void> init() async {}

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = result.files.single.name;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> uploadFile(BuildContext context) async {
    if (_selectedFile == null) return;

    _isUploading = true;
    _progress = 0.0;
    notifyListeners();

    try {
      final token = await _preferenceManager.authToken;
      debugPrint('Uploading with stored token: ${token != null ? 'Present' : 'Absent'}');

      final params = UploadFileParams(
        file: _selectedFile!,
        fieldName: 'file',
        onSendProgress: (int sent, int total) {
          if (total > 0) {
            _progress = sent / total;
            notifyListeners();
          }
        },
      );

      final result = await _uploadFileUseCase.invoke(params);

      _isUploading = false;
      _progress = 1.0;
      notifyListeners();

      await _notificationService.showUploadCompleteNotification(
        title: 'Upload Successful!',
        body: 'File "${_selectedFileName ?? 'Document'}" was uploaded successfully.',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
      }
    } catch (e) {
      _isUploading = false;
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }
}

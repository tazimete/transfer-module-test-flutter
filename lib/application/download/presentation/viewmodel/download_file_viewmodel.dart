import 'package:flutter/material.dart';
import '../../../../core/client/preference/abstract_preference_manager.dart';
import '../../../../core/services/download_service.dart';
import '../../../../foundation/base/base_viewmodel.dart';

class DownloadFileViewModel extends BaseViewModel {
  final DownloadService _downloadService;
  final AbstractPreferenceManager _preferenceManager;

  final TextEditingController fileUrlController;
  final TextEditingController fileNameController;

  double _progress = 0.0;
  bool _isDownloading = false;

  double get progress => _progress;
  bool get isDownloading => _isDownloading;

  DownloadFileViewModel({
    required DownloadService downloadService,
    required AbstractPreferenceManager preferenceManager,
    String? initialFileUrl,
    String? initialFileName,
  })  : _downloadService = downloadService,
        _preferenceManager = preferenceManager,
        fileUrlController = TextEditingController(text: initialFileUrl ?? 'http://15.232.228.139/api/download/sample.pdf'),
        fileNameController = TextEditingController(text: initialFileName ?? 'downloaded_file.pdf');

  @override
  Future<void> init() async {}

  Future<void> startDownload(BuildContext context) async {
    final url = fileUrlController.text.trim();
    final name = fileNameController.text.trim().isNotEmpty ? fileNameController.text.trim() : 'downloaded_file.pdf';

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a valid file URL')),
      );
      return;
    }

    _isDownloading = true;
    _progress = 0.0;
    notifyListeners();

    final token = await _preferenceManager.authToken;

    // Run download in DownloadService (decoupled from screen lifecycle so pressing back doesn't cancel it)
    _downloadService.startBackgroundDownload(
      fileUrl: url,
      fileName: name,
      token: token,
      onProgress: (progressVal) {
        if (isDisposed) return;
        _progress = progressVal;
        notifyListeners();
      },
      onComplete: (savePath) {
        if (isDisposed) return;
        _isDownloading = false;
        _progress = 1.0;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded and opened successfully: $name')),
          );
        }
      },
      onError: (error) {
        if (isDisposed) return;
        _isDownloading = false;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download failed: $error')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    fileUrlController.dispose();
    fileNameController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/usecase/download_file_usecase.dart';
import '../../domain/usecase/open_file_usecase.dart';
import '../../../../foundation/base/base_viewmodel.dart';

class DownloadFileViewModel extends BaseViewModel {
  final DownloadFileUseCase _downloadFileUseCase;
  final OpenFileUseCase _openFileUseCase;
  final NotificationService _notificationService;

  final TextEditingController fileUrlController;
  final TextEditingController fileNameController;

  double _progress = 0.0;
  bool _isDownloading = false;

  double get progress => _progress;
  bool get isDownloading => _isDownloading;

  DownloadFileViewModel({
    required DownloadFileUseCase downloadFileUseCase,
    required OpenFileUseCase openFileUseCase,
    required NotificationService notificationService,
    String? initialFileUrl,
    String? initialFileName,
  })  : _downloadFileUseCase = downloadFileUseCase,
        _openFileUseCase = openFileUseCase,
        _notificationService = notificationService,
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

    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = '${dir.path}/$name';

      // Show initial notification
      await _notificationService.showDownloadProgressNotification(
        id: 2001,
        title: 'Downloading $name',
        body: 'Progress: 0%',
        progress: 0,
        isCompleted: false,
      );

      int lastReportedPercent = -1;

      final params = DownloadFileParams(
        fileUrl: url,
        savePath: savePath,
        onReceiveProgress: (int received, int total) {
          if (total > 0) {
            _progress = received / total;
            notifyListeners();

            final int percent = (_progress * 100).toInt();
            if (percent != lastReportedPercent && (percent % 10 == 0 || percent == 100)) {
              lastReportedPercent = percent;
              _notificationService.showDownloadProgressNotification(
                id: 2001,
                title: 'Downloading $name',
                body: 'Progress: $percent%',
                progress: percent,
                isCompleted: false,
              );
            }
          }
        },
      );

      // Executes download via Clean Architecture UseCase (automatically authenticated with Bearer token)
      await _downloadFileUseCase.invoke(params);

      _isDownloading = false;
      _progress = 1.0;
      notifyListeners();

      // Show completion notification
      await _notificationService.showDownloadProgressNotification(
        id: 2001,
        title: 'Download Complete',
        body: 'Tap to open $name',
        progress: 100,
        isCompleted: true,
        filePath: savePath,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded successfully to $savePath. Opening file...')),
        );
      }

      // Open file immediately
      await _openFileUseCase.invoke(OpenFileParams(filePath: savePath));
    } catch (e) {
      _isDownloading = false;
      notifyListeners();

      await _notificationService.showDownloadProgressNotification(
        id: 2001,
        title: 'Download Failed',
        body: 'Could not download file: $e',
        progress: 0,
        isCompleted: false,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    fileUrlController.dispose();
    fileNameController.dispose();
    super.dispose();
  }
}

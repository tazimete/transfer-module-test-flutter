import 'package:flutter/material.dart';
import 'package:transfermodule/foundation/base/base_viewmodel.dart';

class UploadFileViewmodel extends BaseViewModel {
  final TextEditingController fileIdController = TextEditingController(text: 'TRX-1001-RECEIPT');
  double _progress = 0.0;
  bool _isDownloading = false;

  double get progress => _progress;
  bool get isDownloading => _isDownloading;

  @override
  Future<void> init() async {}

  Future<void> simulateDownload(BuildContext context) async {
    _isDownloading = true;
    _progress = 0.0;
    notifyListeners();

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _progress = i / 10.0;
      notifyListeners();
    }

    _isDownloading = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File downloaded successfully to Downloads!')),
      );
    }
  }

  @override
  void dispose() {
    fileIdController.dispose();
    super.dispose();
  }
}

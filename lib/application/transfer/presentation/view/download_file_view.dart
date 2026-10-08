import 'package:flutter/material.dart';
import 'package:transfermodule/shared/components/app_colors.dart';

/// Download File View allowing file download with progress tracking.
class DownloadFileView extends StatefulWidget {
  const DownloadFileView({super.key});

  @override
  State<DownloadFileView> createState() => _DownloadFileViewState();
}

class _DownloadFileViewState extends State<DownloadFileView> {
  bool _isDownloading = false;
  double _progress = 0.0;
  final TextEditingController _fileIdController = TextEditingController(text: 'TRX-1001-RECEIPT');

  void _simulateDownload() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        _progress = i / 10.0;
      });
    }

    setState(() {
      _isDownloading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File downloaded successfully to Downloads!')),
      );
    }
  }

  @override
  void dispose() {
    _fileIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBGLightColor,
      appBar: AppBar(
        title: const Text('Download File', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.appPrimaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appPrimaryColor.withValues(alpha: 0.5), width: 2),
                borderRadius: BorderRadius.circular(16),
                color: AppColors.appPrimaryColor.withValues(alpha: 0.05),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_download_outlined, size: 64, color: AppColors.appPrimaryColor),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter File ID or Reference to Download',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _fileIdController,
                    decoration: InputDecoration(
                      labelText: 'File Reference ID',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.insert_drive_file),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_isDownloading) ...[
              LinearProgressIndicator(value: _progress, color: AppColors.appPrimaryColor),
              const SizedBox(height: 12),
              Text(
                'Downloading... ${(_progress * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.appSecondaryColor),
              ),
              const SizedBox(height: 24),
            ],
            ElevatedButton(
              onPressed: _isDownloading ? null : _simulateDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _isDownloading ? 'Downloading...' : 'Start Download',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

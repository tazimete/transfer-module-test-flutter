import 'package:flutter/material.dart';
import 'package:transfermodule/shared/components/app_colors.dart';

/// Upload File View allowing file selection and uploading with progress tracking.
class UploadFileView extends StatefulWidget {
  const UploadFileView({super.key});

  @override
  State<UploadFileView> createState() => _UploadFileViewState();
}

class _UploadFileViewState extends State<UploadFileView> {
  bool _isUploading = false;
  double _progress = 0.0;
  String? _selectedFileName;

  void _simulateUpload() async {
    setState(() {
      _isUploading = true;
      _progress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        _progress = i / 10.0;
      });
    }

    setState(() {
      _isUploading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBGLightColor,
      appBar: AppBar(
        title: const Text('Upload File', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
                  const Icon(Icons.cloud_upload_outlined, size: 64, color: AppColors.appPrimaryColor),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFileName ?? 'Select a document or file to upload',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Supports PDF, PNG, JPG (Max 50MB)',
                    style: TextStyle(color: AppColors.appSecondaryColor, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () {
                            setState(() {
                              _selectedFileName = 'transfer_receipt_2025.pdf';
                            });
                          },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Browse Files'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_isUploading) ...[
              LinearProgressIndicator(value: _progress, color: AppColors.appPrimaryColor),
              const SizedBox(height: 12),
              Text(
                'Uploading... ${(_progress * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.appSecondaryColor),
              ),
              const SizedBox(height: 24),
            ],
            ElevatedButton(
              onPressed: (_selectedFileName == null || _isUploading) ? null : _simulateUpload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appPrimaryColor,
                disabledBackgroundColor: AppColors.appDisableColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _isUploading ? 'Uploading...' : 'Start Upload',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

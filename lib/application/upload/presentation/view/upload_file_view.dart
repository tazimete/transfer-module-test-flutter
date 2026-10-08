import 'package:flutter/material.dart';
import 'package:transfermodule/application/upload/presentation/viewmodel/upload_file_viewmodel.dart';
import 'package:transfermodule/foundation/base/base_screen_widget.dart';
import 'package:transfermodule/shared/components/app_colors.dart';

/// Download File View implemented with BaseView and DownloadViewModel architecture.
class UploadFileView extends StatelessWidget {
  const UploadFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<UploadFileViewmodel>(
      vmBuilder: (context) => UploadFileViewmodel(),
      builder: (context, viewModel) {
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
                        controller: viewModel.fileIdController,
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
                if (viewModel.isDownloading) ...[
                  LinearProgressIndicator(value: viewModel.progress, color: AppColors.appPrimaryColor),
                  const SizedBox(height: 12),
                  Text(
                    'Downloading... ${(viewModel.progress * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.appSecondaryColor),
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: viewModel.isDownloading ? null : () => viewModel.simulateDownload(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    viewModel.isDownloading ? 'Downloading...' : 'Start Download',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

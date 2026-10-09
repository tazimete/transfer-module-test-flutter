import 'package:flutter/material.dart';
import '../../../../foundation/base/base_screen_widget.dart';
import '../../../../shared/components/app_colors.dart';
import '../../domain/utility/download_file_view_model_builder.dart';
import '../viewmodel/download_file_viewmodel.dart';

/// Download File View using BaseView and DownloadFileViewModel with DI/mocking facility.
class DownloadFileView extends StatelessWidget {
  final String? fileUrl;
  final String? fileName;
  final DownloadFileViewModel? viewModel;

  const DownloadFileView({
    super.key,
    this.fileUrl,
    this.fileName,
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<DownloadFileViewModel>(
      vmBuilder: (context) => viewModel ?? DownloadFileViewModelBuilder(
        fileUrl: fileUrl,
        fileName: fileName,
      ).build(),
      builder: (context, vm) {
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
                  padding: const EdgeInsets.all(24),
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
                        'Download File from Server',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: vm.fileUrlController,
                        decoration: InputDecoration(
                          labelText: 'File URL',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.link),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: vm.fileNameController,
                        decoration: InputDecoration(
                          labelText: 'Save File Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          prefixIcon: const Icon(Icons.insert_drive_file),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                if (vm.isDownloading) ...[
                  LinearProgressIndicator(value: vm.progress, color: AppColors.appPrimaryColor),
                  const SizedBox(height: 12),
                  Text(
                    'Downloading... ${(vm.progress * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.appSecondaryColor),
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: vm.isDownloading ? null : () => vm.startDownload(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    vm.isDownloading ? 'Downloading...' : 'Start Download',
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

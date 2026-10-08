import 'package:flutter/material.dart';
import '../../../../foundation/base/base_screen_widget.dart';
import '../../../../shared/components/app_colors.dart';
import '../../domain/utility/upload_file_view_model_builder.dart';
import '../viewmodel/upload_file_viewmodel.dart';

/// Upload File View using BaseView and UploadFileViewModel with Clean Architecture & Builders.
class UploadFileView extends StatelessWidget {
  const UploadFileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<UploadFileViewModel>(
      vmBuilder: (context) => UploadFileViewModelBuilder().build(),
      builder: (context, viewModel) {
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
                        viewModel.selectedFileName ?? 'Select a large file (e.g. video, image, .csv)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Supports any file format (>50MB supported)',
                        style: TextStyle(color: AppColors.appSecondaryColor, fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: viewModel.isUploading ? null : () => viewModel.pickFile(),
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
                if (viewModel.isUploading) ...[
                  LinearProgressIndicator(value: viewModel.progress, color: AppColors.appPrimaryColor),
                  const SizedBox(height: 12),
                  Text(
                    'Uploading... ${(viewModel.progress * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.appSecondaryColor),
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: (viewModel.selectedFile == null || viewModel.isUploading)
                      ? null
                      : () => viewModel.uploadFile(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appPrimaryColor,
                    disabledBackgroundColor: AppColors.appDisableColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    viewModel.isUploading ? 'Uploading...' : 'Start Upload',
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

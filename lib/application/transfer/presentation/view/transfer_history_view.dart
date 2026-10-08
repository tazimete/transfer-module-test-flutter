import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transfermodule/shared/components/app_colors.dart';
import '../viewmodel/dashboard_viewmodel.dart';

/// Transfer History View showing uploaded files from the server with error and empty states.
class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewmodel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors.appBGLightColor,
          appBar: AppBar(
            title: const Text('Uploaded Files History', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            elevation: 0.5,
            iconTheme: const IconThemeData(color: AppColors.appPrimaryColor),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => viewModel.fetchUploadedFiles(),
                tooltip: 'Refresh Files',
              ),
            ],
          ),
          body: _buildBody(context, viewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DashboardViewmodel viewModel) {
    if (viewModel.isLoadingFiles) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.appPrimaryColor),
      );
    }

    if (viewModel.errorMessage != null && viewModel.files.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.appErrorColor),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                style: const TextStyle(fontSize: 16, color: AppColors.appTextPrimaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.fetchUploadedFiles(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appPrimaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.files.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.appPrimaryColor.withValues(alpha: 0.08),
                ),
                child: const Icon(Icons.folder_open_outlined, size: 64, color: AppColors.appPrimaryColor),
              ),
              const SizedBox(height: 20),
              const Text(
                'No Files Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.appTextPrimaryColor),
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload files using the Upload menu to see them listed here.',
                style: TextStyle(fontSize: 14, color: AppColors.appSecondaryColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => viewModel.fetchUploadedFiles(),
                icon: const Icon(Icons.refresh),
                label: const Text('Check Again'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.appPrimaryColor,
                  side: const BorderSide(color: AppColors.appPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.fetchUploadedFiles(),
      color: AppColors.appPrimaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: viewModel.files.length,
        itemBuilder: (context, index) {
          final file = viewModel.files[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: AppColors.appPrimaryColor.withValues(alpha: 0.1),
                child: const Icon(Icons.insert_drive_file, color: AppColors.appPrimaryColor),
              ),
              title: Text(
                file.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'ID: ${file.id} ${file.uploadedAt != null ? '• ${file.uploadedAt}' : ''}',
                style: const TextStyle(color: AppColors.appSecondaryColor, fontSize: 13),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.appSecondaryColor),
            ),
          );
        },
      ),
    );
  }
}

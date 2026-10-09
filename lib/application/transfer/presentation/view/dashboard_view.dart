import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:transfermodule/application/download/presentation/view/download_file_view.dart';
import 'package:transfermodule/application/transfer/presentation/view/transfer_history_view.dart';
import 'package:transfermodule/application/upload/domain/utility/dashboard_view_model_builder.dart';
import 'package:transfermodule/application/upload/presentation/view/upload_file_view.dart';
import 'package:transfermodule/application/transfer/presentation/viewmodel/dashboard_viewmodel.dart';
import 'package:transfermodule/foundation/base/base_screen_widget.dart';
import 'package:transfermodule/shared/components/app_colors.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardViewmodel>(
      vmBuilder: (context) => DashboardViewModelBuilder().build(),
      builder: (context, viewModel) {
        final views = [
          const TransferHistoryView(),
          const UploadFileView(),
          const DownloadFileView(),
        ];

        final titles = [
          'Transfer History',
          'Upload File',
          'Download File',
        ];

        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: AppColors.appPrimaryColor),
            title: Text(
              titles[viewModel.currentIndex],
              style: const TextStyle(color: AppColors.appPrimaryColor, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.appBGLightColor,
            elevation: 0.5,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: AppColors.appPrimaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Transfer Portal",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(4),
                      Text(
                        "Manage your transfers & files",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      Gap(16),
                    ],
                  ),
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.history,
                  title: 'Transfer History',
                  isSelected: viewModel.currentIndex == 0,
                  onTap: () => viewModel.setIndex(0),
                  showDivider: true,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.cloud_upload,
                  title: 'Upload File',
                  isSelected: viewModel.currentIndex == 1,
                  onTap: () => viewModel.setIndex(1),
                  showDivider: true,
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.cloud_download,
                  title: 'Download File',
                  isSelected: viewModel.currentIndex == 2,
                  onTap: () => viewModel.setIndex(2),
                  showDivider: true,
                ),
              ],
            ),
          ),
          body: IndexedStack(
            index: viewModel.currentIndex,
            children: views,
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: isSelected ? AppColors.appPrimaryColor : AppColors.appSecondaryColor),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.appPrimaryColor : AppColors.appTextPrimaryColor,
            ),
          ),
          selected: isSelected,
          selectedTileColor: AppColors.appPrimaryColor.withValues(alpha: 0.08),
          trailing: const Icon(Icons.download, size: 18, color: AppColors.appPrimaryColor),
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
        ),
        if (showDivider) const Divider(height: 1, color: AppColors.appDividerColor),
      ],
    );
  }
}

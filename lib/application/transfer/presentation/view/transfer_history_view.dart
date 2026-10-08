import 'package:flutter/material.dart';
import 'package:transfermodule/shared/components/app_colors.dart';

/// Transfer History View showing past transactions and status.
class TransferHistoryView extends StatelessWidget {
  const TransferHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final transfers = [
      {
        'id': 'TRX-1001',
        'title': 'Monthly Rent Transfer',
        'amount': '\$1,200.00',
        'date': '2025-05-01',
        'status': 'Completed'
      },
      {
        'id': 'TRX-1002',
        'title': 'Utility Bill Payment',
        'amount': '\$145.50',
        'date': '2025-05-03',
        'status': 'Completed'
      },
      {
        'id': 'TRX-1003',
        'title': 'Freelance Payout',
        'amount': '\$3,500.00',
        'date': '2025-05-06',
        'status': 'Pending'
      },
      {
        'id': 'TRX-1004',
        'title': 'Grocery Store Purchase',
        'amount': '\$85.20',
        'date': '2025-05-07',
        'status': 'Failed'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.appBGLightColor,
      appBar: AppBar(
        title: const Text('Transfer History', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.appPrimaryColor),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transfers.length,
        itemBuilder: (context, index) {
          final tx = transfers[index];
          final isCompleted = tx['status'] == 'Completed';
          final isPending = tx['status'] == 'Pending';

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: AppColors.appPrimaryColor.withValues(alpha: 0.1),
                child: Icon(
                  isCompleted ? Icons.check_circle : (isPending ? Icons.hourglass_top : Icons.error),
                  color: isCompleted ? AppColors.appSuccessColor : (isPending ? AppColors.appWarningColor : AppColors.appErrorColor),
                ),
              ),
              title: Text(
                tx['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'ID: ${tx['id']} • ${tx['date']}',
                style: const TextStyle(color: AppColors.appSecondaryColor, fontSize: 13),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tx['amount']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tx['status']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? AppColors.appSuccessColor : (isPending ? AppColors.appWarningColor : AppColors.appErrorColor),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

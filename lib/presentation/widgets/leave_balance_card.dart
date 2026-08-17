import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/leave_entity.dart';

class LeaveBalanceSection extends StatelessWidget {
  final LeaveBalance balance;
  final Function(LeaveType) onTypeTap;

  const LeaveBalanceSection({
    super.key,
    required this.balance,
    required this.onTypeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Leave Balances',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _BalanceItem(
                label: 'Casual',
                value: balance.casual,
                color: AppColors.casualLeave,
                onTap: () => onTypeTap(LeaveType.casual),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BalanceItem(
                label: 'Sick',
                value: balance.sick,
                color: AppColors.sickLeave,
                onTap: () => onTypeTap(LeaveType.sick),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BalanceItem(
                label: 'Earned',
                value: balance.earned,
                color: AppColors.earnedLeave,
                onTap: () => onTypeTap(LeaveType.earned),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final VoidCallback onTap;

  const _BalanceItem({
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

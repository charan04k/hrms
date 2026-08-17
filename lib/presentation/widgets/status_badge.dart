import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceStatusBadge extends StatelessWidget {
  final AttendanceStatus status;

  const AttendanceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    String text;

    switch (status) {
      case AttendanceStatus.present:
        color = AppColors.present;
        bgColor = AppColors.presentBg;
        text = 'Present';
        break;
      case AttendanceStatus.absent:
        color = AppColors.absent;
        bgColor = AppColors.absentBg;
        text = 'Absent';
        break;
      case AttendanceStatus.onLeave:
        color = AppColors.onLeave;
        bgColor = AppColors.onLeaveBg;
        text = 'On Leave';
        break;
      default:
        color = AppColors.textSecondary;
        bgColor = AppColors.surfaceVariant;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

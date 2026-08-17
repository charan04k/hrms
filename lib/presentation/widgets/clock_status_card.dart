import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_utils.dart';
import '../../domain/entities/attendance_entity.dart';

class ClockStatusCard extends StatelessWidget {
  final AttendanceEntity? attendance;
  final bool isClockedIn;
  final Duration elapsedDuration;
  final bool isLoading;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  const ClockStatusCard({
    super.key,
    this.attendance,
    required this.isClockedIn,
    required this.elapsedDuration,
    required this.isLoading,
    required this.onClockIn,
    required this.onClockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTimeUtils.formatDate(DateTime.now()),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Daily Attendance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_outlined, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TimeInfo(
                label: 'Clock In',
                time: attendance?.clockInTime != null
                    ? DateTimeUtils.formatTime(attendance!.clockInTime!)
                    : '--:--',
              ),
              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.2)),
              _TimeInfo(
                label: 'Working Hours',
                time: DateTimeUtils.formatDurationDetailed(elapsedDuration),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isLoading ? null : (isClockedIn ? onClockOut : onClockIn),
              style: ElevatedButton.styleFrom(
                backgroundColor: isClockedIn ? AppColors.absent : Colors.white,
                foregroundColor: isClockedIn ? Colors.white : AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    )
                  : Text(
                      isClockedIn ? 'Clock Out' : 'Clock In Now',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeInfo extends StatelessWidget {
  final String label;
  final String time;

  const _TimeInfo({required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

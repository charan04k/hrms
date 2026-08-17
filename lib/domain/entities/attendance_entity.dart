import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent, onLeave, halfDay, late }

class AttendanceEntity extends Equatable {
  final DateTime date;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final AttendanceStatus status;
  final int totalWorkingMinutes;
  final String? notes;

  const AttendanceEntity({
    required this.date,
    this.clockInTime,
    this.clockOutTime,
    required this.status,
    this.totalWorkingMinutes = 0,
    this.notes,
  });

  @override
  List<Object?> get props => [date, clockInTime, clockOutTime, status, totalWorkingMinutes, notes];
}

import 'package:equatable/equatable.dart';
import '../../../domain/entities/attendance_entity.dart';

enum AttendanceActionStatus { initial, loading, success, failure }

class AttendanceState extends Equatable {
  final AttendanceEntity? todayAttendance;
  final List<AttendanceEntity> monthlyHistory;
  final bool isClockedIn;
  final Duration elapsedWorkingDuration;
  final int presentCount;
  final AttendanceActionStatus actionStatus;
  final String? successMessage;
  final String? errorMessage;

  const AttendanceState({
    this.todayAttendance,
    this.monthlyHistory = const [],
    this.isClockedIn = false,
    this.elapsedWorkingDuration = Duration.zero,
    this.presentCount = 0,
    this.actionStatus = AttendanceActionStatus.initial,
    this.successMessage,
    this.errorMessage,
  });

  AttendanceState copyWith({
    AttendanceEntity? todayAttendance,
    List<AttendanceEntity>? monthlyHistory,
    bool? isClockedIn,
    Duration? elapsedWorkingDuration,
    int? presentCount,
    AttendanceActionStatus? actionStatus,
    String? successMessage,
    String? errorMessage,
  }) {
    return AttendanceState(
      todayAttendance: todayAttendance ?? this.todayAttendance,
      monthlyHistory: monthlyHistory ?? this.monthlyHistory,
      isClockedIn: isClockedIn ?? this.isClockedIn,
      elapsedWorkingDuration: elapsedWorkingDuration ?? this.elapsedWorkingDuration,
      presentCount: presentCount ?? this.presentCount,
      actionStatus: actionStatus ?? this.actionStatus,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        todayAttendance,
        monthlyHistory,
        isClockedIn,
        elapsedWorkingDuration,
        presentCount,
        actionStatus,
        successMessage,
        errorMessage,
      ];
}

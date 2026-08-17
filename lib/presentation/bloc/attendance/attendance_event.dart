import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodayAttendance extends AttendanceEvent {
  const LoadTodayAttendance();
}

class ClockInRequested extends AttendanceEvent {
  const ClockInRequested();
}

class ClockOutRequested extends AttendanceEvent {
  const ClockOutRequested();
}

class UpdateElapsedDuration extends AttendanceEvent {
  final Duration duration;
  const UpdateElapsedDuration(this.duration);

  @override
  List<Object?> get props => [duration];
}

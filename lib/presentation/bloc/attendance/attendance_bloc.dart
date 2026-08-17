import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/attendance_entity.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  Timer? _timer;

  AttendanceBloc() : super(const AttendanceState()) {
    on<LoadTodayAttendance>(_onLoadTodayAttendance);
    on<ClockInRequested>(_onClockInRequested);
    on<ClockOutRequested>(_onClockOutRequested);
    on<UpdateElapsedDuration>(_onUpdateElapsedDuration);
  }

  void _onLoadTodayAttendance(LoadTodayAttendance event, Emitter<AttendanceState> emit) {

    final now = DateTime.now();
    final mockHistory = [
      AttendanceEntity(
        date: now.subtract(const Duration(days: 1)),
        clockInTime: DateTime(now.year, now.month, now.day - 1, 9, 0),
        clockOutTime: DateTime(now.year, now.month, now.day - 1, 18, 0),
        status: AttendanceStatus.present,
        totalWorkingMinutes: 540,
      ),
      AttendanceEntity(
        date: now.subtract(const Duration(days: 2)),
        clockInTime: DateTime(now.year, now.month, now.day - 2, 9, 15),
        clockOutTime: DateTime(now.year, now.month, now.day - 2, 18, 30),
        status: AttendanceStatus.present,
        totalWorkingMinutes: 555,
      ),
    ];

    emit(state.copyWith(
      monthlyHistory: mockHistory,
      presentCount: 15,
    ));
  }

  void _onClockInRequested(ClockInRequested event, Emitter<AttendanceState> emit) {
    if (state.isClockedIn) return;

    final now = DateTime.now();
    final newAttendance = AttendanceEntity(
      date: now,
      clockInTime: now,
      status: AttendanceStatus.present,
    );

    emit(state.copyWith(
      isClockedIn: true,
      todayAttendance: newAttendance,
      actionStatus: AttendanceActionStatus.success,
      successMessage: 'Clocked in successfully',
    ));

    _startTimer();
  }

  void _onClockOutRequested(ClockOutRequested event, Emitter<AttendanceState> emit) {
    if (!state.isClockedIn) return;

    final now = DateTime.now();
    final clockIn = state.todayAttendance?.clockInTime ?? now;
    final duration = now.difference(clockIn);

    final updatedAttendance = AttendanceEntity(
      date: state.todayAttendance!.date,
      clockInTime: clockIn,
      clockOutTime: now,
      status: AttendanceStatus.present,
      totalWorkingMinutes: duration.inMinutes,
    );

    _stopTimer();

    emit(state.copyWith(
      isClockedIn: false,
      todayAttendance: updatedAttendance,
      elapsedWorkingDuration: duration,
      actionStatus: AttendanceActionStatus.success,
      successMessage: 'Clocked out successfully',
    ));
  }

  void _onUpdateElapsedDuration(UpdateElapsedDuration event, Emitter<AttendanceState> emit) {
    emit(state.copyWith(elapsedWorkingDuration: event.duration));
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.todayAttendance?.clockInTime != null) {
        final duration = DateTime.now().difference(state.todayAttendance!.clockInTime!);
        add(UpdateElapsedDuration(duration));
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Future<void> close() {
    _stopTimer();
    return super.close();
  }
}

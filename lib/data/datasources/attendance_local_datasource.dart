import '../models/attendance_model.dart';
import '../../domain/entities/attendance_entity.dart';

abstract class AttendanceLocalDataSource {
  Future<AttendanceModel?> getTodayAttendance();
  Future<List<AttendanceModel>> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
  });
  Future<void> clockIn();
  Future<void> clockOut();
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  AttendanceModel? _today;
  final List<AttendanceModel> _history = [];

  AttendanceLocalDataSourceImpl() {
    _generateMockHistory();
  }

  void _generateMockHistory() {
    final now = DateTime.now();
    for (int i = 1; i <= 60; i++) {
      final date = now.subtract(Duration(days: i));
      if (date.weekday == DateTime.sunday || date.weekday == DateTime.saturday) continue;

      _history.add(AttendanceModel(
        date: date,
        clockInTime: DateTime(date.year, date.month, date.day, 9, 0),
        clockOutTime: DateTime(date.year, date.month, date.day, 18, 0),
        status: i % 10 == 0 ? AttendanceStatus.absent : AttendanceStatus.present,
        totalWorkingMinutes: 540,
      ));
    }
  }

  @override
  Future<void> clockIn() async {
    _today = AttendanceModel(
      date: DateTime.now(),
      clockInTime: DateTime.now(),
      status: AttendanceStatus.present,
    );
  }

  @override
  Future<void> clockOut() async {
    if (_today != null && _today!.clockInTime != null) {
      final now = DateTime.now();
      final duration = now.difference(_today!.clockInTime!);
      _today = AttendanceModel(
        date: _today!.date,
        clockInTime: _today!.clockInTime,
        clockOutTime: now,
        status: AttendanceStatus.present,
        totalWorkingMinutes: duration.inMinutes,
      );
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
  }) async {
    return _history.where((e) {
      bool match = true;
      if (startDate != null && e.date.isBefore(startDate)) match = false;
      if (endDate != null && e.date.isAfter(endDate)) match = false;
      if (status != null && e.status != status) match = false;
      return match;
    }).toList();
  }

  @override
  Future<AttendanceModel?> getTodayAttendance() async {
    return _today;
  }
}

import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity?> getTodayAttendance();
  Future<List<AttendanceEntity>> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
  });
  Future<void> clockIn();
  Future<void> clockOut();
}

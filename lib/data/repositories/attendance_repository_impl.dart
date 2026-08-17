import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_local_datasource.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource localDataSource;

  AttendanceRepositoryImpl({required this.localDataSource});

  @override
  Future<void> clockIn() {
    return localDataSource.clockIn();
  }

  @override
  Future<void> clockOut() {
    return localDataSource.clockOut();
  }

  @override
  Future<List<AttendanceEntity>> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
  }) {
    return localDataSource.getAttendanceHistory(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }

  @override
  Future<AttendanceEntity?> getTodayAttendance() {
    return localDataSource.getTodayAttendance();
  }
}

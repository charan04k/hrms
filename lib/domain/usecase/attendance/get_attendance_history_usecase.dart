import '../../entities/attendance_entity.dart';
import '../../repositories/attendance_repository.dart';

class GetAttendanceHistoryUseCase {
  final AttendanceRepository repository;

  GetAttendanceHistoryUseCase({required this.repository});

  Future<List<AttendanceEntity>> call({
    DateTime? startDate,
    DateTime? endDate,
    AttendanceStatus? status,
  }) {
    return repository.getAttendanceHistory(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }
}

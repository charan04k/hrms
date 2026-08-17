import '../../repositories/attendance_repository.dart';

class ClockInUseCase {
  final AttendanceRepository repository;

  ClockInUseCase({required this.repository});

  Future<void> call() {
    return repository.clockIn();
  }
}

import '../../repositories/attendance_repository.dart';

class ClockOutUseCase {
  final AttendanceRepository repository;

  ClockOutUseCase({required this.repository});

  Future<void> call() {
    return repository.clockOut();
  }
}

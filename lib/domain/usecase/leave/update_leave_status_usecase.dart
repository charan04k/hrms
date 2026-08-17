import '../../entities/leave_entity.dart';
import '../../repositories/leave_repository.dart';

class UpdateLeaveStatusUseCase {
  final LeaveRepository repository;

  UpdateLeaveStatusUseCase({required this.repository});

  Future<void> call(String leaveId, LeaveStatus status) {
    return repository.updateLeaveStatus(leaveId, status);
  }
}

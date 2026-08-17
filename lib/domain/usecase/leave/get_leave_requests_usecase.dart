import '../../entities/leave_entity.dart';
import '../../repositories/leave_repository.dart';

class GetLeaveRequestsUseCase {
  final LeaveRepository repository;

  GetLeaveRequestsUseCase({required this.repository});

  Future<List<LeaveEntity>> call({
    DateTime? startDate,
    DateTime? endDate,
    LeaveStatus? status,
  }) {
    return repository.getLeaveRequests(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }
}

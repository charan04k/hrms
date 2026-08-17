import '../../entities/leave_entity.dart';
import '../../repositories/leave_repository.dart';

class ApplyLeaveUseCase {
  final LeaveRepository repository;

  ApplyLeaveUseCase({required this.repository});

  Future<void> call(LeaveEntity leave) async {
    if (leave.endDate.isBefore(leave.startDate)) {
      throw Exception('End date cannot be before start date');
    }

    final requests = await repository.getLeaveRequests();
    final hasOverlap = requests.any((req) =>
        req.status == LeaveStatus.pending &&
        ((leave.startDate.isAtSameMomentAs(req.startDate) || leave.startDate.isAfter(req.startDate)) &&
            (leave.startDate.isAtSameMomentAs(req.endDate) || leave.startDate.isBefore(req.endDate))));

    if (hasOverlap) {
      throw Exception('You already have a pending leave request for these dates');
    }

    return repository.applyLeave(leave);
  }
}

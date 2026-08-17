import '../../entities/leave_entity.dart';
import '../../repositories/leave_repository.dart';

class GetLeaveBalanceUseCase {
  final LeaveRepository repository;

  GetLeaveBalanceUseCase({required this.repository});

  Future<LeaveBalance> call() {
    return repository.getLeaveBalance();
  }
}

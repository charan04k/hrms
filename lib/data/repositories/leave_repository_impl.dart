import '../../domain/entities/leave_entity.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_local_datasource.dart';
import '../models/leave_model.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveLocalDataSource localDataSource;

  LeaveRepositoryImpl({required this.localDataSource});

  @override
  Future<void> applyLeave(LeaveEntity leave) {
    return localDataSource.applyLeave(LeaveModel.fromEntity(leave));
  }

  @override
  Future<LeaveBalance> getLeaveBalance() {
    return localDataSource.getLeaveBalance();
  }

  @override
  Future<List<LeaveEntity>> getLeaveRequests({
    DateTime? startDate,
    DateTime? endDate,
    LeaveStatus? status,
  }) {
    return localDataSource.getLeaveRequests(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }

  @override
  Future<void> updateLeaveStatus(String leaveId, LeaveStatus status) {
    return localDataSource.updateLeaveStatus(leaveId, status);
  }
}

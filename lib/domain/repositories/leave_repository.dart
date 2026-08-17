import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  Future<LeaveBalance> getLeaveBalance();
  Future<List<LeaveEntity>> getLeaveRequests({
    DateTime? startDate,
    DateTime? endDate,
    LeaveStatus? status,
  });
  Future<void> applyLeave(LeaveEntity leave);
  Future<void> updateLeaveStatus(String leaveId, LeaveStatus status);
}

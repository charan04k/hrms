import '../models/leave_model.dart';
import '../../domain/entities/leave_entity.dart';

abstract class LeaveLocalDataSource {
  Future<LeaveBalanceModel> getLeaveBalance();
  Future<List<LeaveModel>> getLeaveRequests({
    DateTime? startDate,
    DateTime? endDate,
    LeaveStatus? status,
  });
  Future<void> applyLeave(LeaveModel leave);
  Future<void> updateLeaveStatus(String leaveId, LeaveStatus status);
}

class LeaveLocalDataSourceImpl implements LeaveLocalDataSource {
  final List<LeaveModel> _requests = [];
  LeaveBalanceModel _balance = const LeaveBalanceModel(casual: 12, sick: 8, earned: 15);

  @override
  Future<void> applyLeave(LeaveModel leave) async {
    _requests.add(leave);
  }

  @override
  Future<LeaveBalanceModel> getLeaveBalance() async {
    return _balance;
  }

  @override
  Future<List<LeaveModel>> getLeaveRequests({
    DateTime? startDate,
    DateTime? endDate,
    LeaveStatus? status,
  }) async {
    return _requests.where((e) {
      bool match = true;
      if (startDate != null && e.startDate.isBefore(startDate)) match = false;
      if (endDate != null && e.endDate.isAfter(endDate)) match = false;
      if (status != null && e.status != status) match = false;
      return match;
    }).toList();
  }

  @override
  Future<void> updateLeaveStatus(String leaveId, LeaveStatus status) async {
    final index = _requests.indexWhere((e) => e.id == leaveId);
    if (index != -1) {
      final leave = _requests[index];
      
      if (status == LeaveStatus.approved && leave.status != LeaveStatus.approved) {
        final days = leave.endDate.difference(leave.startDate).inDays + 1;
        int casual = _balance.casual;
        int sick = _balance.sick;
        int earned = _balance.earned;

        if (leave.type == LeaveType.casual) casual -= days;
        if (leave.type == LeaveType.sick) sick -= days;
        if (leave.type == LeaveType.earned) earned -= days;

        _balance = LeaveBalanceModel(casual: casual, sick: sick, earned: earned);
      }
      
      _requests[index] = LeaveModel(
        id: leave.id,
        type: leave.type,
        startDate: leave.startDate,
        endDate: leave.endDate,
        status: status,
        reason: leave.reason,
      );
    }
  }
}

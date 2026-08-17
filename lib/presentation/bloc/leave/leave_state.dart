import 'package:equatable/equatable.dart';
import '../../../domain/entities/leave_entity.dart';

class LeaveState extends Equatable {
  final LeaveBalance leaveBalance;
  final List<LeaveEntity> leaves;
  final int pendingCount;
  final bool isLoading;
  final String? errorMessage;

  const LeaveState({
    this.leaveBalance = const LeaveBalance(casual: 0, sick: 0, earned: 0),
    this.leaves = const [],
    this.pendingCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  LeaveState copyWith({
    LeaveBalance? leaveBalance,
    List<LeaveEntity>? leaves,
    int? pendingCount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LeaveState(
      leaveBalance: leaveBalance ?? this.leaveBalance,
      leaves: leaves ?? this.leaves,
      pendingCount: pendingCount ?? this.pendingCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [leaveBalance, leaves, pendingCount, isLoading, errorMessage];
}

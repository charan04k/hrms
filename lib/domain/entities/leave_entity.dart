import 'package:equatable/equatable.dart';

enum LeaveType { casual, sick, earned }
enum LeaveStatus { pending, approved, rejected }

class LeaveEntity extends Equatable {
  final String id;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveStatus status;
  final String reason;

  const LeaveEntity({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
  });

  @override
  List<Object?> get props => [id, type, startDate, endDate, status, reason];
}

class LeaveBalance extends Equatable {
  final int casual;
  final int sick;
  final int earned;

  const LeaveBalance({
    required this.casual,
    required this.sick,
    required this.earned,
  });

  @override
  List<Object?> get props => [casual, sick, earned];
}

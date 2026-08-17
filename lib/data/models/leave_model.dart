import '../../domain/entities/leave_entity.dart';

class LeaveModel extends LeaveEntity {
  const LeaveModel({
    required super.id,
    required super.type,
    required super.startDate,
    required super.endDate,
    required super.status,
    required super.reason,
  });

  factory LeaveModel.fromEntity(LeaveEntity entity) {
    return LeaveModel(
      id: entity.id,
      type: entity.type,
      startDate: entity.startDate,
      endDate: entity.endDate,
      status: entity.status,
      reason: entity.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.index,
      'reason': reason,
    };
  }

  factory LeaveModel.fromMap(Map<String, dynamic> map) {
    return LeaveModel(
      id: map['id'] as String,
      type: LeaveType.values[map['type'] as int],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      status: LeaveStatus.values[map['status'] as int],
      reason: map['reason'] as String,
    );
  }
}

class LeaveBalanceModel extends LeaveBalance {
  const LeaveBalanceModel({
    required super.casual,
    required super.sick,
    required super.earned,
  });

  Map<String, dynamic> toMap() {
    return {
      'casual': casual,
      'sick': sick,
      'earned': earned,
    };
  }

  factory LeaveBalanceModel.fromMap(Map<String, dynamic> map) {
    return LeaveBalanceModel(
      casual: map['casual'] as int,
      sick: map['sick'] as int,
      earned: map['earned'] as int,
    );
  }
}

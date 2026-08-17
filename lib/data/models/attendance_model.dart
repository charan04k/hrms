import '../../domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.date,
    super.clockInTime,
    super.clockOutTime,
    required super.status,
    super.totalWorkingMinutes,
    super.notes,
  });

  factory AttendanceModel.fromEntity(AttendanceEntity entity) {
    return AttendanceModel(
      date: entity.date,
      clockInTime: entity.clockInTime,
      clockOutTime: entity.clockOutTime,
      status: entity.status,
      totalWorkingMinutes: entity.totalWorkingMinutes,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'clockInTime': clockInTime?.toIso8601String(),
      'clockOutTime': clockOutTime?.toIso8601String(),
      'status': status.index,
      'totalWorkingMinutes': totalWorkingMinutes,
      'notes': notes,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      date: DateTime.parse(map['date']),
      clockInTime: map['clockInTime'] != null ? DateTime.parse(map['clockInTime']) : null,
      clockOutTime: map['clockOutTime'] != null ? DateTime.parse(map['clockOutTime']) : null,
      status: AttendanceStatus.values[map['status'] as int],
      totalWorkingMinutes: map['totalWorkingMinutes'] as int? ?? 0,
      notes: map['notes'] as String?,
    );
  }
}

import 'package:flutter/material.dart';
import '../../../domain/entities/leave_entity.dart';

class ApplyLeaveScreen extends StatelessWidget {
  final LeaveType? initialLeaveType;

  const ApplyLeaveScreen({super.key, this.initialLeaveType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply Leave')),
      body: Center(
        child: Text('Apply Leave Screen ${initialLeaveType?.toString() ?? ""}'),
      ),
    );
  }
}

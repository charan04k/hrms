import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../domain/entities/leave_entity.dart';
import '../../bloc/leave/leave_bloc.dart';
import '../../bloc/leave/leave_event.dart';
import '../../bloc/leave/leave_state.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  LeaveStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  void _loadLeaves() {
    context.read<LeaveBloc>().add(
          LoadLeaveData(
            startDate: _startDate,
            endDate: _endDate,
            status: _selectedStatus,
          ),
        );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadLeaves();
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedStatus = null;
    });
    _loadLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Leave Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          if (_startDate != null || _selectedStatus != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
            ),
        ],
      ),
      body: BlocBuilder<LeaveBloc, LeaveState>(
        builder: (context, state) {
          if (state.isLoading && state.leaves.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.leaves.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.beach_access_outlined, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  const Text('No leave requests found matching filters'),
                  const SizedBox(height: 16),
                  TextButton(onPressed: _clearFilters, child: const Text('Clear Filters')),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.leaves.length,
            itemBuilder: (context, index) {
              final leave = state.leaves[index];
              return _LeaveRequestItem(leave: leave);
            },
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter Leaves', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Status'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: LeaveStatus.values.map((status) {
                  final isSelected = _selectedStatus == status;
                  return ChoiceChip(
                    label: Text(status.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() => _selectedStatus = selected ? status : null);
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date Range'),
                subtitle: Text(_startDate == null ? 'Select range' : '${DateTimeUtils.formatDate(_startDate!)} - ${DateTimeUtils.formatDate(_endDate!)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  await _selectDateRange(context);
                  setModalState(() {});
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _loadLeaves();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaveRequestItem extends StatelessWidget {
  final LeaveEntity leave;

  const _LeaveRequestItem({required this.leave});

  void _showSimulationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Simulate Admin Action',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SimButton(
                  label: 'Approve',
                  icon: Icons.check_circle_outline,
                  color: AppColors.present,
                  onTap: () {
                    context.read<LeaveBloc>().add(
                          UpdateLeaveStatusRequested(leave.id, LeaveStatus.approved),
                        );
                    Navigator.pop(context);
                  },
                ),
                _SimButton(
                  label: 'Reject',
                  icon: Icons.cancel_outlined,
                  color: AppColors.absent,
                  onTap: () {
                    context.read<LeaveBloc>().add(
                          UpdateLeaveStatusRequested(leave.id, LeaveStatus.rejected),
                        );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (leave.status) {
      case LeaveStatus.approved:
        statusColor = AppColors.present;
        break;
      case LeaveStatus.rejected:
        statusColor = AppColors.absent;
        break;
      default:
        statusColor = AppColors.pending;
    }

    return InkWell(
      onLongPress: leave.status == LeaveStatus.pending ? () => _showSimulationDialog(context) : null,
      onTap: () => _showDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leave.type.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    leave.status.name.toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateTimeUtils.formatDate(leave.startDate)} - ${DateTimeUtils.formatDate(leave.endDate)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              leave.reason,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${leave.type.name.toUpperCase()} Leave'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dates: ${DateTimeUtils.formatDate(leave.startDate)} to ${DateTimeUtils.formatDate(leave.endDate)}'),
            const SizedBox(height: 8),
            Text('Status: ${leave.status.name.toUpperCase()}'),
            const SizedBox(height: 8),
            const Text('Reason:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(leave.reason),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _SimButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SimButton({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

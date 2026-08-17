import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../bloc/attendance/attendance_bloc.dart';
import '../../bloc/attendance/attendance_event.dart';
import '../../bloc/attendance/attendance_state.dart';
import '../../widgets/status_badge.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  AttendanceStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    context.read<AttendanceBloc>().add(
          LoadAttendanceHistory(
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
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadHistory();
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectedStatus = null;
    });
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_alt),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          if (_startDate != null || _selectedStatus != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_startDate != null && _endDate != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Chip(
                label: Text('${DateTimeUtils.formatDate(_startDate!)} - ${DateTimeUtils.formatDate(_endDate!)}'),
                onDeleted: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                  _loadHistory();
                },
              ),
            ),
          Expanded(
            child: BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                if (state.actionStatus == AttendanceActionStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.monthlyHistory.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        const Text('No records found for the selected filter.'),
                        TextButton(onPressed: _clearFilters, child: const Text('Clear Filters')),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.monthlyHistory.length,
                  itemBuilder: (context, index) {
                    final record = state.monthlyHistory[index];
                    return _HistoryItem(record: record);
                  },
                );
              },
            ),
          ),
        ],
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
              const Text('Filter Attendance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('Status'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: AttendanceStatus.values.map((status) {
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
                trailing: const Icon(Icons.calendar_month),
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
                    _loadHistory();
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

class _HistoryItem extends StatelessWidget {
  final AttendanceEntity record;

  const _HistoryItem({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                record.date.day.toString().padLeft(2, '0'),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                DateTimeUtils.formatShortMonth(record.date),
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.login, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      record.clockInTime != null ? DateTimeUtils.formatTime(record.clockInTime!) : '--:--',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.logout, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      record.clockOutTime != null ? DateTimeUtils.formatTime(record.clockOutTime!) : '--:--',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Working Hours: ${Duration(minutes: record.totalWorkingMinutes).inHours}h ${Duration(minutes: record.totalWorkingMinutes).inMinutes % 60}m',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          AttendanceStatusBadge(status: record.status),
        ],
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/leave_entity.dart';
import 'leave_event.dart';
import 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  LeaveBloc() : super(const LeaveState()) {
    on<LoadLeaveData>(_onLoadLeaveData);
  }

  void _onLoadLeaveData(LoadLeaveData event, Emitter<LeaveState> emit) {
    emit(state.copyWith(isLoading: true));
    
    // Mock data
    const mockBalance = LeaveBalance(casual: 12, sick: 8, earned: 15);
    emit(state.copyWith(
      leaveBalance: mockBalance,
      pendingCount: 2,
      isLoading: false,
    ));
  }
}

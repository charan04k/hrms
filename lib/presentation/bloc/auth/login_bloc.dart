import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/auth/login_usecase.dart';
import '../../../domain/usecase/auth/logout_usecase.dart';
import '../../../domain/usecase/auth/check_auth_status_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthInitial()) {
    on<AuthLoginSubmitted>(_onAuthLoginSubmitted);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckStatusRequested>(_onAuthCheckStatusRequested);
  }

  Future<void> _onAuthCheckStatusRequested(
      AuthCheckStatusRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final user = await checkAuthStatusUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }


  Future<void> _onAuthLoginSubmitted(
      AuthLoginSubmitted event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    try {
      final user = await loginUseCase(event.employeeId, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthFailureState(
          errorMessage: 'Invalid Employee ID or Password. Demo: emp001 / password123',
        ));
      }
    } catch (e) {
      emit(AuthFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
      AuthLogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());
    await logoutUseCase();
    emit(const AuthUnauthenticated());
  }
}

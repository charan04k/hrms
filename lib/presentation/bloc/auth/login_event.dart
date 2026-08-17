import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}



class AuthLoginSubmitted extends AuthEvent {
  final String employeeId;
  final String password;

  const AuthLoginSubmitted({
    required this.employeeId,
    required this.password,
  });

  @override
  List<Object?> get props => [employeeId, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCheckStatusRequested extends AuthEvent {
  const AuthCheckStatusRequested();
}

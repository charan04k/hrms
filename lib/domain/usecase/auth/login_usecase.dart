import '../../entities/user_enity.dart';
import '../../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<UserEntity?> call(String employeeId, String password) {
    return repository.login(employeeId, password);
  }
}



import '../entities/user_enity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String employeeId, String password);
  Future<void> logout();
  Future<UserEntity?> getPersistedUser();
}

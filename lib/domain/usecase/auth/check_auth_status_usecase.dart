import '../../entities/user_enity.dart';
import '../../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase({required this.repository});

  Future<UserEntity?> call() {
    return repository.getPersistedUser();
  }
}

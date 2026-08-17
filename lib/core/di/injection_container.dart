import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecase/auth/login_usecase.dart';
import '../../domain/usecase/auth/logout_usecase.dart';
import '../../domain/usecase/auth/check_auth_status_usecase.dart';
import '../../presentation/bloc/auth/login_bloc.dart';
import '../app_constants.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final userBox = await Hive.openBox(AppConstants.userBoxName);

  // 2. DataSources
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(
      sharedPreferences: sl(),
      userBox: userBox,
    ),
  );



  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(localDataSource: sl()),
  );


  // 4. UseCases - Auth
  sl.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(repository: sl()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(repository: sl()),
  );
  sl.registerLazySingleton<CheckAuthStatusUseCase>(
        () => CheckAuthStatusUseCase(repository: sl()),
  );



  // 5. BLoCs
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      checkAuthStatusUseCase: sl(),
    ),
  );



}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hrms_project/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:hrms_project/presentation/bloc/attendance/attendance_event.dart';
import 'package:hrms_project/presentation/bloc/leave/leave_bloc.dart';
import 'package:hrms_project/presentation/bloc/leave/leave_event.dart';
import 'package:hrms_project/presentation/bloc/auth/login_bloc.dart';
import 'package:hrms_project/presentation/bloc/auth/login_event.dart';
import 'package:hrms_project/presentation/bloc/auth/login_state.dart';
import 'package:hrms_project/presentation/main_screen.dart';
import 'package:hrms_project/presentation/screens/auth/login_screen.dart';

import 'core/di/injection_container.dart' as di;
import 'core/theme/app_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await di.initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(const AuthCheckStatusRequested()),
        ),
        BlocProvider<AttendanceBloc>(
          create: (_) => di.sl<AttendanceBloc>()..add(const LoadTodayAttendance()),
        ),
        BlocProvider<LeaveBloc>(
          create: (_) => di.sl<LeaveBloc>()..add(const LoadLeaveData()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Arche HRMS',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const MainNavigationScreen();
        }

        return const LoginScreen();
      },
    );
  }
}

import 'package:dmj_task/config/routes/routes.dart';
import 'package:dmj_task/core/di/di.dart';
import 'package:dmj_task/features/auth/data/data_source/auth_data_source.dart';
import 'package:dmj_task/features/auth/logic/auth_cubit.dart';
import 'package:dmj_task/features/auth/persentation/screen/login_screen.dart';
import 'package:dmj_task/features/auth/persentation/screen/signup_screen.dart';
import 'package:dmj_task/features/home/data/data_source/home_data_source.dart';
import 'package:dmj_task/features/home/logic/home_cubit.dart';
import 'package:dmj_task/features/home/persentation/view/add_task_screen.dart';
import 'package:dmj_task/features/home/persentation/view/home_screen.dart';
import 'package:dmj_task/features/home/persentation/view/update_task_screen.dart';
import 'package:dmj_task/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(getIt<AuthDataSource>()),
            child: const LoginScreen(),
          ),
        );
      case Routes.signup:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AuthCubit(getIt<AuthDataSource>()),
            child: const SignUpScreen(),
          ),
        );
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => AuthCubit(getIt<AuthDataSource>())),
              BlocProvider(
                  create: (context) => HomeCubit(getIt<HomeDataSource>())),
            ],
            child: const HomeScreen(),
          ),
        );
      case Routes.addTask:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeCubit(getIt<HomeDataSource>()),
            child: const AddTaskScreen(),
          ),
        );
      case Routes.updateTask:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => HomeCubit(getIt<HomeDataSource>()),
            child: UpdateTaskScreen(
              date: arguments['date'],
              describtion: arguments['describtion'],
              status: arguments['status'],
              time: arguments['time'],
              title: arguments['title'],
              taskId: arguments['taskId'],
              statusValue: arguments['statusValue'],
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                // style: getMediumStyle(color: Colors.red, fontSize: 14.0),
              ),
            ),
          ),
        );
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:dmj_task/config/local_data/flutter_secure_storage.dart';
import 'package:dmj_task/config/routes/router.dart';
import 'package:dmj_task/config/routes/routes.dart';
import 'package:dmj_task/core/custom_error/custom_error.dart';
import 'package:dmj_task/core/di/di.dart';
import 'package:dmj_task/core/notification/notification_helper.dart';
import 'package:dmj_task/core/shared/no_internet_connection.dart';
import 'package:dmj_task/core/theme/theme_app.dart';
import 'package:dmj_task/core/utils/bloc_observer_class.dart';
import 'package:dmj_task/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper().init();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    FlutterSecureHelper.instance.init(),
    setupGetIt(),
  ]);
  tz.initializeTimeZones();
  Bloc.observer = const BlocObserverState();
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorWidgetClass(details));
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dmj Task',
      theme: ThemeApp.instance.lightTheme,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Stack(
        children: [
          if (child != null) child,
          FutureBuilder<bool>(
            future: InternetConnectionChecker.instance.hasConnection,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }
              final bool initialConnection = snapshot.data ?? false;
              return StreamBuilder<InternetConnectionStatus>(
                stream: InternetConnectionChecker.instance.onStatusChange,
                builder: (context, snapshot) {
                  final isConnected =
                      snapshot.data == InternetConnectionStatus.connected;
                  if (initialConnection || isConnected) return const SizedBox();
                  return const NoInternetWidget();
                },
              );
            },
          ),
        ],
      ),
      initialRoute: Routes.splash,
      onGenerateRoute: AppRouter.generateRoute,
      home: null,
    );
  }
}

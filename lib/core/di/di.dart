import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmj_task/features/auth/data/data_source/auth_data_source.dart';
import 'package:dmj_task/features/auth/logic/auth_cubit.dart';
import 'package:dmj_task/features/home/data/data_source/home_data_source.dart';
import 'package:dmj_task/features/home/logic/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //! Cubit & Data Source
  getIt.registerLazySingleton<AuthDataSource>(
      () => AuthDataSource(getIt(), getIt()));
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  getIt.registerLazySingleton<HomeDataSource>(() => HomeDataSource(getIt()));
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  //! External
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
}

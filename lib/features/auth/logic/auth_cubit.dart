import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dmj_task/features/auth/data/data_source/auth_data_source.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthDataSource _authDataSource;
  AuthCubit(this._authDataSource) : super(AuthInitial());

//! Sign Up Cubit
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      emit(SignUpLoading());
      await _authDataSource.signUp(
        email: email,
        password: password,
        username: username,
      );
      emit(SignUpSuccess(message: "Done Create Account"));
    } on Exception catch (ex) {
      emit(SignUpError(error: ex.toString()));
    }
  }

  //! Login Cubit
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(LoginLoading());
      await _authDataSource.signIn(
        email: email,
        password: password,
      );
      emit(LoginSuccess(message: "Login Successfully"));
    } on Exception catch (ex) {
      emit(LoginError(error: ex.toString()));
    }
  }

  //! Sign Out State Cubit
  Future<void> signOut() async {
    try {
      emit(SignOutLoading());
      await _authDataSource.signOut();
      emit(SignOutSuccess(message: "Sign Out Successfully"));
    } on Exception catch (ex) {
      emit(SignOutError(error: ex.toString()));
    }
  }
}

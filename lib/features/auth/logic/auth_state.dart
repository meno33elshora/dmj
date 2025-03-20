part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

//! Sign Up State
final class SignUpLoading extends AuthState {}

final class SignUpSuccess extends AuthState {
  final String message;

  SignUpSuccess({required this.message});
}

final class SignUpError extends AuthState {
  final String error;

  SignUpError({required this.error});
}

//! Login State
final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {
  final String message;

  LoginSuccess({required this.message});
}

final class LoginError extends AuthState {
  final String error;

  LoginError({required this.error});
}

//! Sign Out State
final class SignOutLoading extends AuthState {}

final class SignOutSuccess extends AuthState {
  final String message;

  SignOutSuccess({required this.message});
}

final class SignOutError extends AuthState {
  final String error;

  SignOutError({required this.error});
}

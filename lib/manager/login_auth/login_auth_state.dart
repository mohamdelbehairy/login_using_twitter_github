part of 'login_auth_cubit.dart';

sealed class LoginAuthState {}

final class LoginAuthInitial extends LoginAuthState {}

final class LoginAuthLoading extends LoginAuthState {}

final class LoginWithTwitter extends LoginAuthState {}

final class LoginAuthFailure extends LoginAuthState {
  final String errorMessage;

  LoginAuthFailure({required this.errorMessage});
}

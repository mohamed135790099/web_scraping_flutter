part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoadingState extends LoginState {}

final class LoadedState extends LoginState{
  final String message;
  LoadedState(this.message);
}

final class ErrorState extends LoginState{
  final String errorMessage;
  ErrorState(this.errorMessage);
}

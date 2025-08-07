
import '../../../models/Auth/Login.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AccessToken accessData;
  LoginSuccess(this.accessData);
}


class LoginNotVerified extends LoginState {}


class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

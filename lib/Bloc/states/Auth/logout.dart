import '../../../models/Auth/logout.dart';


abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {
  final LogoutResponse response;
  LogoutSuccess(this.response);
}

class LogoutFailure extends LogoutState {
  final String error;
  LogoutFailure(this.error);
}

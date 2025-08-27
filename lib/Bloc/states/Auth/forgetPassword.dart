import 'package:equatable/equatable.dart';

import '../../../models/Auth/forgetPassword.dart';


abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse data;
  const ForgotPasswordSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;
  const ForgotPasswordFailure(this.error);
  @override
  List<Object?> get props => [error];
}

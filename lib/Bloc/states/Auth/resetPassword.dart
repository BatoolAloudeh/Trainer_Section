import 'package:equatable/equatable.dart';
import '../../../models/Auth/resetPassword.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();
  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final ResetPasswordResponse data;
  const ResetPasswordSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String error;
  const ResetPasswordFailure(this.error);
  @override
  List<Object?> get props => [error];
}

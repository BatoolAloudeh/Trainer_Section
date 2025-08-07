
import 'package:equatable/equatable.dart';

import '../../../models/Auth/checkCode.dart';

abstract class CheckCodeState extends Equatable {
  const CheckCodeState();

  @override
  List<Object?> get props => [];
}

class CheckCodeInitial extends CheckCodeState {}

class CheckCodeLoading extends CheckCodeState {}

class CheckCodeSuccess extends CheckCodeState {
  final CheckCodeModel data;
  const CheckCodeSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class CheckCodeError extends CheckCodeState {
  final String error;
  const CheckCodeError(this.error);

  @override
  List<Object?> get props => [error];
}

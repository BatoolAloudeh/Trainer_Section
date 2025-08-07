// lib/bloc/states/tests/quiz_operation_state.dart

abstract class QuizOperationState {}

class QuizOperationInitial extends QuizOperationState {}

class QuizOperationLoading extends QuizOperationState {}

class QuizOperationSuccess extends QuizOperationState {
  final String message;
  QuizOperationSuccess(this.message);
}

class QuizOperationFailure extends QuizOperationState {
  final String error;
  QuizOperationFailure(this.error);
}

import '../../../models/tests/create test.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading  extends QuizState {}

class QuizSuccess  extends QuizState {
  final QuizResponse quiz;
  QuizSuccess(this.quiz);
}

class QuizFailure  extends QuizState {
  final String error;
  QuizFailure(this.error);
}


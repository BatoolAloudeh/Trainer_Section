// lib/Bloc/states/tests/list_quizzes_state.dart

import '../../../models/tests/GetQuizzesBySectionId.dart';


abstract class ListQuizzesState {}

class ListQuizzesInitial extends ListQuizzesState {}

class ListQuizzesLoading extends ListQuizzesState {}

class ListQuizzesLoaded extends ListQuizzesState {
  final QuizzesBySectionResponse response;
  ListQuizzesLoaded(this.response);
}

class ListQuizzesError extends ListQuizzesState {
  final String message;
  ListQuizzesError(this.message);
}

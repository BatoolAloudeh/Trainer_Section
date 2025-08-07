// lib/bloc/forum/forum_state.dart
import 'package:equatable/equatable.dart';

import '../../../models/Forum/Pagination.dart';
import '../../../models/Forum/question.dart';


abstract class ForumState extends Equatable {
  @override List<Object?> get props => [];
}

class ForumInitial          extends ForumState {}
class ForumLoading          extends ForumState {}
class ForumError            extends ForumState {
  final String message;
  ForumError(this.message);
  @override List<Object?> get props => [message];
}


class SectionQuestionsLoaded extends ForumState {
  final PaginatedQuestions page;
  SectionQuestionsLoaded(this.page);
  @override List<Object?> get props => [page];
}

class QuestionCreated       extends ForumState {
  final QuestionModel question;
  QuestionCreated(this.question);
  @override List<Object?> get props => [question];
}


class QuestionUpdated       extends ForumState {
  final QuestionModel question;
  QuestionUpdated(this.question);
  @override List<Object?> get props => [question];
}


class QuestionDeleted       extends ForumState {}


class QuestionLiked         extends ForumState {}


class QuestionUnliked       extends ForumState {}

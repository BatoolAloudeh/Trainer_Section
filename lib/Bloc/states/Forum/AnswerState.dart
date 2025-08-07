// lib/bloc/forum/answer_state.dart
import 'package:equatable/equatable.dart';
import '../../../models/Forum/answer.dart';


abstract class AnswerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnswerInitial    extends AnswerState {}
class AnswerLoading    extends AnswerState {}
class AnswerError      extends AnswerState {
  final String message;
  AnswerError(this.message);
  @override List<Object?> get props => [message];
}

/// عند جلب قائمة الأجوبة
class AnswersLoaded    extends AnswerState {
  final List<AnswerModel> answers;
  AnswersLoaded(this.answers);
  @override List<Object?> get props => [answers];
}


class AnswerCreated    extends AnswerState {}


class AnswerUpdated    extends AnswerState {}


class AnswerDeleted    extends AnswerState {}

class AnswerLiked      extends AnswerState {}

class AnswerUnliked    extends AnswerState {}


class AnswerAccepted   extends AnswerState {}

class AnswerUnaccepted extends AnswerState {}

// lib/models/tests/quiz_question_update.dart

import 'quiz_option_update.dart';

class QuizQuestionUpdate {
  final String question;
  final List<QuizOptionUpdate> options;

  QuizQuestionUpdate({
    required this.question,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options.map((o) => o.toJson()).toList(),
  };
}

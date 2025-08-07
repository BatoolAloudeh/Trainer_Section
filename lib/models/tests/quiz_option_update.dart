// lib/models/tests/quiz_option_update.dart

class QuizOptionUpdate {
  final int id;
  final String option;
  final bool isCorrect;

  QuizOptionUpdate({
    required this.id,
    required this.option,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'option': option,
    'is_correct': isCorrect,
  };
}

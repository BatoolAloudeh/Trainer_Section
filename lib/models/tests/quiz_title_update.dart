// lib/models/tests/quiz_title_update.dart

class QuizTitleUpdate {
  final String title;
  QuizTitleUpdate({required this.title});
  Map<String, dynamic> toJson() => {
    'title': title,
  };
}

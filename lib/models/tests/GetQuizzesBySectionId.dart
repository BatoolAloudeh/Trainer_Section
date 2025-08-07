// lib/models/tests/quizzes_by_section.dart

class QuizOptionDetail {
  final int id;
  final String option;
  final bool isCorrect;
  final int selectedCount;
  final int quizQuestionId;

  QuizOptionDetail({
    required this.id,
    required this.option,
    required this.isCorrect,
    required this.selectedCount,
    required this.quizQuestionId,
  });

  factory QuizOptionDetail.fromJson(Map<String, dynamic> json) {
    return QuizOptionDetail(
      id: json['id'] as int,
      option: json['option'] as String,
      isCorrect: (json['is_correct'] as num) == 1,
      selectedCount: json['selected_count'] as int,
      quizQuestionId: json['quiz_question_id'] as int,
    );
  }
}

class QuizQuestionDetail {
  final int id;
  final String question;
  final int quizId;
  final List<QuizOptionDetail> options;

  QuizQuestionDetail({
    required this.id,
    required this.question,
    required this.quizId,
    required this.options,
  });

  factory QuizQuestionDetail.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['quiz_question_option'] as List<dynamic>;
    return QuizQuestionDetail(
      id: json['id'] as int,
      question: json['question'] as String,
      quizId: json['quiz_id'] as int,
      options: rawOptions
          .map((o) => QuizOptionDetail.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizItem {
  final int id;
  final String title;
  final int courseSectionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<QuizQuestionDetail> questions;

  QuizItem({
    required this.id,
    required this.title,
    required this.courseSectionId,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    final rawQuestions = json['quiz_question'] as List<dynamic>;
    return QuizItem(
      id: json['id'] as int,
      title: json['title'] as String,
      courseSectionId: json['course_section_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      questions: rawQuestions
          .map((q) => QuizQuestionDetail.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// يحتوي على صفحة النتائج مع الحقل "data"
class QuizzesData {
  final int currentPage;
  final List<QuizItem> data;
  final int lastPage;
  final int perPage;
  final int total;
  // يمكنك إضافة باقي حقول الـ pagination إذا احتجت

  QuizzesData({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory QuizzesData.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] as List<dynamic>;
    return QuizzesData(
      currentPage: json['current_page'] as int,
      data: raw.map((e) => QuizItem.fromJson(e as Map<String, dynamic>)).toList(),
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }
}

/// الاستجابة الكاملة من السيرفر
class QuizzesBySectionResponse {
  final String message;
  final QuizzesData quizzes;

  QuizzesBySectionResponse({
    required this.message,
    required this.quizzes,
  });

  factory QuizzesBySectionResponse.fromJson(Map<String, dynamic> json) {
    return QuizzesBySectionResponse(
      message: json['message'] as String,
      quizzes: QuizzesData.fromJson(json['Quizzes'] as Map<String, dynamic>),
    );
  }
}

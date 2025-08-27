

// lib/models/tests/create_test.dart

class QuizOption {
  final String option;
  final bool isCorrect;

  QuizOption({ required this.option, required this.isCorrect });

  Map<String, dynamic> toJson() => {
    'option':      option,
    'is_correct':  isCorrect,
  };
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;

  QuizQuestion({ required this.question, required this.options });

  Map<String, dynamic> toJson() => {
    'question': question,
    'options':  options.map((o) => o.toJson()).toList(),
  };
}

class Quiz {
  final String title;
  final int    courseSectionId;
  final List<QuizQuestion> questions;

  Quiz({
    required this.title,
    required this.courseSectionId,
    required this.questions,
  });

  Map<String, dynamic> toJson() => {
    'title':               title,
    'course_section_id':   courseSectionId,
    'questions':           questions.map((q) => q.toJson()).toList(),
  };
}

/// الردّ المرجع من السيرفر
class QuizResponse {
  final int    id;
  final String title;
  final int    courseSectionId;
  final List<QuizQuestionDetail> questions;

  QuizResponse({
    required this.id,
    required this.title,
    required this.courseSectionId,
    required this.questions,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    final quiz = json['quiz'] as Map<String, dynamic>;
    final ql = (quiz['quiz_question'] as List)
        .map((e) => QuizQuestionDetail.fromJson(e as Map<String, dynamic>))
        .toList();
    return QuizResponse(
      id:               quiz['id'] as int,
      title:            quiz['title'] as String,
      courseSectionId:  quiz['course_section_id'] as int,
      questions:        ql,
    );
  }
}

class QuizQuestionDetail {
  final int    id;
  final String question;
  final List<QuizOptionDetail> options;

  QuizQuestionDetail({
    required this.id,
    required this.question,
    required this.options,
  });

  factory QuizQuestionDetail.fromJson(Map<String, dynamic> json) {
    final opts = (json['quiz_question_option'] as List)
        .map((o) => QuizOptionDetail.fromJson(o as Map<String, dynamic>))
        .toList();
    return QuizQuestionDetail(
      id:       json['id'] as int,
      question: json['question'] as String,
      options:  opts,
    );
  }
}

class QuizOptionDetail {
  final int     id;
  final String  option;
  final bool    isCorrect;

  QuizOptionDetail({
    required this.id,
    required this.option,
    required this.isCorrect,
  });

  factory QuizOptionDetail.fromJson(Map<String, dynamic> json) =>
      QuizOptionDetail(
        id:        json['id'] as int,
        option:    json['option'] as String,
        isCorrect: json['is_correct'] == 1 || json['is_correct'] == true,
      );
}

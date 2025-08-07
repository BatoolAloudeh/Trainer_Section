import 'package:trainer_section/models/Forum/question.dart';

class PaginatedQuestions {
  final List<QuestionModel> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedQuestions({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedQuestions.fromJson(Map<String, dynamic> j) {
    final raw = j['data'] as List<dynamic>;
    return PaginatedQuestions(
      data:        raw.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: j['current_page'] as int,
      lastPage:    j['last_page']    as int,
      perPage:     j['per_page']     as int,
      total:       j['total']        as int,
    );
  }
}

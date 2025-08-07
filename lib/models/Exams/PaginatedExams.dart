import 'package:trainer_section/models/Exams/Exam.dart';



class PaginatedExams {
  final List<ExamModel> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedExams({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedExams.fromJson(Map<String, dynamic> j) {
    final raw = j['data'] as List<dynamic>;
    return PaginatedExams(
      data:        raw.map((e) => ExamModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: j['current_page'] as int,
      lastPage:    j['last_page']    as int,
      perPage:     j['per_page']     as int,
      total:       j['total']        as int,
    );
  }
}

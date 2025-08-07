import 'package:trainer_section/models/Grades/Grades.dart';



class PaginatedGrades {
  final List<GradeModel> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedGrades({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedGrades.fromJson(Map<String, dynamic> j) {
    final raw = j['data'] as List<dynamic>;
    return PaginatedGrades(
      data:        raw.map((e) => GradeModel.fromJson(e as Map<String, dynamic>)).toList(),
      currentPage: j['current_page'] as int,
      lastPage:    j['last_page']    as int,
      perPage:     j['per_page']     as int,
      total:       j['total']        as int,
    );
  }
}

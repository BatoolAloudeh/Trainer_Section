import 'package:trainer_section/models/sessions/session.dart';

class PaginatedSessions {
  final List<SessionModel> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginatedSessions({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginatedSessions.fromJson(Map<String, dynamic> j) {
    final raw = (j['data'] as List<dynamic>);
    return PaginatedSessions(
      data: raw
          .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: j['current_page'] as int,
      lastPage: j['last_page'] as int,
      perPage: j['per_page'] as int,
      total: j['total'] as int,
    );
  }
}
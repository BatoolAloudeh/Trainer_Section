class SessionModel {
  final int id;
  final String name;
  final DateTime sessionDate;
  final int courseSectionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SessionModel({
    required this.id,
    required this.name,
    required this.sessionDate,
    required this.courseSectionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> j) => SessionModel(
    id: int.parse(j['id'].toString()),
    name: j['name'] as String,
    sessionDate: DateTime.parse(j['session_date'] as String),
    courseSectionId: int.parse(j['course_section_id'].toString()),
    createdAt: DateTime.parse(j['created_at'] as String),
    updatedAt: DateTime.parse(j['updated_at'] as String),
  );
}
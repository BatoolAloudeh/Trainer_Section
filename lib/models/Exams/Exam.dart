class ExamModel {
  final int       id;
  final String    name;
  final DateTime  examDate;
  final int       courseSectionId;
  final DateTime  createdAt;
  final DateTime  updatedAt;

  ExamModel({
    required this.id,
    required this.name,
    required this.examDate,
    required this.courseSectionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> j) => ExamModel(
    id:                j['id'] as int,
    name:              j['name'] as String,
    examDate:          DateTime.parse(j['exam_date'] as String),
    courseSectionId:   j['course_section_id'] as int,
    createdAt:         DateTime.parse(j['created_at']  as String),
    updatedAt:         DateTime.parse(j['updated_at']  as String),
  );
}

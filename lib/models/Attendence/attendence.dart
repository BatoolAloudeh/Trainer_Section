import 'package:trainer_section/models/Forum/user.dart';


class AttendanceModel {
  final int id;
  final int sessionId;
  final int studentId;
  final bool isPresent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel student;

  AttendanceModel({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.isPresent,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> j) {
    return AttendanceModel(
      id: (j['id'] as num).toInt(),
      sessionId: (j['session_id'] as num).toInt(),
      studentId: (j['student_id'] as num).toInt(),
      isPresent: j['is_present'] as bool,
      createdAt: DateTime.parse(j['created_at'] as String),
      updatedAt: DateTime.parse(j['updated_at'] as String),
      student: UserModel.fromJson(j['student'] as Map<String, dynamic>),
    );
  }
}

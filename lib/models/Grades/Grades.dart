

import 'package:trainer_section/models/Grades/UserForGrade.dart';

class GradeModel {
  final int            id;
  final int            studentId;
  final int            examId;
  final int            trainerId;
  final double         grade;
  final DateTime       createdAt;
  final DateTime       updatedAt;
  final StudentModel   student;
  final TrainerModel   trainer;

  GradeModel({
    required this.id,
    required this.studentId,
    required this.examId,
    required this.trainerId,
    required this.grade,
    required this.createdAt,
    required this.updatedAt,
    required this.student,
    required this.trainer,
  });

  factory GradeModel.fromJson(Map<String, dynamic> j) => GradeModel(
    id:          j['id']          as int,
    studentId:   j['student_id']  as int,
    examId:      j['exam_id']     as int,
    trainerId:   j['trainer_id']  as int,
    grade:       double.parse(j['grade'].toString()),
    createdAt:   DateTime.parse(j['created_at'] as String),
    updatedAt:   DateTime.parse(j['updated_at'] as String),
    student:     StudentModel.fromJson(j['student'] as Map<String, dynamic>),
    trainer:     TrainerModel.fromJson(j['trainer'] as Map<String, dynamic>),
  );
}

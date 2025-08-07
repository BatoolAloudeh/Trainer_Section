import 'package:trainer_section/models/Forum/user.dart';

class LikeAnswerModel {
  final int       id;
  final int       answerId;
  final String    userType;
  final int       userId;
  final DateTime  createdAt;
  final DateTime  updatedAt;
  final UserModel user;

  LikeAnswerModel({
    required this.id,
    required this.answerId,
    required this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory LikeAnswerModel.fromJson(Map<String, dynamic> j) {
    return LikeAnswerModel(
      id:         (j['id'] as num).toInt(),
      answerId:   (j['answer_id'] as num).toInt(),
      userType:   j['user_type'] as String,
      userId:     (j['user_id'] as num).toInt(),
      createdAt:  DateTime.parse(j['created_at'] as String),
      updatedAt:  DateTime.parse(j['updated_at'] as String),
      user:       UserModel.fromJson(j['user'] as Map<String, dynamic>),
    );
  }
}

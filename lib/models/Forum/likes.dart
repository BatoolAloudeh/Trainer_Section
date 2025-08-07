import 'package:trainer_section/models/Forum/user.dart';



class LikeModel {
  final int       id;
  final int       questionId;
  final String    userType;
  final int       userId;
  final DateTime  createdAt;
  final DateTime  updatedAt;
  final UserModel user;

  LikeModel({
    required this.id,
    required this.questionId,
    required this.userType,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory LikeModel.fromJson(Map<String, dynamic> j) {
    return LikeModel(
      id:         (j['id'] as num).toInt(),
      // إذا كانت القيمة null نستخدم 0 كافتراضي
      questionId: (j['question_id'] as num?)?.toInt() ?? 0,
      userType:   j['user_type'] as String,
      userId:     (j['user_id'] as num?)?.toInt() ?? 0,
      createdAt:  DateTime.parse(j['created_at'] as String),
      updatedAt:  DateTime.parse(j['updated_at'] as String),
      user:       UserModel.fromJson(j['user'] as Map<String, dynamic>),
    );
  }

}

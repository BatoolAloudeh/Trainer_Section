import 'package:trainer_section/models/Forum/answer.dart';
import 'package:trainer_section/models/Forum/likes.dart';
import 'package:trainer_section/models/Forum/user.dart';

// lib/models/Forum/question.dart

class QuestionModel {
  final int             id;
  final int             courseSectionId;
  final String          userType;
  final int             userId;
  final String          content;
  final int             likesCount;
  final DateTime        createdAt;
  final DateTime        updatedAt;
  final UserModel       user;
  final List<AnswerModel> answers;
  final List<LikeModel>  likes;

  QuestionModel({
    required this.id,
    required this.courseSectionId,
    required this.userType,
    required this.userId,
    required this.content,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.answers,
    required this.likes,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> j) {
    // لو الحقل فاضي أو مفقود حوّله للقائمة الفارغة
    final rawAnswers = (j['answers'] as List<dynamic>?) ?? [];
    final rawLikes   = (j['likes']   as List<dynamic>?) ?? [];

    return QuestionModel(
      id:              j['id'] as int,
      courseSectionId: j['course_section_id'] as int,
      userType:        j['user_type'] as String,
      userId:          j['user_id'] as int,
      content:         j['content'] as String,
      // لو الـ likes_count مفقود، اعتبره 0
      likesCount:      (j['likes_count'] as int?) ?? 0,
      createdAt:       DateTime.parse(j['created_at'] as String),
      updatedAt:       DateTime.parse(j['updated_at'] as String),
      // لو الـ user مفقود، بننشئ موديل افتراضي (مثلاً للمدرّس الحالي)
      user:            j['user'] != null
          ? UserModel.fromJson(j['user'] as Map<String, dynamic>)
          : UserModel(
          id: j['user_id'] as int,
          name: 'You',
          photo: '', email: '', phone: '' /* أو رابط الصورة الافتراضي */
      ),
      answers: rawAnswers
          .map((a) => AnswerModel.fromJson(a as Map<String, dynamic>))
          .toList(),
      likes: rawLikes
          .map((l) => LikeModel.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }
}

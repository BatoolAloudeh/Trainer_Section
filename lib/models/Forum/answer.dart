import 'package:trainer_section/models/Forum/AnswersLikes.dart';
import 'package:trainer_section/models/Forum/likes.dart';
import 'package:trainer_section/models/Forum/user.dart';

// lib/models/Forum/answer.dart
//
// class AnswerModel {
//   final int            id;
//   final int            questionId;
//   final String         userType;
//   final int            userId;
//   final String         content;
//   final bool           isAccepted;
//   final int            likesCount;
//   final DateTime       createdAt;
//   final DateTime       updatedAt;
//   final UserModel      user;
//   final List<LikeModel> likes;
//
//   AnswerModel({
//     required this.id,
//     required this.questionId,
//     required this.userType,
//     required this.userId,
//     required this.content,
//     required this.isAccepted,
//     required this.likesCount,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.user,
//     required this.likes,
//   });
//
//   factory AnswerModel.fromJson(Map<String, dynamic> j) {
//     final rawLikes = (j['likes'] as List<dynamic>?) ?? [];
//
//     return AnswerModel(
//       id:          (j['id'] as num).toInt(),
//       questionId:  (j['question_id'] as num?)?.toInt() ?? 0,
//       userType:    j['user_type'] as String,
//       userId:      (j['user_id'] as num?)?.toInt() ?? 0,
//       content:     j['content'] as String,
//       isAccepted:  (j['is_accepted'] as bool?) ?? false,
//       likesCount:  (j['likes_count'] as num?)?.toInt() ?? 0,
//       createdAt:   DateTime.parse(j['created_at'] as String),
//       updatedAt:   DateTime.parse(j['updated_at'] as String),
//       user:        UserModel.fromJson(j['user'] as Map<String, dynamic>),
//       likes: rawLikes
//           .map((l) => LikeModel.fromJson(l as Map<String, dynamic>))
//           .toList(),
//     );
//   }
//
// }





class AnswerModel {
  final int                id;
  final int                questionId;
  final String             userType;
  final int                userId;
  final String             content;
  final bool               isAccepted;
  final int                likesCount;
  final DateTime           createdAt;
  final DateTime           updatedAt;
  final UserModel          user;
  final List<LikeAnswerModel> likes;

  AnswerModel({
    required this.id,
    required this.questionId,
    required this.userType,
    required this.userId,
    required this.content,
    required this.isAccepted,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.likes,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> j) {
    final rawLikes = (j['likes'] as List<dynamic>?) ?? [];
    return AnswerModel(
      id:          (j['id'] as num).toInt(),
      questionId:  (j['question_id'] as num).toInt(),
      userType:    j['user_type'] as String,
      userId:      (j['user_id'] as num).toInt(),
      content:     j['content'] as String,
      isAccepted:  (j['is_accepted'] as bool?) ?? false,
      likesCount:  (j['likes_count'] as num?)?.toInt() ?? 0,
      createdAt:   DateTime.parse(j['created_at'] as String),
      updatedAt:   DateTime.parse(j['updated_at'] as String),
      user:        UserModel.fromJson(j['user'] as Map<String, dynamic>),
      likes:       rawLikes
          .map((l) => LikeAnswerModel.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }
}

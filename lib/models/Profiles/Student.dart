// lib/models/student/student_model.dart
class StudentModel {
  final int    id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String birthday;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int    points;
  final int?   referrerId;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.birthday,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.points,
    this.referrerId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id:           json['id'] as int,
      name:         json['name'] as String,
      email:        json['email'] as String,
      phone:        json['phone'] as String,
      photo:        json['photo'] as String?,
      birthday:     json['birthday'] as String,
      gender:       json['gender'] as String,
      createdAt:    DateTime.parse(json['created_at'] as String),
      updatedAt:    DateTime.parse(json['updated_at'] as String),
      points:       json['points'] as int,
      referrerId:   json['referrer_id'] as int?,
    );
  }
}

class TrainerProfileModel {
  final int      id;
  final String   name;
  final String   email;
  final String   phone;
  final String?  photo;
  final String   birthday;
  final String   gender;
  final String   specialization;
  final String   experience;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrainerProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photo,
    required this.birthday,
    required this.gender,
    required this.specialization,
    required this.experience,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrainerProfileModel.fromJson(Map<String, dynamic> json) {
    return TrainerProfileModel(
      id:             json['id'] as int,
      name:           json['name'] as String,
      email:          json['email'] as String,
      phone:          json['phone'] as String,
      photo:          json['photo'] as String?,
      birthday:       json['birthday'] as String,
      gender:         json['gender'] as String,
      specialization: json['specialization'] as String,
      experience:     json['experience'] as String,
      createdAt:      DateTime.parse(json['created_at'] as String),
      updatedAt:      DateTime.parse(json['updated_at'] as String),
    );
  }
}

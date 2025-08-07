class StudentModel {
  final int    id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String birthday;
  final String gender;
  final int    points;
  final int?   referrerId;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.birthday,
    required this.gender,
    required this.points,
    this.referrerId,
  });

  factory StudentModel.fromJson(Map<String, dynamic> j) => StudentModel(
    id: j['id'] as int,
    name: j['name'] as String,
    email: j['email'] as String,
    phone: j['phone'] as String,
    photo: j['photo'] as String,
    birthday: j['birthday'] as String,
    gender: j['gender'] as String,
    points: j['points'] as int,
    referrerId: j['referrer_id'] as int?,
  );
}

class TrainerModel {
  final int    id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String birthday;
  final String gender;
  final String specialization;
  final String experience;

  TrainerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.birthday,
    required this.gender,
    required this.specialization,
    required this.experience,
  });

  factory TrainerModel.fromJson(Map<String, dynamic> j) => TrainerModel(
    id: j['id'] as int,
    name: j['name'] as String,
    email: j['email'] as String,
    phone: j['phone'] as String,
    photo: j['photo'] as String,
    birthday: j['birthday'] as String,
    gender: j['gender'] as String,
    specialization: j['specialization'] as String,
    experience: j['experience'] as String,
  );
}

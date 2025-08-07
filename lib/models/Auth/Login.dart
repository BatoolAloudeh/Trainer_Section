// lib/models/auth/login_model.dart

class LoginModel {
  final String message;
  final AccessToken? accessToken;

  LoginModel({
    required this.message,
    this.accessToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: json['Message'] as String,
      accessToken: json['AccessToken'] != null
          ? AccessToken.fromJson(json['AccessToken'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AccessToken {
  final String accessToken;
  final String tokenType;
  final User user;

  AccessToken({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? photo;
  final String birthday;
  final String gender;
  final String specialization;
  final String experience;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,    // قد تكون null
      birthday: json['birthday'] as String,
      gender: json['gender'] as String,
      specialization: json['specialization'] as String,
      experience: json['experience'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

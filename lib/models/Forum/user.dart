class UserModel {
  final int    id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  // باقي الحقول حسب الحاجة...

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id:    j['id']   as int,
    name:  j['name'] as String,
    email: j['email'] as String,
    phone: j['phone'] as String,
    photo: j['photo'] as String,
  );
}

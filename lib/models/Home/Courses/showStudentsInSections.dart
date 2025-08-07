class StudentsInSectionResponse {
  final List<SectionData> students;

  StudentsInSectionResponse({required this.students});

  factory StudentsInSectionResponse.fromJson(Map<String, dynamic> json) {
    final data = json['students']['data'] as List;
    return StudentsInSectionResponse(
      students: data.map((e) => SectionData.fromJson(e)).toList(),
    );
  }
}

class SectionData {
  final int id;
  final String name;
  final List<Student> students;

  SectionData({required this.id, required this.name, required this.students});

  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      id: json['id'],
      name: json['name'],
      students: (json['students'] as List)
          .map((e) => Student.fromJson(e))
          .toList(),
    );
  }
}

class Student {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String photo;
  final String birthday;
  final String gender;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photo,
    required this.birthday,
    required this.gender,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      photo: json['photo'],
      birthday: json['birthday'],
      gender: json['gender'],
    );
  }
}

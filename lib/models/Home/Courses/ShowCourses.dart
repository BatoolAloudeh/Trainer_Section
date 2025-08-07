class CoursesResponse {
  final String message;
  final List<TrainerCourse> courses;

  CoursesResponse({required this.message, required this.courses});

  factory CoursesResponse.fromJson(Map<String, dynamic> json) {
    return CoursesResponse(
      message: json['message'],
      courses: (json['courses'] as List)
          .map((e) => TrainerCourse.fromJson(e))
          .toList(),
    );
  }
}

class TrainerCourse {
  final int id;
  final String name;
  final int seatsOfNumber;
  final int reservedSeats;
  final String state;
  final DateTime startDate;
  final DateTime endDate;
  final int courseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CourseDetail course;
  final List<WeekDay> weekDays;

  TrainerCourse({
    required this.id,
    required this.name,
    required this.seatsOfNumber,
    required this.reservedSeats,
    required this.state,
    required this.startDate,
    required this.endDate,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    required this.course,
    required this.weekDays,
  });

  factory TrainerCourse.fromJson(Map<String, dynamic> json) {
    return TrainerCourse(
      id: json['id'],
      name: json['name'],
      seatsOfNumber: json['seatsOfNumber'],
      reservedSeats: json['reservedSeats'],
      state: json['state'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      courseId: json['courseId'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      course: CourseDetail.fromJson(json['course']),
      weekDays: (json['week_days'] as List)
          .map((e) => WeekDay.fromJson(e))
          .toList(),
    );
  }
}

class CourseDetail {
  final int id;
  final String name;
  final String description;
  final String photo;
  final int departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      departmentId: json['department_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class WeekDay {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pivot pivot;

  WeekDay({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    return WeekDay(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: Pivot.fromJson(json['pivot']),
    );
  }
}

class Pivot {
  final int courseSectionId;
  final int weekDayId;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pivot({
    required this.courseSectionId,
    required this.weekDayId,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      courseSectionId: json['course_section_id'],
      weekDayId: json['week_day_id'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}




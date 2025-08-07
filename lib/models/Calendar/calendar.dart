import 'dart:convert';

class ScheduleEventResponse {
  final String message;
  final List<ScheduleEventModel> events;

  ScheduleEventResponse({
    required this.message,
    required this.events,
  });

  factory ScheduleEventResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleEventResponse(
      message: json['message'] as String,
      events: (json['Events'] as List<dynamic>)
          .map((e) => ScheduleEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ScheduleEventModel {
  final CourseModel course;
  final SectionModel section;
  final DayModel day;
  final String startTime;
  final String endTime;

  ScheduleEventModel({
    required this.course,
    required this.section,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  factory ScheduleEventModel.fromJson(Map<String, dynamic> json) {
    return ScheduleEventModel(
      course: CourseModel.fromJson(json['course'] as Map<String, dynamic>),
      section:
      SectionModel.fromJson(json['section'] as Map<String, dynamic>),
      day: DayModel.fromJson(json['day'] as Map<String, dynamic>),
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }
}

class CourseModel {
  final int id;
  final String name;
  final String description;
  final String? photo;
  final int departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    required this.id,
    required this.name,
    required this.description,
    this.photo,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      photo: json['photo'] as String?,
      departmentId: json['department_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class SectionModel {
  final int id;
  final String name;
  final int seatsOfNumber;
  final int reservedSeats;
  final String state;
  final String startDate;
  final String endDate;
  final int courseId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SectionModel({
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
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      seatsOfNumber: json['seatsOfNumber'] as int,
      reservedSeats: json['reservedSeats'] as int,
      state: json['state'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      courseId: json['courseId'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class DayModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PivotModel pivot;

  DayModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      pivot: PivotModel.fromJson(json['pivot'] as Map<String, dynamic>),
    );
  }
}

class PivotModel {
  final int courseSectionId;
  final int weekDayId;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  PivotModel({
    required this.courseSectionId,
    required this.weekDayId,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PivotModel.fromJson(Map<String, dynamic> json) {
    return PivotModel(
      courseSectionId: json['course_section_id'] as int,
      weekDayId: json['week_day_id'] as int,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

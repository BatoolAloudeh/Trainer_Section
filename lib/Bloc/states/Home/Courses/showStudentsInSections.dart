import '../../../../models/Home/Courses/showStudentsInSections.dart';

abstract class StudentsInSectionState {}

class StudentsInSectionInitial extends StudentsInSectionState {}

class StudentsInSectionLoading extends StudentsInSectionState {}

class StudentsInSectionLoaded extends StudentsInSectionState {
  final List<SectionData> sections;

  StudentsInSectionLoaded(this.sections);
}

class StudentsInSectionError extends StudentsInSectionState {
  final String message;

  StudentsInSectionError(this.message);
}

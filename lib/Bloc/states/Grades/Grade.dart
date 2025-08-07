import 'package:equatable/equatable.dart';


import '../../../models/Grades/PaginatedGrades.dart';



abstract class GradeState extends Equatable {
  @override List<Object?> get props => [];
}

class GradeInitial   extends GradeState {}
class GradeLoading   extends GradeState {}
class GradeError     extends GradeState {
  final String message;
  GradeError(this.message);
  @override List<Object?> get props => [message];
}
class GradesLoaded   extends GradeState {
  final PaginatedGrades page;
  GradesLoaded(this.page);
  @override List<Object?> get props => [page];
}
class GradeCreated   extends GradeState {}
class GradeUpdated   extends GradeState {}
class GradeDeleted   extends GradeState {}

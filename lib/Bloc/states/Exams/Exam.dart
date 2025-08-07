import 'package:equatable/equatable.dart';

import '../../../models/Exams/Exam.dart';
import '../../../models/Exams/PaginatedExams.dart';


abstract class ExamState extends Equatable {
  @override List<Object?> get props => [];
}

class ExamInitial       extends ExamState {}
class ExamLoading       extends ExamState {}
class ExamError         extends ExamState {
  final String message;
  ExamError(this.message);
  @override List<Object?> get props => [message];
}

class ExamsLoaded       extends ExamState {
  final PaginatedExams page;
  ExamsLoaded(this.page);
  @override List<Object?> get props => [page];
}

class ExamCreated       extends ExamState {
  final ExamModel exam;
  ExamCreated(this.exam);
  @override List<Object?> get props => [exam];
}

class ExamUpdated       extends ExamState {
  final ExamModel exam;
  ExamUpdated(this.exam);
  @override List<Object?> get props => [exam];
}

class ExamDeleted       extends ExamState {}

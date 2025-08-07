import 'package:equatable/equatable.dart';
import '../../../models/Attendence/attendence.dart';


abstract class AttendanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class AttendanceError   extends AttendanceState {
  final String message;
  AttendanceError(this.message);
  @override List<Object?> get props => [message];
}

class AttendanceLoaded  extends AttendanceState {
  final List<AttendanceModel> list;
  AttendanceLoaded(this.list);
  @override List<Object?> get props => [list];
}

class AttendanceMarked  extends AttendanceState {}
class AttendanceUpdated extends AttendanceState {}
class AttendanceDeleted extends AttendanceState {}

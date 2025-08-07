import 'package:equatable/equatable.dart';
import '../../../models/sessions/paginatedSessions.dart';


abstract class SessionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}
class SessionLoading extends SessionState {}
class SessionError extends SessionState {
  final String message;
  SessionError(this.message);
  @override
  List<Object?> get props => [message];
}


class SessionsLoaded extends SessionState {
  final PaginatedSessions page;
  SessionsLoaded(this.page);
  @override
  List<Object?> get props => [page];
}

class SessionCreated extends SessionState {}
class SessionUpdated extends SessionState {}
class SessionDeleted extends SessionState {}
